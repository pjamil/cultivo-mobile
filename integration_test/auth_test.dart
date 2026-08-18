import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cultivo_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow', () {
    testWidgets('Login with valid credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find email field
      final emailField = find.byKey(const Key('email-input'));
      expect(emailField, findsOneWidget);

      // Enter email
      await tester.enterText(emailField, 'maria@teste.com');
      await tester.pumpAndSettle();

      // Find password field
      final passwordField = find.byKey(const Key('password-input'));
      expect(passwordField, findsOneWidget);

      // Enter password
      await tester.enterText(passwordField, 'admin123');
      await tester.pumpAndSettle();

      // Find login button
      final loginButton = find.byKey(const Key('login-button'));
      expect(loginButton, findsOneWidget);

      // Tap login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify navigation to home/dashboard
      // The app should navigate away from login page
    });

    testWidgets('Login with invalid credentials shows error', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find email field
      final emailField = find.byKey(const Key('email-input'));
      await tester.enterText(emailField, 'wrong@email.com');
      await tester.pumpAndSettle();

      // Find password field
      final passwordField = find.byKey(const Key('password-input'));
      await tester.enterText(passwordField, 'wrongpassword');
      await tester.pumpAndSettle();

      // Find login button
      final loginButton = find.byKey(const Key('login-button'));
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify error message appears
      final errorMessage = find.byKey(const Key('error-message'));
      expect(errorMessage, findsOneWidget);
    });
  });
}
