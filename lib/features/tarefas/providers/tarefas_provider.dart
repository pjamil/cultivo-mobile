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
    } catch (e) {
      state = state.copyWith(
        status: TarefasStatus.error,
        error: e.toString(),
      );
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
