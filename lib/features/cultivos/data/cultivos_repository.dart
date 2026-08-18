import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/cultivo.dart';

final cultivosRepositoryProvider = Provider<CultivosRepository>((ref) {
  return CultivosRepository(ref);
});

class CultivosRepository {
  final Ref _ref;

  CultivosRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<Cultivo>> getAll() async {
    try {
      final response = await _api.get(Endpoints.cultivos);
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
          .map((json) =>Cultivo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar cultivos');
    }
  }

  Future<Cultivo> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.cultivoById(id));
      return Cultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar cultivo');
    }
  }

  Future<Cultivo> create(Cultivo cultivo) async {
    try {
      final response = await _api.post(
        Endpoints.cultivos,
        data: cultivo.toJson()..remove('id'),
      );
      return Cultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar cultivo');
    }
  }

  Future<Cultivo> update(Cultivo cultivo) async {
    try {
      final response = await _api.put(
        Endpoints.cultivoById(cultivo.id),
        data: cultivo.toJson(),
      );
      return Cultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar cultivo');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.cultivoById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir cultivo');
    }
  }

  Future<Cultivo> avancarEstado(int id) async {
    try {
      final response = await _api.post(Endpoints.cultivoAvancarEstado(id));
      return Cultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao avançar estado');
    }
  }

  Future<Cultivo> cancelar(int id, String motivo) async {
    try {
      final response = await _api.post(
        Endpoints.cultivoCancelar(id),
        data: {'motivo': motivo},
      );
      return Cultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao cancelar cultivo');
    }
  }

  Future<Cultivo> colher(int id, double quantidade, String? notas) async {
    try {
      final response = await _api.post(
        Endpoints.cultivoColher(id),
        data: {
          'quantidade': quantidade,
          'notas': notas,
        },
      );
      return Cultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao colher cultivo');
    }
  }
}
