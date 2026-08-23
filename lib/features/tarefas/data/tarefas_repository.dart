import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/tarefa.dart';
import '../../../core/utils/date_utils.dart';

final tarefasRepositoryProvider = Provider<TarefasRepository>((ref) {
  return TarefasRepository(ref);
});

class TarefasRepository extends CrudRepository<Tarefa> {
  TarefasRepository(super.ref);

  @override
  String get basePath => Endpoints.tarefas;

  @override
  String get resourceName => 'tarefas';

  @override
  String get getAllError => 'Erro ao carregar tarefas';

  @override
  String get getByIdError => 'Erro ao carregar tarefa';

  @override
  String get createError => 'Erro ao criar tarefa';

  @override
  String get updateError => 'Erro ao atualizar tarefa';

  @override
  String get deleteError => 'Erro ao excluir tarefa';

  @override
  Tarefa fromJson(Map<String, dynamic> json) => Tarefa.fromJson(json);

  Future<Tarefa> atualizarRecorrencia(
    int id,
    String recorrencia,
    DateTime? dataFimRecorrencia,
  ) async {
    final response = await api.put(
      Endpoints.tarefaRecorrencia(id),
      queryParameters: {
        'recorrencia': recorrencia,
        if (dataFimRecorrencia != null)
          'dataFimRecorrencia': formatDateOnly(dataFimRecorrencia),
      },
    );
    return Tarefa.fromJson(response.data as Map<String, dynamic>);
  }
}
