import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/variedade.dart';

final variedadeRepositoryProvider = Provider<VariedadeRepository>((ref) {
  return VariedadeRepository(ref);
});

class VariedadeRepository {
  final Ref _ref;

  VariedadeRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<Variedade>> getAll() async {
    try {
      final response = await _api.get(Endpoints.variedades);
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
          .map((json) =>Variedade.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar variedades');
    }
  }

  Future<Variedade> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.variedadeById(id));
      return Variedade.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar variedade');
    }
  }

  Future<Variedade> create(Variedade variedade) async {
    try {
      final response = await _api.post(
        Endpoints.variedades,
        data: variedade.toJson()..remove('id'),
      );
      return Variedade.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar variedade');
    }
  }

  Future<Variedade> update(Variedade variedade) async {
    try {
      final response = await _api.put(
        Endpoints.variedadeById(variedade.id),
        data: variedade.toJson(),
      );
      return Variedade.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar variedade');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.variedadeById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir variedade');
    }
  }
}
