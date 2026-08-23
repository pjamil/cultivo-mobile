import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/tarefa.dart';
import '../data/tarefas_repository.dart';

typedef TarefasState = CrudState<Tarefa>;
typedef TarefasStatus = CrudStatus;

class TarefasNotifier extends CrudNotifier<Tarefa> {
  TarefasNotifier(super.repository);

  Future<void> loadTarefas() => load();

  Future<void> loadTarefa(int id) => loadById(id);

  Future<void> createTarefa(Tarefa tarefa) async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      final newTarefa = await repository.create(tarefa);
      var finalTarefa = newTarefa;
      if (newTarefa.temRecorrencia) {
        finalTarefa =
            await (repository as TarefasRepository).atualizarRecorrencia(
          newTarefa.id,
          newTarefa.recorrencia!,
          newTarefa.dataFimRecorrencia,
        );
      }
      state = state.copyWith(
        status: CrudStatus.loaded,
        items: [...state.items, finalTarefa],
      );
    } catch (e) {
      state = state.copyWith(
        status: CrudStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      var updatedTarefa = await repository.update(tarefa);
      updatedTarefa =
          await (repository as TarefasRepository).atualizarRecorrencia(
        updatedTarefa.id,
        updatedTarefa.recorrencia ?? 'NENHUMA',
        updatedTarefa.dataFimRecorrencia,
      );
      state = state.copyWith(
        status: CrudStatus.loaded,
        items: state.items
            .map((t) => t.id == updatedTarefa.id ? updatedTarefa : t)
            .toList(),
        selected: updatedTarefa,
      );

      if (updatedTarefa.isConcluida && updatedTarefa.temRecorrencia) {
        await _createNextOccurrence(updatedTarefa);
      }
    } catch (e) {
      state = state.copyWith(
        status: CrudStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> _createNextOccurrence(Tarefa completedTarefa) async {
    final nextDate = _calculateNextDate(
      completedTarefa.dataVencimento!,
      completedTarefa.recorrencia!,
    );

    if (nextDate == null) return;

    if (completedTarefa.dataFimRecorrencia != null &&
        nextDate.isAfter(completedTarefa.dataFimRecorrencia!)) {
      return;
    }

    final nextTarefa = Tarefa(
      id: 0,
      titulo: completedTarefa.titulo,
      descricao: completedTarefa.descricao,
      status: 'PENDENTE',
      prioridade: completedTarefa.prioridade,
      dataVencimento: nextDate,
      usuarioId: completedTarefa.usuarioId,
      cultivoId: completedTarefa.cultivoId,
      recorrencia: completedTarefa.recorrencia,
      dataFimRecorrencia: completedTarefa.dataFimRecorrencia,
    );

    try {
      var created = await repository.create(nextTarefa);
      if (created.temRecorrencia) {
        created = await (repository as TarefasRepository).atualizarRecorrencia(
          created.id,
          created.recorrencia!,
          created.dataFimRecorrencia,
        );
      }
      state = state.copyWith(
        items: [...state.items, created],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  DateTime? _calculateNextDate(DateTime current, String recorrencia) {
    switch (recorrencia) {
      case 'DIARIA':
        return current.add(const Duration(days: 1));
      case 'SEMANAL':
        return current.add(const Duration(days: 7));
      case 'QUINZENAL':
        return current.add(const Duration(days: 15));
      case 'MENSAL':
        final nextMonth = current.month + 1;
        final nextYear = nextMonth > 12 ? current.year + 1 : current.year;
        final month = nextMonth > 12 ? 1 : nextMonth;
        return DateTime(nextYear, month, current.day);
      default:
        return null;
    }
  }

  Future<void> deleteTarefa(int id) => delete(id);
}

final tarefasProvider =
    StateNotifierProvider<TarefasNotifier, TarefasState>((ref) {
  final repository = ref.watch(tarefasRepositoryProvider);
  return TarefasNotifier(repository);
});
