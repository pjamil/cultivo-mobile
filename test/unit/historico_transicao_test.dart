import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/historico_transicao.dart';

void main() {
  group('HistoricoTransicao Model', () {
    test('should create HistoricoTransicao from JSON (snake_case)', () {
      final json = {
        'id': 1,
        'cultivo_id': 3,
        'estado_anterior': 'PLANEJADO',
        'estado_atual': 'GERMINANDO',
        'data_transicao': '2026-05-01T08:00:00',
        'usuario_id': 2,
        'observacoes': 'Início da germinação',
      };

      final historico = HistoricoTransicao.fromJson(json);

      expect(historico.id, 1);
      expect(historico.cultivoId, 3);
      expect(historico.estadoAnterior, 'PLANEJADO');
      expect(historico.estadoAtual, 'GERMINANDO');
      expect(historico.dataTransicao, DateTime(2026, 5, 1, 8));
      expect(historico.usuarioId, 2);
      expect(historico.observacoes, 'Início da germinação');
    });

    test('should create HistoricoTransicao from JSON (camelCase)', () {
      final json = {
        'id': 2,
        'cultivoId': 3,
        'estadoAnterior': 'GERMINANDO',
        'estadoAtual': 'PLANTADO',
        'dataTransicao': '2026-05-07T10:00:00',
        'usuarioId': 2,
      };

      final historico = HistoricoTransicao.fromJson(json);

      expect(historico.cultivoId, 3);
      expect(historico.estadoAtual, 'PLANTADO');
      expect(historico.dataTransicao, DateTime(2026, 5, 7, 10));
    });

    test('should default diasNoEstado to zero', () {
      final historico = HistoricoTransicao.fromJson({
        'id': 1,
        'cultivo_id': 3,
        'estado_anterior': 'PLANEJADO',
        'estado_atual': 'GERMINANDO',
        'data_transicao': '2026-05-01T08:00:00',
      });

      expect(historico.diasNoEstado, 0);
    });
  });

  group('calcularDiasNoEstado', () {
    HistoricoTransicao transicao(
      int id,
      String anterior,
      String atual,
      DateTime data,
    ) {
      return HistoricoTransicao(
        id: id,
        cultivoId: 3,
        estadoAnterior: anterior,
        estadoAtual: atual,
        dataTransicao: data,
      );
    }

    test('should compute days between consecutive transitions', () {
      final transicoes = [
        transicao(
          1,
          'PLANEJADO',
          'GERMINANDO',
          DateTime(2026, 5, 1, 8),
        ),
        transicao(
          2,
          'GERMINANDO',
          'PLANTADO',
          DateTime(2026, 5, 7, 10),
        ),
        transicao(
          3,
          'PLANTADO',
          'VEGETATIVO',
          DateTime(2026, 5, 21, 9),
        ),
      ];

      final resultado = calcularDiasNoEstado(transicoes);

      expect(resultado.length, 3);
      expect(resultado[0].diasNoEstado, 6);
      expect(resultado[1].diasNoEstado, 14);
      expect(resultado[2].estadoAtual, 'VEGETATIVO');
    });

    test('should use dataFim for the last state', () {
      final transicoes = [
        transicao(
          1,
          'PLANEJADO',
          'GERMINANDO',
          DateTime(2026, 5, 1, 8),
        ),
        transicao(
          2,
          'GERMINANDO',
          'PLANTADO',
          DateTime(2026, 5, 7, 10),
        ),
      ];

      final resultado = calcularDiasNoEstado(
        transicoes,
        dataFim: DateTime(2026, 5, 22),
      );

      expect(resultado[0].diasNoEstado, 6);
      expect(resultado[1].diasNoEstado, 15);
    });

    test('should use reference date when dataFim is absent', () {
      final transicoes = [
        transicao(
          1,
          'PLANEJADO',
          'GERMINANDO',
          DateTime(2026, 5, 1, 8),
        ),
      ];

      final resultado = calcularDiasNoEstado(
        transicoes,
        agora: DateTime(2026, 5, 11),
      );

      expect(resultado[0].diasNoEstado, 10);
    });

    test('should sort transitions chronologically', () {
      final transicoes = [
        transicao(
          2,
          'GERMINANDO',
          'PLANTADO',
          DateTime(2026, 5, 7, 10),
        ),
        transicao(
          1,
          'PLANEJADO',
          'GERMINANDO',
          DateTime(2026, 5, 1, 8),
        ),
      ];

      final resultado = calcularDiasNoEstado(
        transicoes,
        dataFim: DateTime(2026, 5, 21),
      );

      expect(resultado[0].estadoAtual, 'GERMINANDO');
      expect(resultado[0].diasNoEstado, 6);
      expect(resultado[1].estadoAtual, 'PLANTADO');
      expect(resultado[1].diasNoEstado, 14);
    });

    test('should return empty list for empty input', () {
      expect(calcularDiasNoEstado([]), isEmpty);
    });

    test('should tiebreak by id when transitions share the same date', () {
      final mesmaData = DateTime(2026, 5, 1, 8);
      final transicoes = [
        transicao(20, 'PLANEJADO', 'GERMINANDO', mesmaData),
        transicao(10, 'PLANEJADO', 'PLANTADO', mesmaData),
        transicao(30, 'PLANEJADO', 'VEGETATIVO', mesmaData),
      ];

      final resultado = calcularDiasNoEstado(
        transicoes,
        dataFim: DateTime(2026, 5, 11),
      );

      expect(resultado.map((t) => t.id).toList(), [10, 20, 30]);
      expect(resultado[0].estadoAtual, 'PLANTADO');
    });

    test('should clamp negative durations to zero', () {
      final transicoes = [
        transicao(
          1,
          'PLANEJADO',
          'GERMINANDO',
          DateTime(2026, 5, 1, 8),
        ),
      ];

      final resultado = calcularDiasNoEstado(
        transicoes,
        dataFim: DateTime(2026, 4, 20),
      );

      expect(resultado[0].diasNoEstado, 0);
    });
  });

  group('dataTransicaoValida', () {
    final anterior = DateTime(2026, 5, 1, 8);
    final proxima = DateTime(2026, 5, 21, 9);

    test('should accept a date between neighbors', () {
      expect(
        dataTransicaoValida(
          DateTime(2026, 5, 10, 12),
          anterior: anterior,
          proxima: proxima,
        ),
        isTrue,
      );
    });

    test('should reject a date before the previous transition', () {
      expect(
        dataTransicaoValida(
          DateTime(2026, 4, 30, 12),
          anterior: anterior,
          proxima: proxima,
        ),
        isFalse,
      );
    });

    test('should reject a date after the next transition', () {
      expect(
        dataTransicaoValida(
          DateTime(2026, 5, 22, 12),
          anterior: anterior,
          proxima: proxima,
        ),
        isFalse,
      );
    });

    test('should accept a date equal to the previous transition', () {
      expect(
        dataTransicaoValida(
          anterior,
          anterior: anterior,
          proxima: proxima,
        ),
        isTrue,
      );
    });

    test('should accept a date equal to the next transition', () {
      expect(
        dataTransicaoValida(
          proxima,
          anterior: anterior,
          proxima: proxima,
        ),
        isTrue,
      );
    });

    test('should accept any date when there are no neighbors', () {
      expect(dataTransicaoValida(DateTime(2026, 1, 1)), isTrue);
    });

    test('should only check the upper bound for the first transition', () {
      expect(
        dataTransicaoValida(
          DateTime(2026, 5, 22, 12),
          proxima: proxima,
        ),
        isFalse,
      );
    });

    test('should accept a date after the previous transition for the last one',
        () {
      expect(
        dataTransicaoValida(
          DateTime(2026, 5, 22, 12),
          anterior: anterior,
        ),
        isTrue,
      );
    });

    test('should reject a date before the previous transition for the last one',
        () {
      expect(
        dataTransicaoValida(
          DateTime(2026, 4, 30, 12),
          anterior: anterior,
        ),
        isFalse,
      );
    });

    test('should only accept the exact date when the window has zero width',
        () {
      final mesmoPonto = DateTime(2026, 5, 10, 12);
      expect(
        dataTransicaoValida(
          mesmoPonto,
          anterior: mesmoPonto,
          proxima: mesmoPonto,
        ),
        isTrue,
      );
      expect(
        dataTransicaoValida(
          DateTime(2026, 5, 10, 11),
          anterior: mesmoPonto,
          proxima: mesmoPonto,
        ),
        isFalse,
      );
      expect(
        dataTransicaoValida(
          DateTime(2026, 5, 10, 13),
          anterior: mesmoPonto,
          proxima: mesmoPonto,
        ),
        isFalse,
      );
    });

    test('should accept a date before the next transition with only proxima',
        () {
      expect(
        dataTransicaoValida(
          DateTime(2026, 5, 10, 12),
          proxima: proxima,
        ),
        isTrue,
      );
    });
  });
}
