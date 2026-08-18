import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/cultivo.dart';
import '../data/cultivos_repository.dart';

enum CultivosStatus { initial, loading, loaded, error }

class CultivosState {
  final CultivosStatus status;
  final List<Cultivo> cultivos;
  final Cultivo? selectedCultivo;
  final String? error;

  CultivosState({
    this.status = CultivosStatus.initial,
    this.cultivos = const [],
    this.selectedCultivo,
    this.error,
  });

  CultivosState copyWith({
    CultivosStatus? status,
    List<Cultivo>? cultivos,
    Cultivo? selectedCultivo,
    String? error,
  }) {
    return CultivosState(
      status: status ?? this.status,
      cultivos: cultivos ?? this.cultivos,
      selectedCultivo: selectedCultivo,
      error: error,
    );
  }
}

class CultivosNotifier extends StateNotifier<CultivosState> {
  final CultivosRepository _repository;

  CultivosNotifier(this._repository) : super(CultivosState()) {
    loadCultivos();
  }

  Future<void> loadCultivos() async {
    state = state.copyWith(status: CultivosStatus.loading);
    try {
      final cultivos = await _repository.getAll();
      state = state.copyWith(
        status: CultivosStatus.loaded,
        cultivos: cultivos,
      );
    } catch (e) {
      state = state.copyWith(
        status: CultivosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadCultivo(int id) async {
    state = state.copyWith(status: CultivosStatus.loading);
    try {
      final cultivo = await _repository.getById(id);
      state = state.copyWith(
        status: CultivosStatus.loaded,
        selectedCultivo: cultivo,
      );
    } catch (e) {
      state = state.copyWith(
        status: CultivosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createCultivo(Cultivo cultivo) async {
    state = state.copyWith(status: CultivosStatus.loading);
    try {
      final newCultivo = await _repository.create(cultivo);
      state = state.copyWith(
        status: CultivosStatus.loaded,
        cultivos: [...state.cultivos, newCultivo],
      );
    } catch (e) {
      state = state.copyWith(
        status: CultivosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateCultivo(Cultivo cultivo) async {
    state = state.copyWith(status: CultivosStatus.loading);
    try {
      final updatedCultivo = await _repository.update(cultivo);
      state = state.copyWith(
        status: CultivosStatus.loaded,
        cultivos: state.cultivos.map((c) =>
            c.id == updatedCultivo.id ? updatedCultivo : c).toList(),
        selectedCultivo: updatedCultivo,
      );
    } catch (e) {
      state = state.copyWith(
        status: CultivosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteCultivo(int id) async {
    state = state.copyWith(status: CultivosStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: CultivosStatus.loaded,
        cultivos: state.cultivos.where((c) => c.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: CultivosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> avancarEstado(int id) async {
    state = state.copyWith(status: CultivosStatus.loading);
    try {
      final updatedCultivo = await _repository.avancarEstado(id);
      state = state.copyWith(
        status: CultivosStatus.loaded,
        cultivos: state.cultivos.map((c) =>
            c.id == updatedCultivo.id ? updatedCultivo : c).toList(),
        selectedCultivo: updatedCultivo,
      );
    } catch (e) {
      state = state.copyWith(
        status: CultivosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelar(int id, String motivo) async {
    state = state.copyWith(status: CultivosStatus.loading);
    try {
      final updatedCultivo = await _repository.cancelar(id, motivo);
      state = state.copyWith(
        status: CultivosStatus.loaded,
        cultivos: state.cultivos.map((c) =>
            c.id == updatedCultivo.id ? updatedCultivo : c).toList(),
        selectedCultivo: updatedCultivo,
      );
    } catch (e) {
      state = state.copyWith(
        status: CultivosStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final cultivosProvider =
    StateNotifierProvider<CultivosNotifier, CultivosState>((ref) {
  final repository = ref.watch(cultivosRepositoryProvider);
  return CultivosNotifier(repository);
});
