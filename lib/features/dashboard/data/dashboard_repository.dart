import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/models/dashboard_data.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref);
});

class DashboardRepository {
  final Ref _ref;

  DashboardRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<DashboardData> getDashboard() async {
    try {
      final response = await _api.get(Endpoints.dashboard);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Resposta inválida do servidor');
      }
      return DashboardData.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar dashboard');
    }
  }
}
