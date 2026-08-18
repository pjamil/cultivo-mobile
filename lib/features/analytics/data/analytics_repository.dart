import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref);
});

class AnalyticsData {
  final List<YieldData> rendimentoPorVariedade;
  final List<CycleData> duracaoCiclo;
  final List<CostData> custoPorCultivo;

  AnalyticsData({
    required this.rendimentoPorVariedade,
    required this.duracaoCiclo,
    required this.custoPorCultivo,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      rendimentoPorVariedade: (json['rendimentoPorVariedade'] as List?)
              ?.map((y) => YieldData.fromJson(y))
              .toList() ??
          [],
      duracaoCiclo: (json['duracaoCiclo'] as List?)
              ?.map((c) => CycleData.fromJson(c))
              .toList() ??
          [],
      custoPorCultivo: (json['custoPorCultivo'] as List?)
              ?.map((c) => CostData.fromJson(c))
              .toList() ??
          [],
    );
  }
}

class YieldData {
  final String variedade;
  final double rendimentoMedio;

  YieldData({required this.variedade, required this.rendimentoMedio});

  factory YieldData.fromJson(Map<String, dynamic> json) {
    return YieldData(
      variedade: json['variedade'] ?? '',
      rendimentoMedio: json['rendimentoMedio']?.toDouble() ?? 0,
    );
  }
}

class CycleData {
  final String fase;
  final double diasMedios;

  CycleData({required this.fase, required this.diasMedios});

  factory CycleData.fromJson(Map<String, dynamic> json) {
    return CycleData(
      fase: json['fase'] ?? '',
      diasMedios: json['diasMedios']?.toDouble() ?? 0,
    );
  }
}

class CostData {
  final String cultivo;
  final double custoTotal;

  CostData({required this.cultivo, required this.custoTotal});

  factory CostData.fromJson(Map<String, dynamic> json) {
    return CostData(
      cultivo: json['cultivo'] ?? '',
      custoTotal: json['custoTotal']?.toDouble() ?? 0,
    );
  }
}

class AnalyticsRepository {
  final Ref _ref;

  AnalyticsRepository(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<AnalyticsData> getAnalytics() async {
    try {
      final response = await _api.get(Endpoints.analytics);
      return AnalyticsData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Erro ao carregar analytics');
    }
  }
}
