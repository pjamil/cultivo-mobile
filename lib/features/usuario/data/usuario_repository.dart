import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/usuario.dart';

final usuarioRepositoryProvider = Provider<UsuarioRepository>((ref) {
  return UsuarioRepository(ref);
});

class UsuarioRepository {
  final Ref _ref;

  UsuarioRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<Usuario> getMeusDados() async {
    try {
      final response = await _api.get(Endpoints.meusDados);
      final data = response.data;
      final userData = data['usuario'] ?? data;
      return Usuario.fromJson(userData);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar dados');
    }
  }

  Future<Usuario> updateNome(String nome) async {
    try {
      final response = await _api.put(
        Endpoints.meusDados,
        data: {'nome': nome},
      );
      final data = response.data;
      final userData = data['usuario'] ?? data;
      return Usuario.fromJson(userData);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar nome');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _api.delete(Endpoints.minhaConta);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir conta');
    }
  }
}
