import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/insumo.dart';

void main() {
  group('Insumo Model', () {
    test('should create Insumo from JSON', () {
      final json = {
        'id': 1,
        'codigo': 'ADB-001',
        'nome': 'Adubo NPK',
        'tipo': 'ADUBO',
        'quantidade': 25.0,
        'unidadeMedida': 'kg',
        'estoqueMinimo': 5.0,
        'dataCadastro': '2024-01-15T00:00:00.000',
      };
      final insumo = Insumo.fromJson(json);
      expect(insumo.id, 1);
      expect(insumo.codigo, 'ADB-001');
      expect(insumo.nome, 'Adubo NPK');
      expect(insumo.tipo, 'ADUBO');
      expect(insumo.quantidade, 25.0);
      expect(insumo.unidadeMedida, 'kg');
      expect(insumo.estoqueMinimo, 5.0);
      expect(insumo.dataCadastro, isNotNull);
    });

    test('should convert Insumo to JSON', () {
      final insumo = Insumo(
        id: 1,
        codigo: 'ADB-001',
        nome: 'Adubo NPK',
        tipo: 'ADUBO',
        quantidade: 25.0,
        unidadeMedida: 'kg',
        estoqueMinimo: 5.0,
      );
      final json = insumo.toJson();
      expect(json['id'], 1);
      expect(json['codigo'], 'ADB-001');
      expect(json['nome'], 'Adubo NPK');
      expect(json['quantidade'], 25.0);
    });

    test('should check if estoque is baixo', () {
      final estoqueBaixo = Insumo(
        id: 1,
        codigo: 'ADB-001',
        nome: 'Adubo',
        tipo: 'ADUBO',
        quantidade: 3.0,
        unidadeMedida: 'kg',
        estoqueMinimo: 5.0,
      );
      final estoqueOk = Insumo(
        id: 2,
        codigo: 'ADB-002',
        nome: 'Fertilizante',
        tipo: 'ADUBO',
        quantidade: 15.0,
        unidadeMedida: 'kg',
        estoqueMinimo: 5.0,
      );
      final estoqueIgual = Insumo(
        id: 3,
        codigo: 'ADB-003',
        nome: 'Corretor',
        tipo: 'OUTRO',
        quantidade: 5.0,
        unidadeMedida: 'L',
        estoqueMinimo: 5.0,
      );

      expect(estoqueBaixo.isEstoqueBaixo, true);
      expect(estoqueOk.isEstoqueBaixo, false);
      expect(estoqueIgual.isEstoqueBaixo, true);
    });

    test('should copyWith correctly', () {
      final original = Insumo(
        id: 1,
        codigo: 'ADB-001',
        nome: 'Original',
        tipo: 'ADUBO',
        quantidade: 10.0,
        unidadeMedida: 'kg',
        estoqueMinimo: 5.0,
      );
      final copied = original.copyWith(nome: 'Atualizado', quantidade: 20.0);
      expect(copied.id, 1);
      expect(copied.nome, 'Atualizado');
      expect(copied.quantidade, 20.0);
      expect(copied.tipo, 'ADUBO');
    });
  });
}
