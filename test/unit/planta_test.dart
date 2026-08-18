import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/planta.dart';

void main() {
  group('Planta Model', () {
    test('should create Planta from JSON', () {
      final json = {
        'id': 1,
        'nome': 'Tomate',
        'especie': 'Solanum lycopersicum',
        'status': 'ATIVA',
        'dataPlantio': '2024-01-15T00:00:00.000',
      };

      final planta = Planta.fromJson(json);

      expect(planta.id, 1);
      expect(planta.nome, 'Tomate');
      expect(planta.especie, 'Solanum lycopersicum');
      expect(planta.status, 'ATIVA');
      expect(planta.dataPlantio, isNotNull);
    });

    test('should check if plant is active', () {
      final activePlant = Planta(
        id: 1,
        nome: 'Tomate',
        especie: 'Solanum lycopersicum',
        status: 'ATIVA',
      );

      final harvestedPlant = Planta(
        id: 2,
        nome: 'Pimentão',
        especie: 'Capsicum annuum',
        status: 'COLHIDA',
      );

      expect(activePlant.isActive, true);
      expect(harvestedPlant.isActive, false);
    });

    test('should copyWith correctly', () {
      final original = Planta(
        id: 1,
        nome: 'Original',
        especie: 'Solanum lycopersicum',
        status: 'ATIVA',
      );

      final copied = original.copyWith(nome: 'Updated', status: 'COLHIDA');

      expect(copied.id, 1);
      expect(copied.nome, 'Updated');
      expect(copied.status, 'COLHIDA');
    });
  });
}
