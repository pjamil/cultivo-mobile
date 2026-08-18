import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/ambiente.dart';

final ambientesRepositoryProvider = Provider<AmbientesRepository>((ref) {
  return AmbientesRepository(ref);
});

class AmbientesRepository {
  final Ref _ref;

  AmbientesRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<Ambiente>> getAll() async {
    try {
      final response = await _api.get(Endpoints.ambientes);
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
          .map((json) =>Ambiente.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar ambientes');
    }
  }

  Future<Ambiente> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.ambienteById(id));
      return Ambiente.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar ambiente');
    }
  }

  Future<Ambiente> create(Ambiente ambiente) async {
    try {
      final response = await _api.post(
        Endpoints.ambientes,
        data: ambiente.toJson()..remove('id'),
      );
      return Ambiente.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar ambiente');
    }
  }

  Future<Ambiente> update(Ambiente ambiente) async {
    try {
      final response = await _api.put(
        Endpoints.ambienteById(ambiente.id),
        data: ambiente.toJson(),
      );
      return Ambiente.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar ambiente');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.ambienteById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir ambiente');
    }
  }
}
