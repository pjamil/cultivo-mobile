import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/dashboard_data.dart';
import '../data/dashboard_repository.dart';

class DashboardState {
  final LoadStatus status;
  final DashboardData? data;
  final String? error;

  DashboardState({
    this.status = LoadStatus.initial,
    this.data,
    this.error,
  });

  DashboardState copyWith({
    LoadStatus? status,
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
    state = state.copyWith(status: LoadStatus.loading);
    try {
      final data = await _repository.getDashboard();
      state = state.copyWith(
        status: LoadStatus.loaded,
        data: data,
      );
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

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository);
});
