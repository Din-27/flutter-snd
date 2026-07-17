import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/loading/product_skeleton.dart';
import 'package:shop_and_drive/components/product/product_grid_card.dart';
import 'package:shop_and_drive/components/product/product_list_card.dart';
import 'package:shop_and_drive/features/product/presentation/providers/product_providers.dart';
import 'package:shop_and_drive/models/catalog_product.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  static const _chips = ['Semua', 'Sparepart', 'Oli Mesin', 'Aksesoris'];

  String _selectedChip = _chips.first;
  bool _isGridLayout = true;

  List<CatalogProduct> _filteredProducts(List<CatalogProduct> source) {
    if (_selectedChip == 'Semua') {
      return source;
    }
    return source.where((p) => p.category == _selectedChip).toList();
  }

  String _formatRupiah(int amount) {
    final asString = amount.toString();
    final buffer = StringBuffer();
    var count = 0;

    for (var i = asString.length - 1; i >= 0; i--) {
      buffer.write(asString[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  void _openCheckout(CatalogProduct product) {
    final encodedName = Uri.encodeComponent(product.name);
    context.go('/checkout?product=$encodedName&amount=${product.price}');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<CatalogProduct>>>(productListProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    final productState = ref.watch(productListProvider);
    final products = productState.valueOrNull ?? const <CatalogProduct>[];
    final filteredProducts = _filteredProducts(products);

    return AppPageScaffold(
      title: 'Produk',
      currentIndex: 1,
      actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridLayout = !_isGridLayout;
              });
            },
            icon: Icon(_isGridLayout ? Icons.view_stream_rounded : Icons.grid_view_rounded),
          ),
        ],
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final chip = _chips[index];
                final selected = chip == _selectedChip;
                return ChoiceChip(
                  label: Text(chip),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedChip = chip;
                    });
                  },
                  selectedColor: const Color(0xFFFFF0EE),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemCount: _chips.length,
            ),
          ),
          Expanded(
            child: productState.isLoading
              ? const ProductSkeleton()
              : _isGridLayout
                ? GridView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductGridCard(
                        product: product,
                        priceText: _formatRupiah(product.price),
                        onCheckout: () => _openCheckout(product),
                      );
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                    itemCount: filteredProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductListCard(
                        product: product,
                        priceText: _formatRupiah(product.price),
                        onCheckout: () => _openCheckout(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
