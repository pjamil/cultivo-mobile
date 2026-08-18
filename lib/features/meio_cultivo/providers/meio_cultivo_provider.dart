import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/meio_cultivo.dart';
import '../data/meio_cultivo_repository.dart';

enum MeioCultivoStatus { initial, loading, loaded, error }

class MeioCultivoState {
  final MeioCultivoStatus status;
  final List<MeioCultivo> meiosCultivo;
  final MeioCultivo? selectedMeio;
  final String? error;

  MeioCultivoState({
    this.status = MeioCultivoStatus.initial,
    this.meiosCultivo = const [],
    this.selectedMeio,
    this.error,
  });

  MeioCultivoState copyWith({
    MeioCultivoStatus? status,
    List<MeioCultivo>? meiosCultivo,
    MeioCultivo? selectedMeio,
    String? error,
  }) {
    return MeioCultivoState(
      status: status ?? this.status,
      meiosCultivo: meiosCultivo ?? this.meiosCultivo,
      selectedMeio: selectedMeio,
      error: error,
    );
  }
}

class MeioCultivoNotifier extends StateNotifier<MeioCultivoState> {
  final MeioCultivoRepository _repository;

  MeioCultivoNotifier(this._repository) : super(MeioCultivoState()) {
    loadMeiosCultivo();
  }

  Future<void> loadMeiosCultivo() async {
    state = state.copyWith(status: MeioCultivoStatus.loading);
    try {
      final meios = await _repository.getAll();
      state = state.copyWith(
        status: MeioCultivoStatus.loaded,
        meiosCultivo: meios,
      );
    } catch (e) {
      state = state.copyWith(
        status: MeioCultivoStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMeio(int id) async {
    state = state.copyWith(status: MeioCultivoStatus.loading);
    try {
      final meio = await _repository.getById(id);
      state = state.copyWith(
        status: MeioCultivoStatus.loaded,
        selectedMeio: meio,
      );
    } catch (e) {
      state = state.copyWith(
        status: MeioCultivoStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> createMeio(MeioCultivo meio) async {
    state = state.copyWith(status: MeioCultivoStatus.loading);
    try {
      final newMeio = await _repository.create(meio);
      state = state.copyWith(
        status: MeioCultivoStatus.loaded,
        meiosCultivo: [...state.meiosCultivo, newMeio],
      );
    } catch (e) {
      state = state.copyWith(
        status: MeioCultivoStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateMeio(MeioCultivo meio) async {
    state = state.copyWith(status: MeioCultivoStatus.loading);
    try {
      final updatedMeio = await _repository.update(meio);
      state = state.copyWith(
        status: MeioCultivoStatus.loaded,
        meiosCultivo: state.meiosCultivo.map((m) =>
            m.id == updatedMeio.id ? updatedMeio : m).toList(),
        selectedMeio: updatedMeio,
      );
    } catch (e) {
      state = state.copyWith(
        status: MeioCultivoStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteMeio(int id) async {
    state = state.copyWith(status: MeioCultivoStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: MeioCultivoStatus.loaded,
        meiosCultivo: state.meiosCultivo.where((m) => m.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: MeioCultivoStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final meioCultivoProvider =
    StateNotifierProvider<MeioCultivoNotifier, MeioCultivoState>((ref) {
  final repository = ref.watch(meioCultivoRepositoryProvider);
  return MeioCultivoNotifier(repository);
});
