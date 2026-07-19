import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/components/loading/product_skeleton.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/components/product/product_grid_card.dart';
import 'package:shop_and_drive/components/product/product_list_card.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/features/product/presentation/providers/product_providers.dart';
import 'package:shop_and_drive/models/api_models.dart';

class ProductScreen extends StatefulWidget {
  final String? initialCategory;
  const ProductScreen({super.key, this.initialCategory});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  static const _chips = ['Semua', 'Sparepart', 'Oli Mesin', 'Aksesoris'];

  late String _selectedChip;
  bool _isGridLayout = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late final ProductCubit _productCubit;

  @override
  void initState() {
    super.initState();
    _selectedChip = widget.initialCategory ?? _chips.first;
    _productCubit = ProductCubit(AppServices.productRepository);
    _productCubit.loadProducts();
  }

  @override
  void dispose() {
    _productCubit.close();
    _searchController.dispose();
    super.dispose();
  }

  List<ProductResponse> _filteredProducts(List<ProductResponse> source) {
    var filtered = source;
    if (_selectedChip != 'Semua') {
      filtered = filtered.where((p) => p.category == _selectedChip).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return filtered;
  }

  String _formatRupiah(int amount) {
    final asString = amount.toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = asString.length - 1; i >= 0; i--) {
      buffer.write(asString[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  void _openDetail(ProductResponse product) {
    context.go('/detail/${product.id}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productCubit,
      child: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state.status == ProductStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, productState) {
            final filteredProducts = _filteredProducts(productState.products);

            return AppPageScaffold(
              title: 'Produk',
              currentIndex: 1,
              actions: [
                IconButton(
                  onPressed: () => setState(() => _isGridLayout = !_isGridLayout),
                  icon: Icon(_isGridLayout ? Icons.view_stream_rounded : Icons.grid_view_rounded),
                ),
              ],
              body: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        hintStyle: TextStyle(color: AppTheme.textSecondary),
                        prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE8EBF1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE8EBF1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  // Filter Chips
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final chip = _chips[index];
                        final selected = chip == _selectedChip;
                        return FilterChip(
                          label: Text(chip),
                          selected: selected,
                          onSelected: (_) => setState(() => _selectedChip = chip),
                          selectedColor: AppTheme.primary,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AppTheme.textPrimary,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: selected ? AppTheme.primary : const Color(0xFFE8EBF1)),
                          ),
                          showCheckmark: false,
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemCount: _chips.length,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Product Grid/List
                  Expanded(
                    child: productState.isLoading
                        ? const ProductSkeleton()
                        : filteredProducts.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off_rounded, size: 64, color: AppTheme.textSecondary),
                                    const SizedBox(height: 12),
                                    Text('Produk tidak ditemukan', style: TextStyle(color: AppTheme.textSecondary)),
                                  ],
                                ),
                              )
                            : _isGridLayout
                                ? GridView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                                    itemCount: filteredProducts.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.72,
                                    ),
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      return ProductGridCard(
                                        product: product,
                                        priceText: _formatRupiah(product.price),
                                        onTap: () => _openDetail(product),
                                      );
                                    },
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                                    itemCount: filteredProducts.length,
                                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      return ProductListCard(
                                        product: product,
                                        priceText: _formatRupiah(product.price),
                                        onTap: () => _openDetail(product),
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}