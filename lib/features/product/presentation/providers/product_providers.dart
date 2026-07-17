import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/features/product/data/product_repository.dart';
import 'package:shop_and_drive/models/catalog_product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return AppServices.productRepository;
});

final productListProvider =
    StateNotifierProvider.autoDispose<ProductListController, AsyncValue<List<CatalogProduct>>>(
  (ref) {
    final controller = ProductListController(ref.read(productRepositoryProvider));
    controller.loadProducts();
    return controller;
  },
);

class ProductListController extends StateNotifier<AsyncValue<List<CatalogProduct>>> {
  ProductListController(this._productRepository) : super(const AsyncValue.loading());

  final ProductRepository _productRepository;

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    final result = await _productRepository.fetchProducts();

    state = result.when(
      success: (products) => AsyncValue.data(products),
      failure: (message) => AsyncValue.error(message, StackTrace.current),
    );
  }
}
