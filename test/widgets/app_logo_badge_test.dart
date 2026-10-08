import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/widgets/app_logo_badge.dart';

void main() {
  group('AppLogoBadge Widget Tests', () {
    testWidgets('renders CustomPaint with default 96 size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppLogoBadge(),
          ),
        ),
      );

      final badgeFinder = find.byType(AppLogoBadge);
      expect(badgeFinder, findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(of: badgeFinder, matching: find.byType(SizedBox)),
      );
      expect(sizedBox.width, 96.0);
      expect(sizedBox.height, 96.0);

      expect(
        find.descendant(of: badgeFinder, matching: find.byType(CustomPaint)),
        findsOneWidget,
      );
    });

    testWidgets('renders CustomPaint with customized size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppLogoBadge(size: 140.0),
          ),
        ),
      );

      final badgeFinder = find.byType(AppLogoBadge);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(of: badgeFinder, matching: find.byType(SizedBox)),
      );
      expect(sizedBox.width, 140.0);
      expect(sizedBox.height, 140.0);

      expect(
        find.descendant(of: badgeFinder, matching: find.byType(CustomPaint)),
        findsOneWidget,
      );
    });
  });
}
