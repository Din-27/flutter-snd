import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/features/auth/data/auth_repository.dart';
import 'package:shop_and_drive/features/auth/domain/models/auth_session.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AppServices.authRepository;
});

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, AsyncValue<AuthSession?>>((ref) {
      return LoginController(ref.read(authRepositoryProvider));
    });

final registerControllerProvider =
    StateNotifierProvider.autoDispose<RegisterController, AsyncValue<AuthSession?>>((ref) {
      return RegisterController(ref.read(authRepositoryProvider));
    });

class LoginController extends StateNotifier<AsyncValue<AuthSession?>> {
  LoginController(this._authRepository) : super(const AsyncValue.data(null));

  final AuthRepository _authRepository;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    final result = await _authRepository.login(email: email, password: password);

    state = result.when(
      success: (session) {
        AppServices.sessionGuard.clearUnauthorized();
        return AsyncValue.data(session);
      },
      failure: (message) => AsyncValue.error(message, StackTrace.current),
    );
  }
}

class RegisterController extends StateNotifier<AsyncValue<AuthSession?>> {
  RegisterController(this._authRepository) : super(const AsyncValue.data(null));

  final AuthRepository _authRepository;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );

    state = result.when(
      success: (session) {
        AppServices.sessionGuard.clearUnauthorized();
        return AsyncValue.data(session);
      },
      failure: (message) => AsyncValue.error(message, StackTrace.current),
    );
  }
}
