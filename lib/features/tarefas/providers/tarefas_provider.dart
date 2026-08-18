import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/tarefa.dart';
import '../data/tarefas_repository.dart';

enum TarefasStatus { initial, loading, loaded, error }

class TarefasState {
  final TarefasStatus status;
  final List<Tarefa> tarefas;
  final Tarefa? selectedTarefa;
  final String? error;

  TarefasState({
    this.status = TarefasStatus.initial,
    this.tarefas = const [],
    this.selectedTarefa,
    this.error,
  });

  TarefasState copyWith({
    TarefasStatus? status,
    List<Tarefa>? tarefas,
    Tarefa? selectedTarefa,
    String? error,
  }) {
    return TarefasState(
      status: status ?? this.status,
      tarefas: tarefas ?? this.tarefas,
      selectedTarefa: selectedTarefa,
      error: error,
    );
  }
}

class TarefasNotifier extends StateNotifier<TarefasState> {
  final TarefasRepository _repository;

  TarefasNotifier(this._repository) : super(TarefasState()) {
    loadTarefas();
  }

  Future<void> loadTarefas() async {
    state = state.copyWith(status: TarefasStatus.loading);
    try {
      final tarefas = await _repository.getAll();
      state = state.copyWith(
        status: TarefasStatus.loaded,
        tarefas: tarefas,
      );
    } catch (e) {
      state = state.copyWith(
        status: TarefasStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadTarefa(int id) async {
    state = state.copyWith(status: TarefasStatus.loading);
    try {
      final tarefa = await _repository.getById(id);
      state = state.copyWith(
        status: TarefasStatus.loaded,
        selectedTarefa: tarefa,
      );
    } catch (e) {
      state = state.copyWith(
        status: TarefasStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createTarefa(Tarefa tarefa) async {
    state = state.copyWith(status: TarefasStatus.loading);
    try {
      final newTarefa = await _repository.create(tarefa);
      state = state.copyWith(
        status: TarefasStatus.loaded,
        tarefas: [...state.tarefas, newTarefa],
      );
    } catch (e) {
      state = state.copyWith(
        status: TarefasStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    state = state.copyWith(status: TarefasStatus.loading);
    try {
      final updatedTarefa = await _repository.update(tarefa);
      state = state.copyWith(
        status: TarefasStatus.loaded,
        tarefas: state.tarefas.map((t) =>
            t.id == updatedTarefa.id ? updatedTarefa : t).toList(),
        selectedTarefa: updatedTarefa,
      );

      // Auto-create next occurrence for recurring tasks
      if (updatedTarefa.isConcluida && updatedTarefa.temRecorrencia) {
        await _createNextOccurrence(updatedTarefa);
      }
    } catch (e) {
      state = state.copyWith(
        status: TarefasStatus.error,
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

    // Check if recurrence end date is reached
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
      final created = await _repository.create(nextTarefa);
      state = state.copyWith(
        tarefas: [...state.tarefas, created],
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

  Future<void> deleteTarefa(int id) async {
    state = state.copyWith(status: TarefasStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: TarefasStatus.loaded,
        tarefas: state.tarefas.where((t) => t.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: TarefasStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final tarefasProvider =
    StateNotifierProvider<TarefasNotifier, TarefasState>((ref) {
  final repository = ref.watch(tarefasRepositoryProvider);
  return TarefasNotifier(repository);
});
