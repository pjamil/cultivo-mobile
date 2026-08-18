import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/variedade.dart';
import '../data/variedade_repository.dart';

enum VariedadeStatus { initial, loading, loaded, error }

class VariedadeState {
  final VariedadeStatus status;
  final List<Variedade> variedades;
  final Variedade? selectedVariedade;
  final String? error;

  VariedadeState({
    this.status = VariedadeStatus.initial,
    this.variedades = const [],
    this.selectedVariedade,
    this.error,
  });

  VariedadeState copyWith({
    VariedadeStatus? status,
    List<Variedade>? variedades,
    Variedade? selectedVariedade,
    String? error,
  }) {
    return VariedadeState(
      status: status ?? this.status,
      variedades: variedades ?? this.variedades,
      selectedVariedade: selectedVariedade,
      error: error,
    );
  }
}

class VariedadeNotifier extends StateNotifier<VariedadeState> {
  final VariedadeRepository _repository;

  VariedadeNotifier(this._repository) : super(VariedadeState()) {
    loadVariedades();
  }

  Future<void> loadVariedades() async {
    state = state.copyWith(status: VariedadeStatus.loading);
    try {
      final variedades = await _repository.getAll();
      state = state.copyWith(
        status: VariedadeStatus.loaded,
        variedades: variedades,
      );
    } catch (e) {
      state = state.copyWith(
        status: VariedadeStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadVariedade(int id) async {
    state = state.copyWith(status: VariedadeStatus.loading);
    try {
      final variedade = await _repository.getById(id);
      state = state.copyWith(
        status: VariedadeStatus.loaded,
        selectedVariedade: variedade,
      );
    } catch (e) {
      state = state.copyWith(
        status: VariedadeStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createVariedade(Variedade variedade) async {
    state = state.copyWith(status: VariedadeStatus.loading);
    try {
      final newVariedade = await _repository.create(variedade);
      state = state.copyWith(
        status: VariedadeStatus.loaded,
        variedades: [...state.variedades, newVariedade],
      );
    } catch (e) {
      state = state.copyWith(
        status: VariedadeStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateVariedade(Variedade variedade) async {
    state = state.copyWith(status: VariedadeStatus.loading);
    try {
      final updatedVariedade = await _repository.update(variedade);
      state = state.copyWith(
        status: VariedadeStatus.loaded,
        variedades: state.variedades.map((v) =>
            v.id == updatedVariedade.id ? updatedVariedade : v).toList(),
        selectedVariedade: updatedVariedade,
      );
    } catch (e) {
      state = state.copyWith(
        status: VariedadeStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteVariedade(int id) async {
    state = state.copyWith(status: VariedadeStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: VariedadeStatus.loaded,
        variedades: state.variedades.where((v) => v.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: VariedadeStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final variedadeProvider =
    StateNotifierProvider<VariedadeNotifier, VariedadeState>((ref) {
  final repository = ref.read(variedadeRepositoryProvider);
  return VariedadeNotifier(repository);
});
