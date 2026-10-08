import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/widgets/record/record_status_badge.dart';

void main() {
  Widget createTestWidget(String status) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RecordStatusBadge(status: status),
        ),
      ),
    );
  }

  group('RecordStatusBadge Widget Tests', () {
    testWidgets('renders active status badge with uppercase text', (tester) async {
      await tester.pumpWidget(createTestWidget('In Progress'));
      expect(find.text('IN PROGRESS'), findsOneWidget);
    });

    testWidgets('renders warning status badge', (tester) async {
      await tester.pumpWidget(createTestWidget('Pending Review'));
      expect(find.text('PENDING REVIEW'), findsOneWidget);
    });

    testWidgets('renders critical status badge', (tester) async {
      await tester.pumpWidget(createTestWidget('Critical Error'));
      expect(find.text('CRITICAL ERROR'), findsOneWidget);
    });

    testWidgets('renders success status badge', (tester) async {
      await tester.pumpWidget(createTestWidget('Completed'));
      expect(find.text('COMPLETED'), findsOneWidget);
    });

    testWidgets('renders empty shrink widget when status is empty string', (tester) async {
      await tester.pumpWidget(createTestWidget(''));
      expect(find.byType(Container), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
