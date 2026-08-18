import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/usuario.dart';
import '../data/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final Usuario? usuario;
  final String? error;

  AuthState({
    this.status = AuthStatus.initial,
    this.usuario,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    Usuario? usuario,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      usuario: usuario ?? this.usuario,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _repository.isLoggedIn();
    if (isLoggedIn) {
      final usuario = await _repository.getCurrentUser();
      if (usuario != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          usuario: usuario,
        );
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login({
    required String email,
    required String senha,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final usuario = await _repository.login(
        email: email,
        senha: senha,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        usuario: usuario,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> register({
    required String nome,
    required String email,
    required String senha,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _repository.register(
        nome: nome,
        email: email,
        senha: senha,
      );
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
