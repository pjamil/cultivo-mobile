import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/secure_storage.dart';
import '../api_client.dart';
import '../auth_events.dart';
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
      final newAccessToken = await _tryRefresh();
      if (newAccessToken != null) {
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newAccessToken';
        final clone = await _ref.read(apiClientProvider).dio.fetch(options);
        handler.resolve(clone);
        return;
      }
    } catch (_) {}

    _ref.read(secureStorageProvider).removeTokens();
    _ref.read(authEventsProvider).notifySessionExpired();
    handler.next(err);
  }

  bool _isRefreshRequest(DioException err) {
    return err.requestOptions.path.contains('/auth/');
  }

  Future<String?> _tryRefresh() async {
    final storage = _ref.read(secureStorageProvider);
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _ref
          .read(apiClientProvider)
          .post(Endpoints.refreshToken, data: {'refreshToken': refreshToken});
      final data = response.data;
      final accessToken = data['accessToken'];
      final newRefreshToken = data['refreshToken'];
      if (accessToken == null) return null;
      await storage.setTokens(accessToken, newRefreshToken ?? '');
      return accessToken;
    } catch (_) {
      return null;
    }
  }
}
