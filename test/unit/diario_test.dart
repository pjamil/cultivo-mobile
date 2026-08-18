import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/diario.dart';

void main() {
  group('DiarioCultivo Model', () {
    test('should create DiarioCultivo from JSON', () {
      final json = {
        'id': 1,
        'titulo': 'Primeira semana',
        'conteudo': 'As plantas estão crescendo bem.',
        'data': '2024-01-20T00:00:00.000',
        'userId': 1,
      };
      final diario = DiarioCultivo.fromJson(json);
      expect(diario.id, 1);
      expect(diario.titulo, 'Primeira semana');
      expect(diario.conteudo, 'As plantas estão crescendo bem.');
      expect(diario.data, isNotNull);
      expect(diario.userId, 1);
    });

    test('should create DiarioCultivo from JSON with user_id key', () {
      final json = {
        'id': 1,
        'titulo': 'Teste',
        'conteudo': 'Conteúdo',
        'user_id': 2,
      };
      final diario = DiarioCultivo.fromJson(json);
      expect(diario.userId, 2);
    });

    test('should convert DiarioCultivo to JSON', () {
      final diario = DiarioCultivo(
        id: 1,
        titulo: 'Teste',
        conteudo: 'Conteúdo teste',
        userId: 1,
      );
      final json = diario.toJson();
      expect(json['id'], 1);
      expect(json['titulo'], 'Teste');
      expect(json['conteudo'], 'Conteúdo teste');
      expect(json['userId'], 1);
    });

    test('should copyWith correctly', () {
      final original = DiarioCultivo(
        id: 1,
        titulo: 'Original',
        conteudo: 'Conteúdo original',
      );
      final copied = original.copyWith(titulo: 'Atualizado');
      expect(copied.id, 1);
      expect(copied.titulo, 'Atualizado');
      expect(copied.conteudo, 'Conteúdo original');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{'id': 1, 'titulo': 'Teste', 'conteudo': 'Texto'};
      final diario = DiarioCultivo.fromJson(json);
      expect(diario.data, isNull);
      expect(diario.userId, isNull);
    });
  });
}
