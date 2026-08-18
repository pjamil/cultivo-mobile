import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState {
  final DashboardStatus status;
  final DashboardData? data;
  final String? error;

  DashboardState({
    this.status = DashboardStatus.initial,
    this.data,
    this.error,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardData? data,
    String? error,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRepository _repository;

  DashboardNotifier(this._repository) : super(DashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(status: DashboardStatus.loading);
    try {
      final data = await _repository.getDashboard();
      state = state.copyWith(
        status: DashboardStatus.loaded,
        data: data,
      );
    } catch (e) {
      state = state.copyWith(
        status: DashboardStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository);
});
