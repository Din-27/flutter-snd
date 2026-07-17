import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/models/catalog_product.dart';

class ProductRepository {
  ProductRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ApiResult<List<CatalogProduct>>> fetchProducts() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));

    // Template API call:
    // final response = await _apiClient.get(ApiEndpoints.products);

    const products = [
      CatalogProduct(
        name: 'Brake Pad Ceramic',
        category: 'Sparepart',
        price: 850000,
        imageUrl:
            'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=1200&auto=format&fit=crop',
        rating: 4.8,
      ),
      CatalogProduct(
        name: 'Engine Oil 5W-30',
        category: 'Oli Mesin',
        price: 420000,
        imageUrl:
            'https://images.unsplash.com/photo-1635764702449-71f3fb13f346?q=80&w=1200&auto=format&fit=crop',
        rating: 4.7,
      ),
      CatalogProduct(
        name: 'Portable Jump Starter',
        category: 'Aksesoris',
        price: 1250000,
        imageUrl:
            'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=1200&auto=format&fit=crop',
        rating: 4.9,
      ),
      CatalogProduct(
        name: 'Air Filter Premium',
        category: 'Sparepart',
        price: 280000,
        imageUrl:
            'https://images.unsplash.com/photo-1676319675641-a5376c70f5f6?q=80&w=1200&auto=format&fit=crop',
        rating: 4.6,
      ),
    ];

      return const ApiSuccess<List<CatalogProduct>>(products);
    } catch (error) {
      return ApiFailure<List<CatalogProduct>>(GlobalErrorHandler.toUserMessage(error));
    }
  }
}
