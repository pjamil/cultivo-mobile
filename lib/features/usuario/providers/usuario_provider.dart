import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/usuario.dart';
import '../data/usuario_repository.dart';

enum UsuarioStatus { initial, loading, loaded, error }

class UsuarioState {
  final UsuarioStatus status;
  final Usuario? usuario;
  final String? error;

  UsuarioState({
    this.status = UsuarioStatus.initial,
    this.usuario,
    this.error,
  });

  UsuarioState copyWith({
    UsuarioStatus? status,
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
    state = state.copyWith(status: UsuarioStatus.loading);
    try {
      final usuario = await _repository.getMeusDados();
      state = state.copyWith(
        status: UsuarioStatus.loaded,
        usuario: usuario,
      );
    } catch (e) {
      state = state.copyWith(
        status: UsuarioStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateNome(String nome) async {
    state = state.copyWith(status: UsuarioStatus.loading);
    try {
      final usuario = await _repository.updateNome(nome);
      state = state.copyWith(
        status: UsuarioStatus.loaded,
        usuario: usuario,
      );
    } catch (e) {
      state = state.copyWith(
        status: UsuarioStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(status: UsuarioStatus.loading);
    try {
      await _repository.deleteAccount();
      state = UsuarioState(status: UsuarioStatus.loaded);
    } catch (e) {
      state = state.copyWith(
        status: UsuarioStatus.error,
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
