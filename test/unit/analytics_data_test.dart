import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/analytics_data.dart';

void main() {
  group('AnalyticsData Model', () {
    test('should parse analytics contract', () {
      final json = {
        'rendimentoPorVariedade': [
          {'variedade': 'Amnesia Haze', 'rendimentoMedio': 300.0},
          {'variedade': 'Purple Kush', 'rendimentoMedio': 315.0},
        ],
        'duracaoCiclo': [
          {'fase': 'GERMINANDO', 'diasMedios': 14.0},
          {'fase': 'VEGETATIVO', 'diasMedios': 45.0},
        ],
        'custoPorCultivo': [
          {'cultivo': 'Cultivo Verão 2025', 'custoTotal': 1450.5},
        ],
      };

      final analytics = AnalyticsData.fromJson(json);

      expect(analytics.rendimentoPorVariedade.length, 2);
      expect(analytics.rendimentoPorVariedade[0].variedade, 'Amnesia Haze');
      expect(analytics.rendimentoPorVariedade[0].rendimentoMedio, 300.0);

      expect(analytics.duracaoCiclo.length, 2);
      expect(analytics.duracaoCiclo[1].fase, 'VEGETATIVO');
      expect(analytics.duracaoCiclo[1].diasMedios, 45.0);

      expect(analytics.custoPorCultivo.length, 1);
      expect(analytics.custoPorCultivo[0].cultivo, 'Cultivo Verão 2025');
      expect(analytics.custoPorCultivo[0].custoTotal, 1450.5);
    });

    test('should parse int values as double', () {
      final json = {
        'rendimentoPorVariedade': [
          {'variedade': 'Northern #1', 'rendimentoMedio': 300},
        ],
        'duracaoCiclo': [
          {'fase': 'FLORACAO', 'diasMedios': 70},
        ],
        'custoPorCultivo': [
          {'cultivo': 'Cultivo Verão 2025', 'custoTotal': 1450},
        ],
      };

      final analytics = AnalyticsData.fromJson(json);

      expect(analytics.rendimentoPorVariedade[0].rendimentoMedio, 300.0);
      expect(analytics.duracaoCiclo[0].diasMedios, 70.0);
      expect(analytics.custoPorCultivo[0].custoTotal, 1450.0);
    });

    test('should default to empty lists when fields are missing', () {
      final analytics = AnalyticsData.fromJson({});

      expect(analytics.rendimentoPorVariedade, isEmpty);
      expect(analytics.duracaoCiclo, isEmpty);
      expect(analytics.custoPorCultivo, isEmpty);
    });

    test('should use defaults when nested fields are missing', () {
      final yieldData = YieldData.fromJson({});
      final cycleData = CycleData.fromJson({});
      final costData = CostData.fromJson({});

      expect(yieldData.variedade, '');
      expect(yieldData.rendimentoMedio, 0);

      expect(cycleData.fase, '');
      expect(cycleData.diasMedios, 0);

      expect(costData.cultivo, '');
      expect(costData.custoTotal, 0);
    });
  });
}
