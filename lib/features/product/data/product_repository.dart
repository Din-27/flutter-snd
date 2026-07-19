import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/models/api_models.dart';

class ProductRepository {
  ProductRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ApiResult<List<ProductResponse>>> fetchProducts({
    String? merchantId,
    String? category,
    String? search,
    int page = 1,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
      };
      if (merchantId != null) query['merchantId'] = merchantId;
      if (category != null) query['category'] = category;
      if (search != null) query['search'] = search;

      final response = await _apiClient.get(
        ApiEndpoints.products,
        query: query,
      );

      final list = _extractList(response);
      final products = list
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList();

      return ApiSuccess<List<ProductResponse>>(products);
    } catch (error) {
      return ApiFailure<List<ProductResponse>>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  Future<ApiResult<ProductDetailResponse>> fetchProductDetail(String id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productDetail(id),
      );

      return ApiSuccess<ProductDetailResponse>(
        ProductDetailResponse.fromJson(response),
      );
    } catch (error) {
      return ApiFailure<ProductDetailResponse>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  /// Extracts list from various response shapes:
  /// { data: [...] } or { products: [...] } or direct [...]
  List<dynamic> _extractList(Map<String, dynamic> response) {
    if (response.containsKey('data') && response['data'] is List) {
      return response['data'] as List<dynamic>;
    }
    if (response.containsKey('products') && response['products'] is List) {
      return response['products'] as List<dynamic>;
    }
    if (response.containsKey('results') && response['results'] is List) {
      return response['results'] as List<dynamic>;
    }
    return <dynamic>[];
  }
}