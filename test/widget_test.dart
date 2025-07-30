import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_fayda_wallet/app.dart';

void main() {
  group('Digital Fayda Wallet App Tests', () {
    testWidgets('App should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: DigitalFaydaWalletApp(),
        ),
      );

      // The app should build without throwing any errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Splash screen should be displayed initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DigitalFaydaWalletApp(),
        ),
      );

      // Wait for initial route to be set
      await tester.pumpAndSettle();

      // Should find splash screen elements
      expect(find.text('Digital Fayda Wallet'), findsWidgets);
    });
  });
}