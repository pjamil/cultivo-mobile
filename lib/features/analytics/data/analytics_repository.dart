import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/analytics_data.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref);
});

class AnalyticsRepository {
  final Ref _ref;

  AnalyticsRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<AnalyticsData> getAnalytics() async {
    try {
      final response = await _api.get(Endpoints.analytics);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Resposta inválida do servidor');
      }
      return AnalyticsData.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar analytics');
    }
  }
}
