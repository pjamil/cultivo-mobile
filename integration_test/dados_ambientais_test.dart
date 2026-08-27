import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cultivo_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dados Ambientais Flow', () {
    testWidgets('List dados ambientais', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await _navigateTo(tester, 'Dados Ambientais');
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('View dado ambiental details', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await _navigateTo(tester, 'Dados Ambientais');
      await tester.pumpAndSettle();
      final firstTile = find.byType(ListTile).first;
      if (firstTile.evaluate().isNotEmpty) {
        await tester.tap(firstTile);
        await tester.pumpAndSettle();
        expect(find.textContaining('Detalhes'), findsWidgets);
      }
    });

    testWidgets('Navigate to create dado ambiental form', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await _navigateTo(tester, 'Dados Ambientais');
      await tester.pumpAndSettle();
      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton);
        await tester.pumpAndSettle();
        expect(find.textContaining('Nova Leitura'), findsWidgets);
      }
    });
  });
}

Future<void> _login(WidgetTester tester) async {
  final emailField = find.byKey(const Key('email-input'));
  if (emailField.evaluate().isNotEmpty) {
    await tester.enterText(emailField, 'maria@teste.com');
    await tester.pumpAndSettle();
    final passwordField = find.byKey(const Key('password-input'));
    await tester.enterText(passwordField, 'admin123');
    await tester.pumpAndSettle();
    final loginButton = find.byKey(const Key('login-button'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _navigateTo(WidgetTester tester, String menuItem) async {
  final menuIcon = find.byIcon(Icons.menu);
  if (menuIcon.evaluate().isNotEmpty) {
    await tester.tap(menuIcon);
    await tester.pumpAndSettle();
    await tester.tap(find.text(menuItem));
    await tester.pumpAndSettle();
  }
}
