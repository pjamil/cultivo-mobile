import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/cultivo.dart';

void main() {
  group('Cultivo Model', () {
    test('should create Cultivo from JSON', () {
      final json = {
        'id': 1,
        'nome': 'Cultivo Teste',
        'status': 'VEGETATIVO',
        'dataInicio': '2024-01-15T00:00:00.000',
        'dataFim': '2024-06-01T00:00:00.000',
        'notas': 'Observação teste',
        'plantaId': 10,
        'ambienteId': 20,
        'usuarioId': 1,
      };
      final cultivo = Cultivo.fromJson(json);
      expect(cultivo.id, 1);
      expect(cultivo.nome, 'Cultivo Teste');
      expect(cultivo.status, 'VEGETATIVO');
      expect(cultivo.dataInicio, isNotNull);
      expect(cultivo.dataFim, isNotNull);
      expect(cultivo.notas, 'Observação teste');
      expect(cultivo.plantaId, 10);
      expect(cultivo.ambienteId, 20);
      expect(cultivo.usuarioId, 1);
    });

    test('should convert Cultivo to JSON', () {
      final cultivo = Cultivo(
        id: 1,
        nome: 'Cultivo Teste',
        status: 'VEGETATIVO',
        plantaId: 10,
        ambienteId: 20,
      );
      final json = cultivo.toJson();
      expect(json['id'], 1);
      expect(json['nome'], 'Cultivo Teste');
      expect(json['status'], 'VEGETATIVO');
      expect(json['plantaId'], 10);
      expect(json['ambienteId'], 20);
    });

    test('should check if cultivo is active', () {
      final vegetativo = Cultivo(id: 1, nome: 'V', status: 'VEGETATIVO');
      final floracao = Cultivo(id: 2, nome: 'F', status: 'FLORACAO');
      final colhido = Cultivo(id: 3, nome: 'C', status: 'COLHIDO');
      final cancelado = Cultivo(id: 4, nome: 'X', status: 'CANCELADO');

      expect(vegetativo.isActive, true);
      expect(floracao.isActive, true);
      expect(colhido.isActive, false);
      expect(cancelado.isActive, false);
    });

    test('should copyWith correctly', () {
      final original = Cultivo(id: 1, nome: 'Original', status: 'PLANEJADO');
      final copied = original.copyWith(nome: 'Atualizado', status: 'VEGETATIVO');
      expect(copied.id, 1);
      expect(copied.nome, 'Atualizado');
      expect(copied.status, 'VEGETATIVO');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{'id': 1, 'nome': 'Teste'};
      final cultivo = Cultivo.fromJson(json);
      expect(cultivo.status, 'PLANEJADO');
      expect(cultivo.dataInicio, isNull);
      expect(cultivo.dataFim, isNull);
      expect(cultivo.notas, isNull);
      expect(cultivo.plantaId, isNull);
    });
  });
}
