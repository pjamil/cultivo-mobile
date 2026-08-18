import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/tarefa.dart';

final tarefasRepositoryProvider = Provider<TarefasRepository>((ref) {
  return TarefasRepository(ref);
});

class TarefasRepository {
  final Ref _ref;

  TarefasRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<List<Tarefa>> getAll() async {
    try {
      final response = await _api.get(Endpoints.tarefas);
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
          .map((json) =>Tarefa.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar tarefas');
    }
  }

  Future<Tarefa> getById(int id) async {
    try {
      final response = await _api.get(Endpoints.tarefaById(id));
      return Tarefa.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar tarefa');
    }
  }

  Future<Tarefa> create(Tarefa tarefa) async {
    try {
      final response = await _api.post(
        Endpoints.tarefas,
        data: tarefa.toJson()..remove('id'),
      );
      return Tarefa.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao criar tarefa');
    }
  }

  Future<Tarefa> update(Tarefa tarefa) async {
    try {
      final response = await _api.put(
        Endpoints.tarefaById(tarefa.id),
        data: tarefa.toJson(),
      );
      return Tarefa.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao atualizar tarefa');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(Endpoints.tarefaById(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao excluir tarefa');
    }
  }
}
