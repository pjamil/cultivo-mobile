import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/usuario.dart';
import '../data/usuario_repository.dart';

class UsuarioState {
  final LoadStatus status;
  final Usuario? usuario;
  final String? error;

  UsuarioState({
    this.status = LoadStatus.initial,
    this.usuario,
    this.error,
  });

  UsuarioState copyWith({
    LoadStatus? status,
    Usuario? usuario,
    String? error,
  }) {
    return UsuarioState(
      status: status ?? this.status,
      usuario: usuario ?? this.usuario,
      error: error,
    );
  }
}

class UsuarioNotifier extends StateNotifier<UsuarioState> {
  final UsuarioRepository _repository;

  UsuarioNotifier(this._repository) : super(UsuarioState()) {
    loadMeusDados();
  }

  Future<void> loadMeusDados() async {
    state = state.copyWith(status: LoadStatus.loading);
    try {
      final usuario = await _repository.getMeusDados();
      state = state.copyWith(
        status: LoadStatus.loaded,
        usuario: usuario,
      );
    } catch (e) {
      state = state.copyWith(
        status: LoadStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateNome(String nome) async {
    state = state.copyWith(status: LoadStatus.loading);
    try {
      final usuario = await _repository.updateNome(nome);
      state = state.copyWith(
        status: LoadStatus.loaded,
        usuario: usuario,
      );
    } catch (e) {
      state = state.copyWith(
        status: LoadStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(status: LoadStatus.loading);
    try {
      await _repository.deleteAccount();
      state = UsuarioState(status: LoadStatus.loaded);
    } catch (e) {
      state = state.copyWith(
        status: LoadStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final usuarioProvider = StateNotifierProvider<UsuarioNotifier, UsuarioState>(
  (ref) {
    final repository = ref.watch(usuarioRepositoryProvider);
    return UsuarioNotifier(repository);
  },
);
