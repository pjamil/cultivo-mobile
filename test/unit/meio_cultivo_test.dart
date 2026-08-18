import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/meio_cultivo.dart';

void main() {
  group('MeioCultivo Model', () {
    test('should create MeioCultivo from JSON', () {
      final json = {
        'id': 1,
        'tipo': 'solo',
        'descricao': 'Solo orgânico com perlita',
      };
      final meio = MeioCultivo.fromJson(json);
      expect(meio.id, 1);
      expect(meio.tipo, 'solo');
      expect(meio.descricao, 'Solo orgânico com perlita');
    });

    test('should convert MeioCultivo to JSON', () {
      final meio = MeioCultivo(
        id: 1,
        tipo: 'hidroponia',
        descricao: 'Sistema NFT',
      );
      final json = meio.toJson();
      expect(json['id'], 1);
      expect(json['tipo'], 'hidroponia');
      expect(json['descricao'], 'Sistema NFT');
    });

    test('should copyWith correctly', () {
      final original = MeioCultivo(id: 1, tipo: 'solo', descricao: 'Original');
      final copied = original.copyWith(tipo: 'fibra_coco');
      expect(copied.id, 1);
      expect(copied.tipo, 'fibra_coco');
      expect(copied.descricao, 'Original');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{'id': 1, 'tipo': 'solo'};
      final meio = MeioCultivo.fromJson(json);
      expect(meio.descricao, isNull);
    });
  });
}
