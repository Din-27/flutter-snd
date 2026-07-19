import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/features/auth/data/auth_repository.dart';
import 'package:shop_and_drive/features/auth/domain/models/auth_session.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage,
    );
  }
}

class LoginCubit extends Cubit<AuthState> {
  LoginCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _authRepository.login(email: email, password: password);

    result.when(
      success: (session) {
        AppServices.sessionGuard.clearUnauthorized();
        emit(
          state.copyWith(
            status: AuthStatus.success,
            session: session,
            errorMessage: null,
          ),
        );
      },
      failure: (message) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _authRepository.loginWithGoogle();

    result.when(
      success: (session) {
        AppServices.sessionGuard.clearUnauthorized();
        emit(
          state.copyWith(
            status: AuthStatus.success,
            session: session,
            errorMessage: null,
          ),
        );
      },
      failure: (message) {
        // Don't emit failure for cancellation
        if (message != 'Login dibatalkan.' && message != 'Login Google dibatalkan.') {
          emit(
            state.copyWith(
              status: AuthStatus.failure,
              errorMessage: message,
            ),
          );
        } else {
          emit(state.copyWith(status: AuthStatus.initial, errorMessage: null));
        }
      },
    );
  }
}

class RegisterCubit extends Cubit<AuthState> {
  RegisterCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );

    result.when(
      success: (session) {
        AppServices.sessionGuard.clearUnauthorized();
        emit(
          state.copyWith(
            status: AuthStatus.success,
            session: session,
            errorMessage: null,
          ),
        );
      },
      failure: (message) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }
}
