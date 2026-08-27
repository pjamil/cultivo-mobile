import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/dado_ambiental.dart';

void main() {
  group('DadoAmbiental Model', () {
    test('should create DadoAmbiental from JSON', () {
      final json = {
        'id': 1,
        'cultivo_id': 2,
        'tipo_medicao': 'TEMPERATURA',
        'valor': 25.5,
        'unidade': '°C',
        'data_hora': '2025-02-01T10:00:00Z',
      };
      final dado = DadoAmbiental.fromJson(json);
      expect(dado.id, 1);
      expect(dado.cultivoId, 2);
      expect(dado.tipoMedicao, 'TEMPERATURA');
      expect(dado.valor, 25.5);
      expect(dado.unidade, '°C');
      expect(dado.dataHora, isNotNull);
    });

    test('should convert DadoAmbiental to JSON', () {
      final dado = DadoAmbiental(
        id: 1,
        cultivoId: 2,
        tipoMedicao: 'UMIDADE',
        valor: 65,
        unidade: '%',
        dataHora: DateTime(2025, 2, 1, 10, 0),
      );
      final json = dado.toJson();
      expect(json['id'], isNull);
      expect(json['cultivo_id'], 2);
      expect(json['tipo_medicao'], 'UMIDADE');
      expect(json['valor'], 65);
      expect(json['unidade'], '%');
      expect(json['data_hora'], '2025-02-01T10:00:00');
    });

    test('should copyWith correctly', () {
      final original = DadoAmbiental(
        id: 1,
        cultivoId: 2,
        tipoMedicao: 'TEMPERATURA',
        valor: 25,
        unidade: '°C',
      );
      final copied = original.copyWith(valor: 30, tipoMedicao: 'PH');
      expect(copied.id, 1);
      expect(copied.valor, 30);
      expect(copied.tipoMedicao, 'PH');
      expect(copied.unidade, '°C');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'tipo_medicao': 'TEMPERATURA',
      };
      final dado = DadoAmbiental.fromJson(json);
      expect(dado.cultivoId, isNull);
      expect(dado.dataHora, isNull);
      expect(dado.valor, 0);
      expect(dado.unidade, '');
    });

    test('should return tipoLabel correctly', () {
      expect(
        DadoAmbiental(id: 1, tipoMedicao: 'TEMPERATURA').tipoLabel,
        'Temperatura',
      );
      expect(
        DadoAmbiental(id: 1, tipoMedicao: 'UMIDADE_SOLO').tipoLabel,
        'Umidade do Solo',
      );
      expect(DadoAmbiental(id: 1, tipoMedicao: 'PH').tipoLabel, 'pH');
    });
  });
}
