import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/dashboard_data.dart';

void main() {
  group('DashboardData Model', () {
    test('should parse atividadesRecentes from snake_case contract', () {
      final json = {
        'cultivosAtivos': 3,
        'tarefasPendentes': 2,
        'alertasEstoque': 1,
        'atividadesRecentes': [
          {
            'id': 1,
            'cultivo_id': 2,
            'tipo_atividade': 'IRRIGACAO',
            'data': '2026-07-20',
            'observacoes': 'Irrigação matinal com 2L por planta',
            'responsavel_id': 1,
            'responsavel_nome': 'Maria Silva',
          },
          {
            'id': 2,
            'cultivo_id': 2,
            'tipo_atividade': 'ADUBACAO',
            'data': '2026-07-19T10:00:00',
            'observacoes': 'Aplicação de NPK 10-10-10',
            'responsavel_id': 1,
            'responsavel_nome': 'Maria Silva',
          },
        ],
        'cultivosPorStatus': {'VEGETATIVO': 2},
      };

      final dashboard = DashboardData.fromJson(json);

      expect(dashboard.cultivosAtivos, 3);
      expect(dashboard.atividadesRecentes.length, 2);

      final irrigacao = dashboard.atividadesRecentes[0];
      expect(irrigacao.tipo, 'IRRIGACAO');
      expect(irrigacao.descricao, 'Irrigação matinal com 2L por planta');
      expect(irrigacao.data, DateTime(2026, 7, 20));

      final adubacao = dashboard.atividadesRecentes[1];
      expect(adubacao.tipo, 'ADUBACAO');
      expect(adubacao.data, DateTime(2026, 7, 19, 10, 0));
    });

    test('should parse camelCase contract from seed', () {
      final json = {
        'id': 4,
        'cultivoId': 3,
        'cultivoNome': 'Northern #1',
        'tipoAtividade': 'PLANTIO',
        'data': '2026-07-17T08:00:00',
      };

      final atividade = AtividadeRecente.fromJson(json);

      expect(atividade.tipo, 'PLANTIO');
      expect(atividade.descricao, '');
      expect(atividade.data, DateTime(2026, 7, 17, 8, 0));
    });

    test('should use defaults when fields are missing', () {
      final atividade = AtividadeRecente.fromJson({});

      expect(atividade.tipo, '');
      expect(atividade.descricao, '');
      expect(atividade.data, isNotNull);
    });
  });
}
