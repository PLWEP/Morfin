import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/utils/color_resolver.dart';
import 'package:morfin/core/utils/icon_resolver.dart';

void main() {
  group('IconResolver', () {
    test('resolves known icon identifiers', () {
      expect(IconResolver.resolve('dashboard'), Icons.dashboard_outlined);
      expect(IconResolver.resolve('assignment'), Icons.assignment_outlined);
      expect(IconResolver.resolve('inventory'), Icons.inventory_2_outlined);
      expect(IconResolver.resolve('settings'), Icons.settings_outlined);
      expect(IconResolver.resolve('qr_code_scanner'), Icons.qr_code_scanner_rounded);
    });

    test('falls back to circle_outlined on unknown or null name', () {
      expect(IconResolver.resolve(null), Icons.circle_outlined);
      expect(IconResolver.resolve(''), Icons.circle_outlined);
      expect(IconResolver.resolve('non_existent_icon'), Icons.circle_outlined);
      expect(IconResolver.resolve('custom', fallback: Icons.star), Icons.star);
    });
  });

  group('ColorResolver', () {
    testWidgets('resolves semantic tokens in theme context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final successColor = ColorResolver.resolve('success', context);
              expect(successColor, isNotNull);

              final warningColor = ColorResolver.resolve('warning', context);
              expect(warningColor, isNotNull);

              final criticalColor = ColorResolver.resolve('critical', context);
              expect(criticalColor, isNotNull);

              final primaryColor = ColorResolver.resolve('primary', context);
              expect(primaryColor, isNotNull);

              final hexColor = ColorResolver.resolve('#FF5733', context);
              expect(hexColor, const Color(0xFFFF5733));

              final fallbackColor = ColorResolver.resolve(null, context, fallback: Colors.purple);
              expect(fallbackColor, Colors.purple);

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
