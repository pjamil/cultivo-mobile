import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/variedade.dart';

void main() {
  group('Variedade Model', () {
    test('should create Variedade from JSON', () {
      final json = {
        'id': 1,
        'nome': 'Amnesia Haze',
        'descricao': 'Sativa dominante',
        'tipoVariedade': 'SATIVA',
        'tipoEspecie': 'FEMININA',
        'tempoFloracao': '70',
        'origem': 'Holanda',
        'caracteristicas': 'Alto rendimento',
      };
      final variedade = Variedade.fromJson(json);
      expect(variedade.id, 1);
      expect(variedade.nome, 'Amnesia Haze');
      expect(variedade.descricao, 'Sativa dominante');
      expect(variedade.tipoVariedade, 'SATIVA');
      expect(variedade.tipoEspecie, 'FEMININA');
      expect(variedade.tempoFloracao, '70');
      expect(variedade.origem, 'Holanda');
      expect(variedade.caracteristicas, 'Alto rendimento');
    });

    test('should handle tipoGenetica key as fallback', () {
      final json = {
        'id': 1,
        'nome': 'Teste',
        'tipoGenetica': 'INDICA',
        'tipoEspecie': 'REGULAR',
      };
      final variedade = Variedade.fromJson(json);
      expect(variedade.tipoVariedade, 'INDICA');
    });

    test('should convert Variedade to JSON', () {
      final variedade = Variedade(
        id: 1,
        nome: 'Amnesia Haze',
        tipoVariedade: 'SATIVA',
        tipoEspecie: 'FEMININA',
      );
      final json = variedade.toJson();
      expect(json['id'], 1);
      expect(json['nome'], 'Amnesia Haze');
      expect(json['tipoVariedade'], 'SATIVA');
      expect(json['tipoEspecie'], 'FEMININA');
    });

    test('should copyWith correctly', () {
      final original = Variedade(
        id: 1,
        nome: 'Original',
        tipoVariedade: 'INDICA',
        tipoEspecie: 'REGULAR',
      );
      final copied = original.copyWith(nome: 'Atualizado', tipoVariedade: 'SATIVA');
      expect(copied.id, 1);
      expect(copied.nome, 'Atualizado');
      expect(copied.tipoVariedade, 'SATIVA');
      expect(copied.tipoEspecie, 'REGULAR');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'nome': 'Teste',
        'tipoVariedade': 'INDICA',
        'tipoEspecie': 'REGULAR',
      };
      final variedade = Variedade.fromJson(json);
      expect(variedade.descricao, isNull);
      expect(variedade.tempoFloracao, isNull);
      expect(variedade.origem, isNull);
      expect(variedade.caracteristicas, isNull);
    });
  });
}
