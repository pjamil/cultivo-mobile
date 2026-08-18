import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/insumo.dart';

final insumosRepositoryProvider = Provider<InsumosRepository>((ref) {
  return InsumosRepository(ref);
});

class InsumosRepository {
  final Ref _ref;

  InsumosRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<Insumo>> getAll() async {
    try {
      final response = await _api.get(Endpoints.insumos);
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
          .map((json) =>Insumo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar insumos');
    }
  }

  Future<Insumo> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.insumoById(id));
      return Insumo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar insumo');
    }
  }

  Future<Insumo> create(Insumo insumo) async {
    try {
      final response = await _api.post(
        Endpoints.insumos,
        data: insumo.toJson()..remove('id'),
      );
      return Insumo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar insumo');
    }
  }

  Future<Insumo> update(Insumo insumo) async {
    try {
      final response = await _api.put(
        Endpoints.insumoById(insumo.id),
        data: insumo.toJson(),
      );
      return Insumo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar insumo');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.insumoById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir insumo');
    }
  }
}
