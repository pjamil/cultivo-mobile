import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/ambiente.dart';
import '../data/ambientes_repository.dart';

enum AmbientesStatus { initial, loading, loaded, error }

class AmbientesState {
  final AmbientesStatus status;
  final List<Ambiente> ambientes;
  final Ambiente? selectedAmbiente;
  final String? error;

  AmbientesState({
    this.status = AmbientesStatus.initial,
    this.ambientes = const [],
    this.selectedAmbiente,
    this.error,
  });

  AmbientesState copyWith({
    AmbientesStatus? status,
    List<Ambiente>? ambientes,
    Ambiente? selectedAmbiente,
    String? error,
  }) {
    return AmbientesState(
      status: status ?? this.status,
      ambientes: ambientes ?? this.ambientes,
      selectedAmbiente: selectedAmbiente,
      error: error,
    );
  }
}

class AmbientesNotifier extends StateNotifier<AmbientesState> {
  final AmbientesRepository _repository;

  AmbientesNotifier(this._repository) : super(AmbientesState()) {
    loadAmbientes();
  }

  Future<void> loadAmbientes() async {
    state = state.copyWith(status: AmbientesStatus.loading);
    try {
      final ambientes = await _repository.getAll();
      state = state.copyWith(
        status: AmbientesStatus.loaded,
        ambientes: ambientes,
      );
    } catch (e) {
      state = state.copyWith(
        status: AmbientesStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadAmbiente(int id) async {
    state = state.copyWith(status: AmbientesStatus.loading);
    try {
      final ambiente = await _repository.getById(id);
      state = state.copyWith(
        status: AmbientesStatus.loaded,
        selectedAmbiente: ambiente,
      );
    } catch (e) {
      state = state.copyWith(
        status: AmbientesStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createAmbiente(Ambiente ambiente) async {
    state = state.copyWith(status: AmbientesStatus.loading);
    try {
      final newAmbiente = await _repository.create(ambiente);
      state = state.copyWith(
        status: AmbientesStatus.loaded,
        ambientes: [...state.ambientes, newAmbiente],
      );
    } catch (e) {
      state = state.copyWith(
        status: AmbientesStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateAmbiente(Ambiente ambiente) async {
    state = state.copyWith(status: AmbientesStatus.loading);
    try {
      final updatedAmbiente = await _repository.update(ambiente);
      state = state.copyWith(
        status: AmbientesStatus.loaded,
        ambientes: state.ambientes.map((a) =>
            a.id == updatedAmbiente.id ? updatedAmbiente : a).toList(),
        selectedAmbiente: updatedAmbiente,
      );
    } catch (e) {
      state = state.copyWith(
        status: AmbientesStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAmbiente(int id) async {
    state = state.copyWith(status: AmbientesStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: AmbientesStatus.loaded,
        ambientes: state.ambientes.where((a) => a.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: AmbientesStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final ambientesProvider =
    StateNotifierProvider<AmbientesNotifier, AmbientesState>((ref) {
  final repository = ref.watch(ambientesRepositoryProvider);
  return AmbientesNotifier(repository);
});
