import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/insumo.dart';
import '../data/insumos_repository.dart';

enum InsumosStatus { initial, loading, loaded, error }

class InsumosState {
  final InsumosStatus status;
  final List<Insumo> insumos;
  final Insumo? selectedInsumo;
  final String? error;

  InsumosState({
    this.status = InsumosStatus.initial,
    this.insumos = const [],
    this.selectedInsumo,
    this.error,
  });

  InsumosState copyWith({
    InsumosStatus? status,
    List<Insumo>? insumos,
    Insumo? selectedInsumo,
    String? error,
  }) {
    return InsumosState(
      status: status ?? this.status,
      insumos: insumos ?? this.insumos,
      selectedInsumo: selectedInsumo,
      error: error,
    );
  }
}

class InsumosNotifier extends StateNotifier<InsumosState> {
  final InsumosRepository _repository;

  InsumosNotifier(this._repository) : super(InsumosState()) {
    loadInsumos();
  }

  Future<void> loadInsumos() async {
    state = state.copyWith(status: InsumosStatus.loading);
    try {
      final insumos = await _repository.getAll();
      state = state.copyWith(
        status: InsumosStatus.loaded,
        insumos: insumos,
      );
    } catch (e) {
      state = state.copyWith(
        status: InsumosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadInsumo(int id) async {
    state = state.copyWith(status: InsumosStatus.loading);
    try {
      final insumo = await _repository.getById(id);
      state = state.copyWith(
        status: InsumosStatus.loaded,
        selectedInsumo: insumo,
      );
    } catch (e) {
      state = state.copyWith(
        status: InsumosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createInsumo(Insumo insumo) async {
    state = state.copyWith(status: InsumosStatus.loading);
    try {
      final newInsumo = await _repository.create(insumo);
      state = state.copyWith(
        status: InsumosStatus.loaded,
        insumos: [...state.insumos, newInsumo],
      );
    } catch (e) {
      state = state.copyWith(
        status: InsumosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateInsumo(Insumo insumo) async {
    state = state.copyWith(status: InsumosStatus.loading);
    try {
      final updatedInsumo = await _repository.update(insumo);
      state = state.copyWith(
        status: InsumosStatus.loaded,
        insumos: state.insumos.map((i) =>
            i.id == updatedInsumo.id ? updatedInsumo : i).toList(),
        selectedInsumo: updatedInsumo,
      );
    } catch (e) {
      state = state.copyWith(
        status: InsumosStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteInsumo(int id) async {
    state = state.copyWith(status: InsumosStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: InsumosStatus.loaded,
        insumos: state.insumos.where((i) => i.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: InsumosStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final insumosProvider =
    StateNotifierProvider<InsumosNotifier, InsumosState>((ref) {
  final repository = ref.watch(insumosRepositoryProvider);
  return InsumosNotifier(repository);
});
