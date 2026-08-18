import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/foto.dart';

void main() {
  group('Foto Model', () {
    test('should create Foto from JSON', () {
      final json = {
        'id': 1,
        'url': 'https://s3.amazonaws.com/bucket/foto.jpg',
        'thumbnailUrl': 'https://s3.amazonaws.com/bucket/thumb.jpg',
        'legenda': 'Planta no 15° dia',
        'entityType': 'PLANTA',
        'entityId': 10,
        'cultivoEstado': 'VEGETATIVO',
        'createdAt': '2024-01-15T14:30:00.000',
      };
      final foto = Foto.fromJson(json);
      expect(foto.id, 1);
      expect(foto.url, 'https://s3.amazonaws.com/bucket/foto.jpg');
      expect(foto.thumbnailUrl, 'https://s3.amazonaws.com/bucket/thumb.jpg');
      expect(foto.legenda, 'Planta no 15° dia');
      expect(foto.entityType, 'PLANTA');
      expect(foto.entityId, 10);
      expect(foto.cultivoEstado, 'VEGETATIVO');
      expect(foto.createdAt, isNotNull);
    });

    test('should convert Foto to JSON', () {
      final foto = Foto(
        id: 1,
        url: 'https://s3.amazonaws.com/bucket/foto.jpg',
        entityType: 'CULTIVO',
        entityId: 5,
      );
      final json = foto.toJson();
      expect(json['id'], 1);
      expect(json['url'], 'https://s3.amazonaws.com/bucket/foto.jpg');
      expect(json['entityType'], 'CULTIVO');
      expect(json['entityId'], 5);
    });

    test('should copyWith correctly', () {
      final original = Foto(
        id: 1,
        url: 'https://s3.amazonaws.com/old.jpg',
        entityType: 'PLANTA',
        entityId: 10,
      );
      final copied = original.copyWith(
        url: 'https://s3.amazonaws.com/new.jpg',
        legenda: 'Nova legenda',
      );
      expect(copied.id, 1);
      expect(copied.url, 'https://s3.amazonaws.com/new.jpg');
      expect(copied.legenda, 'Nova legenda');
      expect(copied.entityType, 'PLANTA');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'url': 'https://example.com/foto.jpg',
        'entityType': 'DIARIO',
        'entityId': 3,
      };
      final foto = Foto.fromJson(json);
      expect(foto.thumbnailUrl, isNull);
      expect(foto.legenda, isNull);
      expect(foto.cultivoEstado, isNull);
      expect(foto.createdAt, isNull);
    });
  });
}
