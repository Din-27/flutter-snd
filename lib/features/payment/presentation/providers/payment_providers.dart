import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/features/payment/data/payment_repository.dart';
import 'package:shop_and_drive/features/payment/domain/models/payment_result.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState {
  const PaymentState({
    this.status = PaymentStatus.initial,
    this.payment,
    this.errorMessage,
  });

  final PaymentStatus status;
  final PaymentResult? payment;
  final String? errorMessage;

  bool get isLoading => status == PaymentStatus.loading;

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentResult? payment,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      payment: payment ?? this.payment,
      errorMessage: errorMessage,
    );
  }
}

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this._paymentRepository) : super(const PaymentState());

  final PaymentRepository _paymentRepository;

  Future<void> createPayment({
    required String productName,
    required int amount,
    required String gateway,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading, errorMessage: null));

    final result = await _paymentRepository.createPayment(
      productName: productName,
      amount: amount,
      gateway: gateway,
    );

    result.when(
      success: (payment) {
        emit(
          state.copyWith(
            status: PaymentStatus.success,
            payment: payment,
            errorMessage: null,
          ),
        );
      },
      failure: (message) {
        emit(
          state.copyWith(
            status: PaymentStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }
}

PaymentRepository getPaymentRepository() => AppServices.paymentRepository;
