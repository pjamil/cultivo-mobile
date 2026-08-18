import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cultivo_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard Flow', () {
    testWidgets('Load dashboard', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Navigate to dashboard from drawer', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await _login(tester);
      await _navigateTo(tester, 'Dashboard');
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);
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
