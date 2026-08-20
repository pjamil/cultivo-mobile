import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/models/usuario.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});

class AuthRepository {
  final Ref _ref;

  AuthRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);
  SecureStorage get _storage => _ref.read(secureStorageProvider);

  Future<Usuario> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await _api.post(
        Endpoints.login,
        data: {
          'email': email,
          'senha': senha,
        },
      );

      final data = response.data;
      final accessToken = data['accessToken'] ?? data['token'];
      final refreshToken = data['refreshToken'];

      if (accessToken != null) {
        await _storage.setTokens(accessToken, refreshToken ?? '');
      }

      final usuario = await getCurrentUser();
      if (usuario != null) {
        await _storage.setUserInfo(usuario.id, usuario.email);
        return usuario;
      }

      throw Exception('Dados do usuário não encontrados');
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao fazer login');
    }
  }

  Future<Usuario> register({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final response = await _api.post(
        Endpoints.register,
        data: {
          'nome': nome,
          'email': email,
          'senha': senha,
        },
      );

      final data = response.data;
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      final userData = data['user'] ?? data['usuario'];

      if (accessToken != null) {
        await _storage.setTokens(accessToken, refreshToken ?? '');
      }

      if (userData != null) {
        return Usuario.fromJson(userData);
      }

      if (data['id'] != null) {
        return Usuario.fromJson(data);
      }

      // Se não retornar usuário, retorna um básico
      return Usuario(
        id: 0,
        nome: nome,
        email: email,
        papel: 'USUARIO',
      );
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao registrar');
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _api.post(
          Endpoints.refreshToken.replaceAll('/refresh', '/logout'),
          data: {'refreshToken': refreshToken},
        );
      }
    } catch (_) {
      // Ignora falha no logout remoto
    }
    await _storage.removeTokens();
    await _storage.removeUserInfo();
  }

  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }

  Future<Usuario?> getCurrentUser() async {
    try {
      final response = await _api.get(Endpoints.meusDados);
      final data = response.data;
      final userData = data['usuario'] ?? data;
      return Usuario.fromJson(userData);
    } catch (e) {
      return null;
    }
  }
}
