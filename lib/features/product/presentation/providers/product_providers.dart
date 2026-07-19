import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/features/product/data/product_repository.dart';
import 'package:shop_and_drive/models/api_models.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const <ProductResponse>[],
    this.errorMessage,
  });

  final ProductStatus status;
  final List<ProductResponse> products;
  final String? errorMessage;

  bool get isLoading => status == ProductStatus.loading;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductResponse>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage,
    );
  }
}

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._productRepository) : super(const ProductState());

  final ProductRepository _productRepository;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading, errorMessage: null));
    final result = await _productRepository.fetchProducts();

    result.when(
      success: (products) {
        emit(
          state.copyWith(
            status: ProductStatus.success,
            products: products,
            errorMessage: null,
          ),
        );
      },
      failure: (message) {
        emit(
          state.copyWith(
            status: ProductStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }
}

ProductRepository getProductRepository() => AppServices.productRepository;
