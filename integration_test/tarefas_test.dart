import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cultivo_mobile/main.dart' as app;
import 'package:cultivo_mobile/features/tarefas/presentation/widgets/calendar_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tarefas Flow', () {
    testWidgets('List tarefas', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await _navigateTo(tester, 'Tarefas');
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Navigate to create tarefa form', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await _navigateTo(tester, 'Tarefas');
      await tester.pumpAndSettle();
      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('titulo-input')), findsOneWidget);
      }
    });

    testWidgets('View calendar', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await _navigateTo(tester, 'Tarefas');
      await tester.pumpAndSettle();
      final calendarButton = find.byIcon(Icons.calendar_today);
      if (calendarButton.evaluate().isNotEmpty) {
        await tester.tap(calendarButton);
        await tester.pumpAndSettle();
        expect(find.byType(CalendarView), findsOneWidget);
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
