import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/diario.dart';
import '../data/diario_repository.dart';

enum DiarioStatus { initial, loading, loaded, error }

class DiarioState {
  final DiarioStatus status;
  final List<DiarioCultivo> diarios;
  final DiarioCultivo? selectedDiario;
  final String? error;

  DiarioState({
    this.status = DiarioStatus.initial,
    this.diarios = const [],
    this.selectedDiario,
    this.error,
  });

  DiarioState copyWith({
    DiarioStatus? status,
    List<DiarioCultivo>? diarios,
    DiarioCultivo? selectedDiario,
    String? error,
  }) {
    return DiarioState(
      status: status ?? this.status,
      diarios: diarios ?? this.diarios,
      selectedDiario: selectedDiario,
      error: error,
    );
  }
}

class DiarioNotifier extends StateNotifier<DiarioState> {
  final DiarioRepository _repository;

  DiarioNotifier(this._repository) : super(DiarioState()) {
    loadDiarios();
  }

  Future<void> loadDiarios() async {
    state = state.copyWith(status: DiarioStatus.loading);
    try {
      final diarios = await _repository.getAll();
      state = state.copyWith(
        status: DiarioStatus.loaded,
        diarios: diarios,
      );
    } catch (e) {
      state = state.copyWith(
        status: DiarioStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadDiario(int id) async {
    state = state.copyWith(status: DiarioStatus.loading);
    try {
      final diario = await _repository.getById(id);
      state = state.copyWith(
        status: DiarioStatus.loaded,
        selectedDiario: diario,
      );
    } catch (e) {
      state = state.copyWith(
        status: DiarioStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createDiario(DiarioCultivo diario) async {
    state = state.copyWith(status: DiarioStatus.loading);
    try {
      final newDiario = await _repository.create(diario);
      state = state.copyWith(
        status: DiarioStatus.loaded,
        diarios: [...state.diarios, newDiario],
      );
    } catch (e) {
      state = state.copyWith(
        status: DiarioStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateDiario(DiarioCultivo diario) async {
    state = state.copyWith(status: DiarioStatus.loading);
    try {
      final updatedDiario = await _repository.update(diario);
      state = state.copyWith(
        status: DiarioStatus.loaded,
        diarios: state.diarios.map((d) =>
            d.id == updatedDiario.id ? updatedDiario : d).toList(),
        selectedDiario: updatedDiario,
      );
    } catch (e) {
      state = state.copyWith(
        status: DiarioStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteDiario(int id) async {
    state = state.copyWith(status: DiarioStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: DiarioStatus.loaded,
        diarios: state.diarios.where((d) => d.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: DiarioStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final diarioProvider =
    StateNotifierProvider<DiarioNotifier, DiarioState>((ref) {
  final repository = ref.watch(diarioRepositoryProvider);
  return DiarioNotifier(repository);
});
