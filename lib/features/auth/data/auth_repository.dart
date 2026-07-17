import 'dart:async';

import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/core/storage/session_storage.dart';
import 'package:shop_and_drive/features/auth/domain/models/auth_session.dart';

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required SessionStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ApiClient _apiClient;
  final SessionStorage _storage;

  Future<ApiResult<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));

      // Template API call:
      // final response = await _apiClient.post(
      //   ApiEndpoints.login,
      //   body: {'email': email, 'password': password},
      // );

      if (email.isEmpty || password.isEmpty || !email.contains('@')) {
        return const ApiFailure<AuthSession>('Email atau password tidak valid.');
      }

      final session = AuthSession(
        userId: 'usr_001',
        name: 'Herdiyana',
        email: email,
        accessToken: 'mock_access_token_123',
        refreshToken: 'mock_refresh_token_123',
      );

      await _storage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      return ApiSuccess<AuthSession>(session);
    } catch (error) {
      return ApiFailure<AuthSession>(GlobalErrorHandler.toUserMessage(error));
    }
  }

  Future<ApiResult<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 950));

      // Template API call:
      // final response = await _apiClient.post(
      //   ApiEndpoints.register,
      //   body: {'name': name, 'email': email, 'password': password},
      // );

      if (name.isEmpty || email.isEmpty || password.length < 6) {
        return const ApiFailure<AuthSession>('Data registrasi belum valid.');
      }

      final session = AuthSession(
        userId: 'usr_002',
        name: name,
        email: email,
        accessToken: 'mock_access_token_new',
        refreshToken: 'mock_refresh_token_new',
      );

      await _storage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      return ApiSuccess<AuthSession>(session);
    } catch (error) {
      return ApiFailure<AuthSession>(GlobalErrorHandler.toUserMessage(error));
    }
  }

  Future<void> logout() => _storage.clear();
}
