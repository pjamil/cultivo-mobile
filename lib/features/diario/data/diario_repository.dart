import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/diario.dart';

final diarioRepositoryProvider = Provider<DiarioRepository>((ref) {
  return DiarioRepository(ref);
});

class DiarioRepository {
  final Ref _ref;

  DiarioRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<DiarioCultivo>> getAll() async {
    try {
      final response = await _api.get(Endpoints.diario);
      final data = response.data;
      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic> && data['content'] is List) {
        rawList = data['content'] as List;
      } else {
        rawList = [];
      }
      return rawList
          .map((json) =>DiarioCultivo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar diários');
    }
  }

  Future<DiarioCultivo> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.diarioById(id));
      return DiarioCultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar diário');
    }
  }

  Future<DiarioCultivo> create(DiarioCultivo diario) async {
    try {
      final response = await _api.post(
        Endpoints.diario,
        data: diario.toJson()..remove('id'),
      );
      return DiarioCultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar diário');
    }
  }

  Future<DiarioCultivo> update(DiarioCultivo diario) async {
    try {
      final response = await _api.put(
        Endpoints.diarioById(diario.id),
        data: diario.toJson(),
      );
      return DiarioCultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar diário');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.diarioById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir diário');
    }
  }
}
