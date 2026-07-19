import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_and_drive/core/network/api_client.dart';
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/global_error_handler.dart';
import 'package:shop_and_drive/core/network/api_result.dart';
import 'package:shop_and_drive/core/storage/session_storage.dart';
import 'package:shop_and_drive/features/auth/domain/models/auth_session.dart';
import 'package:shop_and_drive/models/api_models.dart';

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required SessionStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ApiClient _apiClient;
  final SessionStorage _storage;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<ApiResult<AuthSession>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return const ApiFailure<AuthSession>('Login dibatalkan.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Google login via backend API
      final response = await _apiClient.post(
        ApiEndpoints.login,
        body: {
          'idToken': googleAuth.idToken,
          'accessToken': googleAuth.accessToken,
          'provider': 'google',
        },
      );

      final tokenData = AuthTokenResponse.fromJson(response);
      final session = AuthSession(
        userId: tokenData.userId,
        name: tokenData.name,
        email: tokenData.email,
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
      );

      await _storage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      return ApiSuccess<AuthSession>(session);
    } catch (error) {
      if (error is Exception && error.toString().contains('Sign in action cancelled')) {
        return const ApiFailure<AuthSession>('Login Google dibatalkan.');
      }
      return ApiFailure<AuthSession>(GlobalErrorHandler.toUserMessage(error));
    }
  }

  Future<void> logoutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<ApiResult<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        body: {'email': email, 'password': password},
      );

      final tokenData = AuthTokenResponse.fromJson(response);
      final session = AuthSession(
        userId: tokenData.userId,
        name: tokenData.name,
        email: tokenData.email,
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
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
      final response = await _apiClient.post(
        ApiEndpoints.register,
        body: {'name': name, 'email': email, 'password': password},
      );

      final tokenData = AuthTokenResponse.fromJson(response);
      final session = AuthSession(
        userId: tokenData.userId,
        name: tokenData.name,
        email: tokenData.email,
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
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

  Future<ApiResult<CustomerProfileResponse>> getProfile() async {
    try {
      final accessToken = await _storage.getAccessToken();
      final response = await _apiClient.get(
        ApiEndpoints.profile,
        accessToken: accessToken,
      );
      return ApiSuccess<CustomerProfileResponse>(
        CustomerProfileResponse.fromJson(response),
      );
    } catch (error) {
      return ApiFailure<CustomerProfileResponse>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  Future<ApiResult<CustomerProfileResponse>> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      final accessToken = await _storage.getAccessToken();
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;

      final response = await _apiClient.put(
        ApiEndpoints.profile,
        body: body,
        accessToken: accessToken,
      );
      return ApiSuccess<CustomerProfileResponse>(
        CustomerProfileResponse.fromJson(response),
      );
    } catch (error) {
      return ApiFailure<CustomerProfileResponse>(
        GlobalErrorHandler.toUserMessage(error),
      );
    }
  }

  Future<void> logout() => _storage.clear();
}