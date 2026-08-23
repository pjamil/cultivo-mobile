import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/registro_acao.dart';

final registrosAcaoRepositoryProvider =
    Provider<RegistrosAcaoRepository>((ref) {
  return RegistrosAcaoRepository(ref);
});

class RegistrosAcaoRepository extends CrudRepository<RegistroAcao> {
  RegistrosAcaoRepository(super.ref);

  @override
  String get basePath => Endpoints.registrosAcao;

  @override
  String get resourceName => 'registros-acao';

  @override
  String get getAllError => 'Erro ao carregar registros de ação';

  @override
  String get getByIdError => 'Erro ao carregar registro de ação';

  @override
  String get createError => 'Erro ao criar registro de ação';

  @override
  String get updateError => 'Erro ao atualizar registro de ação';

  @override
  String get deleteError => 'Erro ao excluir registro de ação';

  @override
  RegistroAcao fromJson(Map<String, dynamic> json) =>
      RegistroAcao.fromJson(json);

  Future<List<RegistroAcao>> listarPorCultivo(int cultivoId) async {
    try {
      final response = await api.get(
        basePath,
        queryParameters: {'cultivoId': cultivoId},
      );
      final data = response.data;
      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic> && data['content'] is List) {
        rawList = data['content'] as List;
      } else {
        rawList = [];
      }
      return rawList.map((json) => fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? getAllError);
    }
  }
}
