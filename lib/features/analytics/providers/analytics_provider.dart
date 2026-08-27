import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/analytics_data.dart';
import '../data/analytics_repository.dart';

class AnalyticsState {
  final LoadStatus status;
  final AnalyticsData? data;
  final String? error;

  AnalyticsState({
    this.status = LoadStatus.initial,
    this.data,
    this.error,
  });

  AnalyticsState copyWith({
    LoadStatus? status,
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
    state = state.copyWith(status: LoadStatus.loading);
    try {
      final data = await _repository.getAnalytics();
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

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return AnalyticsNotifier(repository);
});
