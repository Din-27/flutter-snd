import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shop_and_drive/core/network/api_endpoints.dart';
import 'package:shop_and_drive/core/network/api_exception.dart';

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 12),
    this.maxRetries = 2,
    this.onUnauthorized,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  final Duration timeout;
  final int maxRetries;
  final Future<void> Function()? onUnauthorized;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
    String? accessToken,
  }) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path').replace(queryParameters: query);
    final response = await _executeWithPolicy(
      () => _httpClient.get(uri, headers: _headers(accessToken)),
    );
    return _parse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
    final response = await _executeWithPolicy(
      () => _httpClient.post(
        uri,
        headers: _headers(accessToken),
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
    );
    return _parse(response);
  }

  Future<http.Response> _executeWithPolicy(
    Future<http.Response> Function() request,
  ) async {
    Object? lastError;

    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await request().timeout(timeout);

        if (_shouldRetryStatus(response.statusCode) && attempt < maxRetries) {
          await Future<void>.delayed(_retryDelay(attempt));
          continue;
        }

        return response;
      } on SocketException catch (e) {
        lastError = e;
        if (attempt >= maxRetries) {
          break;
        }
        await Future<void>.delayed(_retryDelay(attempt));
      } on http.ClientException catch (e) {
        lastError = e;
        if (attempt >= maxRetries) {
          break;
        }
        await Future<void>.delayed(_retryDelay(attempt));
      } on TimeoutException {
        lastError = const ApiException('Request timeout. Coba lagi.', statusCode: 408);
        if (attempt >= maxRetries) {
          break;
        }
        await Future<void>.delayed(_retryDelay(attempt));
      }
    }

    if (lastError is ApiException) {
      throw lastError;
    }

    throw const ApiException('Koneksi bermasalah. Silakan coba lagi.');
  }

  bool _shouldRetryStatus(int statusCode) {
    return statusCode == 408 || statusCode == 429 || (statusCode >= 500 && statusCode <= 599);
  }

  Duration _retryDelay(int attempt) {
    const base = 350;
    return Duration(milliseconds: base * (attempt + 1) * (attempt + 1));
  }

  Map<String, String> _headers(String? accessToken) {
    return {
      'Content-Type': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };
  }

  Map<String, dynamic> _parse(http.Response response) {
    final dynamic decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{'data': decoded};
    }

    final message = decoded is Map<String, dynamic>
        ? (decoded['message']?.toString() ?? 'Request failed')
        : 'Request failed';

    if (response.statusCode == 401) {
      final callback = onUnauthorized;
      if (callback != null) {
        unawaited(callback());
      }
    }

    throw ApiException(message, statusCode: response.statusCode);
  }
}
