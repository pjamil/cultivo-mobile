import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/cultivo.dart';
import '../../../core/models/historico_transicao.dart';
import '../../../core/utils/date_utils.dart';

final cultivosRepositoryProvider = Provider<CultivosRepository>((ref) {
  return CultivosRepository(ref);
});

class CultivosRepository extends CrudRepository<Cultivo> {
  CultivosRepository(super.ref);

  @override
  String get basePath => Endpoints.cultivos;

  @override
  String get resourceName => 'cultivos';

  @override
  String get getAllError => 'Erro ao carregar cultivos';

  @override
  String get getByIdError => 'Erro ao carregar cultivo';

  @override
  String get createError => 'Erro ao criar cultivo';

  @override
  String get updateError => 'Erro ao atualizar cultivo';

  @override
  String get deleteError => 'Erro ao excluir cultivo';

  @override
  Cultivo fromJson(Map<String, dynamic> json) => Cultivo.fromJson(json);

  Future<Cultivo> avancarEstado(int id) async {
    try {
      final response = await api.post(Endpoints.cultivoAvancarEstado(id));
      return Cultivo.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao avançar estado');
    }
  }

  Future<Cultivo> cancelar(int id, String motivo) async {
    try {
      final response = await api.post(
        Endpoints.cultivoCancelar(id),
        data: {'motivo': motivo},
      );
      return Cultivo.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao cancelar cultivo');
    }
  }

  Future<Cultivo> colher(int id, double quantidade, String? notas) async {
    try {
      final response = await api.post(
        Endpoints.cultivoColher(id),
        data: {
          'dataColheita': formatDateOnly(DateTime.now()),
          'quantidade': quantidade,
          'observacoes': notas,
        },
      );
      return Cultivo.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao colher cultivo');
    }
  }

  Future<List<HistoricoTransicao>> listarHistorico(int id) async {
    try {
      final response = await api.get(Endpoints.cultivoHistorico(id));
      final data = response.data;
      if (data is List) {
        return data.map((json) => HistoricoTransicao.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar histórico do cultivo');
    }
  }

  Future<HistoricoTransicao> atualizarDataTransicao(
    int cultivoId,
    int historicoId,
    DateTime novaData,
  ) async {
    try {
      final response = await api.put(
        Endpoints.cultivoHistoricoUpdate(cultivoId, historicoId),
        data: {'dataTransicao': formatDateTime(novaData)},
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Erro ao atualizar data da transição');
      }
      return HistoricoTransicao.fromJson(data);
    } on DioException catch (e) {
      final mensagemServidor = e.response?.data;
      if (mensagemServidor is Map<String, dynamic> &&
          mensagemServidor['message'] is String) {
        throw Exception(mensagemServidor['message']);
      }
      throw Exception(e.error ?? 'Erro ao atualizar data da transição');
    }
  }
}
