import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/planta.dart';

final plantasRepositoryProvider = Provider<PlantasRepository>((ref) {
  return PlantasRepository(ref);
});

class PlantasRepository {
  final Ref _ref;

  PlantasRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<Planta>> getAll() async {
    try {
      final response = await _api.get(Endpoints.plantas);
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
          .map((json) => Planta.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar plantas');
    }
  }

  Future<Planta> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.plantaById(id));
      return Planta.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar planta');
    }
  }

  Future<Planta> create(Planta planta) async {
    try {
      final response = await _api.post(
        Endpoints.plantas,
        data: planta.toJson()..remove('id'),
      );
      return Planta.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar planta');
    }
  }

  Future<Planta> update(Planta planta) async {
    try {
      final response = await _api.put(
        Endpoints.plantaById(planta.id),
        data: planta.toJson(),
      );
      return Planta.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar planta');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.plantaById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir planta');
    }
  }

  Future<Planta> colher(int id, DateTime dataColheita, String? notas) async {
    try {
      final response = await _api.post(
        '/plantas/$id/colher',
        data: {
          'dataColheita': dataColheita.toIso8601String(),
          'notas': notas,
        },
      );
      return Planta.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao colher planta');
    }
  }

  Future<Planta> perder(int id, String motivo) async {
    try {
      final response = await _api.post(
        '/plantas/$id/perder',
        data: {'motivo': motivo},
      );
      return Planta.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao marcar planta como perdida');
    }
  }
}
