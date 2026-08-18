import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    if (kDebugMode) {
      print('🔴 DioError Type: ${err.type}');
      print('🔴 DioError Message: ${err.message}');
      print('🔴 DioError URL: ${err.requestOptions.uri}');
      print('🔴 DioError Response: ${err.response?.statusCode}');
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Timeout de conexão. Verifique sua internet.';
        break;
      case DioExceptionType.connectionError:
        message = 'Sem conexão com a internet.';
        break;
      case DioExceptionType.badResponse:
        message = _handleBadResponse(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Requisição cancelada.';
        break;
      default:
        message = 'Erro inesperado: ${err.message}';
    }

    final error = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: message,
    );

    handler.next(error);
  }

  String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Dados inválidos. Verifique as informações.';
      case 401:
        return 'Sessão expirada. Faça login novamente.';
      case 403:
        return 'Acesso negado.';
      case 404:
        return 'Recurso não encontrado.';
      case 409:
        return 'Conflito. O recurso já existe.';
      case 422:
        return 'Dados de validação inválidos.';
      case 500:
        return 'Erro interno do servidor.';
      default:
        return 'Erro desconhecido ($statusCode).';
    }
  }
}
