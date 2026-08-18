import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/usuario.dart';

void main() {
  group('Usuario Model', () {
    test('should create Usuario from JSON', () {
      final json = {
        'id': 1,
        'nome': 'Test User',
        'email': 'test@example.com',
        'papel': 'USUARIO',
        'ativo': true,
      };

      final usuario = Usuario.fromJson(json);

      expect(usuario.id, 1);
      expect(usuario.nome, 'Test User');
      expect(usuario.email, 'test@example.com');
      expect(usuario.papel, 'USUARIO');
      expect(usuario.ativo, true);
    });

    test('should convert Usuario to JSON', () {
      final usuario = Usuario(
        id: 1,
        nome: 'Test User',
        email: 'test@example.com',
        papel: 'USUARIO',
        ativo: true,
      );

      final json = usuario.toJson();

      expect(json['id'], 1);
      expect(json['nome'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['papel'], 'USUARIO');
      expect(json['ativo'], true);
    });

    test('should check if user is admin', () {
      final admin = Usuario(
        id: 1,
        nome: 'Admin',
        email: 'admin@example.com',
        papel: 'ADMINISTRADOR',
      );

      final user = Usuario(
        id: 2,
        nome: 'User',
        email: 'user@example.com',
        papel: 'USUARIO',
      );

      expect(admin.isAdmin, true);
      expect(user.isAdmin, false);
    });

    test('should copyWith correctly', () {
      final original = Usuario(
        id: 1,
        nome: 'Original',
        email: 'original@example.com',
        papel: 'USUARIO',
      );

      final copied = original.copyWith(nome: 'Updated');

      expect(copied.id, 1);
      expect(copied.nome, 'Updated');
      expect(copied.email, 'original@example.com');
    });
  });
}
