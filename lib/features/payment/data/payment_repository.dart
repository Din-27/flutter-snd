import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/features/payment/domain/models/payment_result.dart';

class PaymentRepository {
  PaymentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ApiResult<PaymentResult>> createPayment({
    required String productName,
    required int amount,
    required String gateway,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      // Template API call:
      // final response = await _apiClient.post(
      //   ApiEndpoints.createPayment,
      //   body: {
      //     'productName': productName,
      //     'amount': amount,
      //     'gateway': gateway,
      //   },
      // );

      if (amount <= 0) {
        return const ApiFailure<PaymentResult>('Nominal pembayaran tidak valid.');
      }

      final result = PaymentResult(
        orderId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        gateway: gateway,
        status: 'paid',
        paidAt: DateTime.now(),
      );

      return ApiSuccess<PaymentResult>(result);
    } catch (error) {
      return ApiFailure<PaymentResult>(GlobalErrorHandler.toUserMessage(error));
    }
  }
}
