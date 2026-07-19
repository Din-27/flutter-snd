import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/core/storage/session_storage.dart';
import 'package:shop_and_drive/models/api_models.dart';

class OrderRepository {
  OrderRepository({
    required ApiClient apiClient,
    required SessionStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ApiClient _apiClient;
  final SessionStorage _storage;

  Future<ApiResult<List<OrderResponse>>> fetchOrders() async {
    try {
      final accessToken = await _storage.getAccessToken();
      final response = await _apiClient.get(
        ApiEndpoints.orders,
        accessToken: accessToken,
      );
      final list = _extractList(response);
      final orders = list
          .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess<List<OrderResponse>>(orders);
    } catch (error) {
      return ApiFailure<List<OrderResponse>>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  Future<ApiResult<OrderResponse>> createOrder(
    CreateOrderRequest request,
  ) async {
    try {
      final accessToken = await _storage.getAccessToken();
      final response = await _apiClient.post(
        ApiEndpoints.orders,
        body: request.toJson(),
        accessToken: accessToken,
      );
      return ApiSuccess<OrderResponse>(
        OrderResponse.fromJson(response),
      );
    } catch (error) {
      return ApiFailure<OrderResponse>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  Future<ApiResult<OrderResponse>> fetchOrderDetail(String id) async {
    try {
      final accessToken = await _storage.getAccessToken();
      final response = await _apiClient.get(
        ApiEndpoints.orderDetail(id),
        accessToken: accessToken,
      );
      return ApiSuccess<OrderResponse>(
        OrderResponse.fromJson(response),
      );
    } catch (error) {
      return ApiFailure<OrderResponse>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  Future<ApiResult<OrderResponse>> cancelOrder(String id) async {
    try {
      final accessToken = await _storage.getAccessToken();
      final response = await _apiClient.put(
        ApiEndpoints.orderDetail(id),
        body: {'status': 'cancelled'},
        accessToken: accessToken,
      );
      return ApiSuccess<OrderResponse>(
        OrderResponse.fromJson(response),
      );
    } catch (error) {
      return ApiFailure<OrderResponse>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    if (response.containsKey('data') && response['data'] is List) {
      return response['data'] as List<dynamic>;
    }
    if (response.containsKey('orders') && response['orders'] is List) {
      return response['orders'] as List<dynamic>;
    }
    if (response.containsKey('results') && response['results'] is List) {
      return response['results'] as List<dynamic>;
    }
    return <dynamic>[];
  }
}