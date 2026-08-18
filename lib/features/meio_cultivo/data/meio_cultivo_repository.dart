import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/meio_cultivo.dart';

final meioCultivoRepositoryProvider = Provider<MeioCultivoRepository>((ref) {
  return MeioCultivoRepository(ref);
});

class MeioCultivoRepository {
  final Ref _ref;

  MeioCultivoRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<MeioCultivo>> getAll() async {
    try {
      final response = await _api.get(Endpoints.meiosCultivo);
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
          .map((json) =>MeioCultivo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar meios de cultivo');
    }
  }

  Future<MeioCultivo> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.meioCultivoById(id));
      return MeioCultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar meio de cultivo');
    }
  }

  Future<MeioCultivo> create(MeioCultivo meio) async {
    try {
      final response = await _api.post(
        Endpoints.meiosCultivo,
        data: meio.toJson()..remove('id'),
      );
      return MeioCultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar meio de cultivo');
    }
  }

  Future<MeioCultivo> update(MeioCultivo meio) async {
    try {
      final response = await _api.put(
        Endpoints.meioCultivoById(meio.id),
        data: meio.toJson(),
      );
      return MeioCultivo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar meio de cultivo');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.meioCultivoById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir meio de cultivo');
    }
  }
}
