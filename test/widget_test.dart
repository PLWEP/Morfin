import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/main.dart';
import 'package:morfin/theme/app_theme.dart';

void main() {
  testWidgets('App smoke test loads IFS Cloud Mobile in Dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(const IfsCloudMobileApp());
    expect(find.text('IFS Cloud Mobile'), findsOneWidget);
  });

  testWidgets('Theme validation supports Material 3 Light and Dark', (WidgetTester tester) async {
    final light = AppTheme.lightTheme;
    final dark = AppTheme.darkTheme;

    expect(light.useMaterial3, isTrue);
    expect(dark.useMaterial3, isTrue);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
  });
}
