import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/models/api_models.dart';

class PromoRepository {
  PromoRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ApiResult<List<PromoResponse>>> fetchPromos() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.promos);
      final list = _extractList(response);
      final promos = list
          .map((e) => PromoResponse.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess<List<PromoResponse>>(promos);
    } catch (error) {
      return ApiFailure<List<PromoResponse>>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  Future<ApiResult<List<BannerResponse>>> fetchBanners({
    String? position,
  }) async {
    try {
      final query = <String, String>{};
      if (position != null) query['position'] = position;

      final response = await _apiClient.get(
        ApiEndpoints.banners,
        query: query,
      );
      final list = _extractList(response);
      final banners = list
          .map((e) => BannerResponse.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess<List<BannerResponse>>(banners);
    } catch (error) {
      return ApiFailure<List<BannerResponse>>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    if (response.containsKey('data') && response['data'] is List) {
      return response['data'] as List<dynamic>;
    }
    if (response.containsKey('promos') && response['promos'] is List) {
      return response['promos'] as List<dynamic>;
    }
    if (response.containsKey('banners') && response['banners'] is List) {
      return response['banners'] as List<dynamic>;
    }
    if (response.containsKey('results') && response['results'] is List) {
      return response['results'] as List<dynamic>;
    }
    return <dynamic>[];
  }
}