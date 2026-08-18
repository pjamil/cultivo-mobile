import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../core/models/foto.dart';

final fotoServiceProvider = Provider<FotoService>((ref) {
  return FotoService(ref);
});

class FotoService {
  final Ref _ref;

  FotoService(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<Foto>> listarPorEntidade(String entityType, int entityId) async {
    try {
      final response = await _api.get(
        Endpoints.fotosByEntity(entityType, entityId),
      );
      final data = response.data;
      if (data is List) {
        return data.map((json) => Foto.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar fotos');
    }
  }

  Future<Foto> criar(Foto foto) async {
    try {
      final response = await _api.post(
        Endpoints.fotos,
        data: foto.toJson(),
      );
      return Foto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar foto');
    }
  }

  Future<void> excluir(int id) async {
    try {
      await _api.delete(Endpoints.fotoById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir foto');
    }
  }

  Future<Foto> atualizarLegenda(int id, String legenda) async {
    try {
      final response = await _api.put(
        Endpoints.fotoById(id),
        data: {'legenda': legenda},
      );
      return Foto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar foto');
    }
  }
}
