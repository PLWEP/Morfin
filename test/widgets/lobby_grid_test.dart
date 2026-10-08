import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/metadata/lobby_metadata.dart';
import 'package:morfin/core/widgets/lobby/lobby_element_tile.dart';
import 'package:morfin/core/widgets/lobby/lobby_grid.dart';

void main() {
  Widget createTestWidget(List<LobbyElementMetadata> elements) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: LobbyGrid(elements: elements),
        ),
      ),
    );
  }

  group('LobbyGrid Widget Tests', () {
    testWidgets('empty elements list renders SizedBox.shrink', (tester) async {
      await tester.pumpWidget(createTestWidget([]));
      expect(find.byType(LobbyElementTile), findsNothing);
    });

    testWidgets('pairs two 1-column counter elements side by side in a Row', (tester) async {
      const e1 = LobbyElementMetadata(
        id: 'c1',
        title: 'Pending PO',
        type: LobbyElementType.counter,
        value: '12',
        span: LobbyGridSpan(col: 1, row: 1),
      );

      const e2 = LobbyElementMetadata(
        id: 'c2',
        title: 'Urgent PR',
        type: LobbyElementType.counter,
        value: '5',
        span: LobbyGridSpan(col: 1, row: 1),
      );

      await tester.pumpWidget(createTestWidget([e1, e2]));
      expect(find.byType(LobbyElementTile), findsNWidgets(2));
      expect(find.text('Pending PO'), findsOneWidget);
      expect(find.text('Urgent PR'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // Verify they are wrapped in a paired container (IntrinsicHeight)
      expect(find.byType(IntrinsicHeight), findsOneWidget);
    });

    testWidgets('renders full-width bar chart element', (tester) async {
      const chart = LobbyElementMetadata(
        id: 'chart1',
        title: 'Monthly Spend Trend',
        type: LobbyElementType.barChart,
        value: '150K',
        span: LobbyGridSpan(col: 2, row: 1),
      );

      await tester.pumpWidget(createTestWidget([chart]));
      expect(find.byType(LobbyElementTile), findsOneWidget);
      expect(find.text('Monthly Spend Trend'), findsOneWidget);
      expect(find.textContaining('150K'), findsOneWidget);
    });
  });
}
