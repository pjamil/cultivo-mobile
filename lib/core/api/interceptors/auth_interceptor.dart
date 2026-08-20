import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/secure_storage.dart';
import '../api_client.dart';
import '../endpoints.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _ref.read(secureStorageProvider).getTokenAsync();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401 || _isRefreshRequest(err)) {
      handler.next(err);
      return;
    }

    try {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        final options = err.requestOptions;
        final token = _ref.read(secureStorageProvider).getToken();
        options.headers['Authorization'] = 'Bearer $token';
        final clone = await _ref.read(apiClientProvider).dio.fetch(options);
        handler.resolve(clone);
        return;
      }
    } catch (_) {
      // fallback abaixo
    }

    _ref.read(secureStorageProvider).removeTokens();
    handler.next(err);
  }

  bool _isRefreshRequest(DioException err) {
    return err.requestOptions.path.contains('/auth/');
  }

  Future<bool> _tryRefresh() async {
    final storage = _ref.read(secureStorageProvider);
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await _ref
          .read(apiClientProvider)
          .post(Endpoints.refreshToken, data: {'refreshToken': refreshToken});
      final data = response.data;
      final accessToken = data['accessToken'];
      final newRefreshToken = data['refreshToken'];
      if (accessToken == null) return false;
      await storage.setTokens(accessToken, newRefreshToken ?? '');
      return true;
    } catch (_) {
      return false;
    }
  }
}
