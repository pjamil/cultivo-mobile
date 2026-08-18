import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cultivo_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Plantas CRUD', () {
    testWidgets('List plantas', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await _login(tester);

      // Open drawer and navigate to Plantas
      final drawerButton = find.byIcon(Icons.menu);
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      final plantasMenuItem = find.text('Plantas');
      await tester.tap(plantasMenuItem);
      await tester.pumpAndSettle();

      // Verify plantas list is displayed
      final plantasList = find.byType(ListView);
      expect(plantasList, findsOneWidget);
    });

    testWidgets('View planta details', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await _login(tester);

      // Navigate to Plantas
      await _navigateTo(tester, 'Plantas');

      // Tap on first planta
      final firstPlanta = find.byType(ListTile).first;
      await tester.tap(firstPlanta);
      await tester.pumpAndSettle();

      // Verify detail page is displayed
      final detailTitle = find.text('Detalhes da Planta');
      expect(detailTitle, findsOneWidget);
    });

    testWidgets('Create new planta', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await _login(tester);

      // Navigate to Plantas
      await _navigateTo(tester, 'Plantas');

      // Tap add button
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify form is displayed
      final formTitle = find.text('Nova Planta');
      expect(formTitle, findsOneWidget);

      // Fill in form
      final nomeField = find.byKey(const Key('nome-input'));
      await tester.enterText(nomeField, 'Tomate Teste');
      await tester.pumpAndSettle();

      final especieField = find.byKey(const Key('especie-input'));
      await tester.enterText(especieField, 'Solanum lycopersicum');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.text('Criar');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
    });

    testWidgets('Edit planta', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await _login(tester);

      // Navigate to Plantas
      await _navigateTo(tester, 'Plantas');

      // Tap on first planta
      final firstPlanta = find.byType(ListTile).first;
      await tester.tap(firstPlanta);
      await tester.pumpAndSettle();

      // Tap edit button
      final editButton = find.byIcon(Icons.edit);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Verify form is displayed with pre-filled data
      final formTitle = find.text('Editar Planta');
      expect(formTitle, findsOneWidget);
    });
  });
}

Future<void> _login(WidgetTester tester) async {
  // Find email field
  final emailField = find.byKey(const Key('email-input'));
  await tester.enterText(emailField, 'maria@teste.com');
  await tester.pumpAndSettle();

  // Find password field
  final passwordField = find.byKey(const Key('password-input'));
  await tester.enterText(passwordField, 'admin123');
  await tester.pumpAndSettle();

  // Find and tap login button
  final loginButton = find.byKey(const Key('login-button'));
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

Future<void> _navigateTo(WidgetTester tester, String menuItem) async {
  // Open drawer
  final drawerButton = find.byIcon(Icons.menu);
  await tester.tap(drawerButton);
  await tester.pumpAndSettle();

  // Tap on menu item
  final menuItemWidget = find.text(menuItem);
  await tester.tap(menuItemWidget);
  await tester.pumpAndSettle();
}
