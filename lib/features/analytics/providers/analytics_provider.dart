import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/analytics_repository.dart';

enum AnalyticsStatus { initial, loading, loaded, error }

class AnalyticsState {
  final AnalyticsStatus status;
  final AnalyticsData? data;
  final String? error;

  AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.data,
    this.error,
  });

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsData? data,
    String? error,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsNotifier(this._repository) : super(AnalyticsState()) {
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    state = state.copyWith(status: AnalyticsStatus.loading);
    try {
      final data = await _repository.getAnalytics();
      state = state.copyWith(
        status: AnalyticsStatus.loaded,
        data: data,
      );
    } catch (e) {
      state = state.copyWith(
        status: AnalyticsStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return AnalyticsNotifier(repository);
});
