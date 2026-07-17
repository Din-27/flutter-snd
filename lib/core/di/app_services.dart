import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/session/session_guard.dart';
import 'package:shop_and_drive/core/storage/session_storage.dart';
import 'package:shop_and_drive/features/auth/data/auth_repository.dart';
import 'package:shop_and_drive/features/payment/data/payment_repository.dart';
import 'package:shop_and_drive/features/product/data/product_repository.dart';

class AppServices {
  AppServices._();

  static final SessionStorage _sessionStorage = SessionStorage();
  static final SessionGuard sessionGuard = SessionGuard();

  static final ApiClient _apiClient = ApiClient(
    onUnauthorized: () async {
      await _sessionStorage.clear();
      sessionGuard.markUnauthorized();
    },
  );

  static final AuthRepository authRepository = AuthRepository(
    apiClient: _apiClient,
    storage: _sessionStorage,
  );

  static final PaymentRepository paymentRepository = PaymentRepository(
    apiClient: _apiClient,
  );

  static final ProductRepository productRepository = ProductRepository(
    apiClient: _apiClient,
  );
}
