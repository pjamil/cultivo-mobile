import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/ambiente.dart';

void main() {
  group('Ambiente Model', () {
    test('should create Ambiente from JSON', () {
      final json = {
        'id': 1,
        'nome': 'Estufa Principal',
        'descricao': 'Estufa indoor 4x4m',
        'tipo': 'interno',
        'comprimento': 4.0,
        'altura': 2.0,
        'largura': 4.0,
        'tempoExposicao': '12',
        'orientacao': 'norte',
      };
      final ambiente = Ambiente.fromJson(json);
      expect(ambiente.id, 1);
      expect(ambiente.nome, 'Estufa Principal');
      expect(ambiente.descricao, 'Estufa indoor 4x4m');
      expect(ambiente.tipo, 'interno');
      expect(ambiente.comprimento, 4.0);
      expect(ambiente.altura, 2.0);
      expect(ambiente.largura, 4.0);
      expect(ambiente.tempoExposicao, '12');
      expect(ambiente.orientacao, 'norte');
    });

    test('should convert Ambiente to JSON', () {
      final ambiente = Ambiente(
        id: 1,
        nome: 'Jardim',
        tipo: 'externo',
        comprimento: 6.0,
        largura: 5.0,
      );
      final json = ambiente.toJson();
      expect(json['id'], 1);
      expect(json['nome'], 'Jardim');
      expect(json['tipo'], 'externo');
      expect(json['comprimento'], 6.0);
      expect(json['largura'], 5.0);
    });

    test('should copyWith correctly', () {
      final original = Ambiente(id: 1, nome: 'Original', tipo: 'interno');
      final copied = original.copyWith(nome: 'Atualizado', tipo: 'externo');
      expect(copied.id, 1);
      expect(copied.nome, 'Atualizado');
      expect(copied.tipo, 'externo');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{'id': 1, 'nome': 'Teste', 'tipo': 'interno'};
      final ambiente = Ambiente.fromJson(json);
      expect(ambiente.descricao, isNull);
      expect(ambiente.comprimento, isNull);
      expect(ambiente.altura, isNull);
      expect(ambiente.largura, isNull);
      expect(ambiente.tempoExposicao, isNull);
      expect(ambiente.orientacao, isNull);
    });
  });
}
