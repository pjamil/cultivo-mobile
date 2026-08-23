import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/registro_acao.dart';

void main() {
  group('RegistroAcao Model', () {
    test('should create RegistroAcao from JSON (camelCase)', () {
      final json = {
        'id': 1,
        'tipo': 'REGA',
        'data': '2026-08-22T14:30:00',
        'cultivoId': 1,
        'plantaId': 2,
        'detalhes': '{"quantidade":500,"unidadeMedida":"mL","metodo":"manual"}',
        'notas': 'Rega após poda',
        'usuarioId': 1,
        'dataCriacao': '2026-08-22T14:30:00',
        'dataAtualizacao': null,
      };

      final registro = RegistroAcao.fromJson(json);

      expect(registro.id, 1);
      expect(registro.tipo, 'REGA');
      expect(registro.tipoAcao, TipoAcao.rega);
      expect(registro.data, DateTime(2026, 8, 22, 14, 30));
      expect(registro.cultivoId, 1);
      expect(registro.plantaId, 2);
      expect(registro.notas, 'Rega após poda');
      expect(registro.detalhesMap(), {
        'quantidade': 500,
        'unidadeMedida': 'mL',
        'metodo': 'manual',
      });
    });

    test('should create RegistroAcao from JSON (snake_case)', () {
      final json = {
        'id': 2,
        'tipo': 'ADUBACAO',
        'data': '2026-08-21T10:00:00',
        'cultivo_id': 1,
        'planta_id': 1,
        'notas': 'Adubação de manhã',
      };

      final registro = RegistroAcao.fromJson(json);

      expect(registro.tipo, 'ADUBACAO');
      expect(registro.tipoAcao, TipoAcao.adubacao);
      expect(registro.cultivoId, 1);
      expect(registro.plantaId, 1);
      expect(registro.detalhes, isNull);
      expect(registro.detalhesMap(), isNull);
    });

    test('should normalize tipo to lowercase', () {
      final registro = RegistroAcao(
        id: 1,
        tipo: 'rega',
        data: DateTime(2026, 8, 22),
        cultivoId: 1,
      );

      expect(registro.tipoAcao, TipoAcao.rega);
    });

    test('should default unknown tipo to outro', () {
      final json = {
        'id': 3,
        'tipo': 'DESCONHECIDO',
        'data': '2026-08-20T16:00:00',
        'cultivo_id': 1,
      };

      final registro = RegistroAcao.fromJson(json);

      expect(registro.tipoAcao, TipoAcao.outro);
    });

    test('should convert to create JSON with UPPERCASE tipo and ISO datetime',
        () {
      final registro = RegistroAcao(
        id: 0,
        tipo: 'rega',
        data: DateTime(2026, 8, 22, 14, 30),
        cultivoId: 1,
        plantaId: 2,
        detalhes: '{"quantidade":500}',
        notas: 'Rega',
      );

      final json = registro.toCreateJson();

      expect(json['tipo'], 'REGA');
      expect(json['data'], '2026-08-22T14:30:00');
      expect(json['cultivo_id'], 1);
      expect(json['planta_id'], 2);
      expect(json['detalhes'], '{"quantidade":500}');
      expect(json['notas'], 'Rega');
    });

    test('should convert to update JSON without cultivo_id', () {
      final registro = RegistroAcao(
        id: 1,
        tipo: 'TRANSPLANTE',
        data: DateTime(2026, 8, 20, 16),
        cultivoId: 1,
        detalhes: '{"vasoNovo":11}',
      );

      final json = registro.toUpdateJson();

      expect(json['tipo'], 'TRANSPLANTE');
      expect(json['data'], '2026-08-20T16:00:00');
      expect(json['detalhes'], '{"vasoNovo":11}');
      expect(json.containsKey('cultivo_id'), isFalse);
    });

    test('should copyWith correctly', () {
      final original = RegistroAcao(
        id: 1,
        tipo: 'REGA',
        data: DateTime(2026, 8, 22),
        cultivoId: 1,
      );

      final copied = original.copyWith(
        tipo: 'ADUBACAO',
        notas: 'Nova nota',
      );

      expect(copied.id, 1);
      expect(copied.tipo, 'ADUBACAO');
      expect(copied.cultivoId, 1);
      expect(copied.notas, 'Nova nota');
    });
  });
}
