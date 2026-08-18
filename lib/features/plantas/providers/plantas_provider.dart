import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/planta.dart';
import '../data/plantas_repository.dart';

enum PlantasStatus { initial, loading, loaded, error }

class PlantasState {
  final PlantasStatus status;
  final List<Planta> plantas;
  final Planta? selectedPlanta;
  final String? error;

  PlantasState({
    this.status = PlantasStatus.initial,
    this.plantas = const [],
    this.selectedPlanta,
    this.error,
  });

  PlantasState copyWith({
    PlantasStatus? status,
    List<Planta>? plantas,
    Planta? selectedPlanta,
    String? error,
  }) {
    return PlantasState(
      status: status ?? this.status,
      plantas: plantas ?? this.plantas,
      selectedPlanta: selectedPlanta,
      error: error,
    );
  }
}

class PlantasNotifier extends StateNotifier<PlantasState> {
  final PlantasRepository _repository;

  PlantasNotifier(this._repository) : super(PlantasState()) {
    loadPlantas();
  }

  Future<void> loadPlantas() async {
    state = state.copyWith(status: PlantasStatus.loading);
    try {
      final plantas = await _repository.getAll();
      state = state.copyWith(
        status: PlantasStatus.loaded,
        plantas: plantas,
      );
    } catch (e) {
      state = state.copyWith(
        status: PlantasStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadPlanta(int id) async {
    state = state.copyWith(status: PlantasStatus.loading);
    try {
      final planta = await _repository.getById(id);
      state = state.copyWith(
        status: PlantasStatus.loaded,
        selectedPlanta: planta,
      );
    } catch (e) {
      state = state.copyWith(
        status: PlantasStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createPlanta(Planta planta) async {
    state = state.copyWith(status: PlantasStatus.loading);
    try {
      final newPlanta = await _repository.create(planta);
      state = state.copyWith(
        status: PlantasStatus.loaded,
        plantas: [...state.plantas, newPlanta],
      );
    } catch (e) {
      state = state.copyWith(
        status: PlantasStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updatePlanta(Planta planta) async {
    state = state.copyWith(status: PlantasStatus.loading);
    try {
      final updatedPlanta = await _repository.update(planta);
      state = state.copyWith(
        status: PlantasStatus.loaded,
        plantas: state.plantas.map((p) =>
            p.id == updatedPlanta.id ? updatedPlanta : p).toList(),
        selectedPlanta: updatedPlanta,
      );
    } catch (e) {
      state = state.copyWith(
        status: PlantasStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deletePlanta(int id) async {
    state = state.copyWith(status: PlantasStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: PlantasStatus.loaded,
        plantas: state.plantas.where((p) => p.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: PlantasStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final plantasProvider =
    StateNotifierProvider<PlantasNotifier, PlantasState>((ref) {
  final repository = ref.watch(plantasRepositoryProvider);
  return PlantasNotifier(repository);
});
