import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/features/payment/data/payment_repository.dart';
import 'package:shop_and_drive/features/payment/domain/models/payment_result.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return AppServices.paymentRepository;
});

final paymentControllerProvider =
    StateNotifierProvider.autoDispose<PaymentController, AsyncValue<PaymentResult?>>((ref) {
      return PaymentController(ref.read(paymentRepositoryProvider));
    });

class PaymentController extends StateNotifier<AsyncValue<PaymentResult?>> {
  PaymentController(this._paymentRepository) : super(const AsyncValue.data(null));

  final PaymentRepository _paymentRepository;

  Future<void> createPayment({
    required String productName,
    required int amount,
    required String gateway,
  }) async {
    state = const AsyncValue.loading();

    final result = await _paymentRepository.createPayment(
      productName: productName,
      amount: amount,
      gateway: gateway,
    );

    state = result.when(
      success: (payment) => AsyncValue.data(payment),
      failure: (message) => AsyncValue.error(message, StackTrace.current),
    );
  }
}
