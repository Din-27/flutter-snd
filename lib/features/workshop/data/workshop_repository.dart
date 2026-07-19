import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/models/api_models.dart';

class WorkshopRepository {
  WorkshopRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ApiResult<List<WorkshopResponse>>> fetchWorkshops() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.workshops);
      final list = _extractList(response);
      final workshops = list
          .map((e) => WorkshopResponse.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess<List<WorkshopResponse>>(workshops);
    } catch (error) {
      return ApiFailure<List<WorkshopResponse>>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    if (response.containsKey('data') && response['data'] is List) {
      return response['data'] as List<dynamic>;
    }
    if (response.containsKey('workshops') && response['workshops'] is List) {
      return response['workshops'] as List<dynamic>;
    }
    if (response.containsKey('results') && response['results'] is List) {
      return response['results'] as List<dynamic>;
    }
    return <dynamic>[];
  }
}