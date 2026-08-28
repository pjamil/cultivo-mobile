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

    test('should default to empty lists when fields are missing', () {
      final analytics = AnalyticsData.fromJson({});

      expect(analytics.rendimentoPorVariedade, isEmpty);
      expect(analytics.duracaoCiclo, isEmpty);
      expect(analytics.custoPorCultivo, isEmpty);
    });
  });
}
