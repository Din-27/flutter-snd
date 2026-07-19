import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/core/storage/session_storage.dart';
import 'package:shop_and_drive/models/api_models.dart';

class TrackingRepository {
  TrackingRepository({
    required ApiClient apiClient,
    required SessionStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ApiClient _apiClient;
  final SessionStorage _storage;

  Future<ApiResult<TrackingResponse>> fetchTracking(String orderId) async {
    try {
      final accessToken = await _storage.getAccessToken();
      final response = await _apiClient.get(
        ApiEndpoints.tracking(orderId),
        accessToken: accessToken,
      );
      return ApiSuccess<TrackingResponse>(
        TrackingResponse.fromJson(response),
      );
    } catch (error) {
      return ApiFailure<TrackingResponse>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }
}