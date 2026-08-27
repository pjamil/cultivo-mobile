import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/analytics_data.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

class AnalyticsRepository {
  Future<AnalyticsData> getAnalytics() async {
    return AnalyticsData(
      rendimentoPorVariedade: const [],
      duracaoCiclo: const [],
      custoPorCultivo: const [],
    );
  }
}
