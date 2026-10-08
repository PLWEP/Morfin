import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/metadata/lobby_metadata.dart';
import 'package:morfin/core/widgets/lobby/lobby_indicator_tile.dart';

void main() {
  group('LobbyIndicatorTile Widget Tests', () {
    testWidgets('renders indicator tile with title and percentage', (tester) async {
      const metadata = LobbyElementMetadata(
        id: 'ind1',
        title: 'Warehouse Capacity',
        subtitle: 'Main Facility',
        type: LobbyElementType.indicator,
        value: '75',
        percentage: 75.0,
        colorToken: 'statusSuccess',
        span: LobbyGridSpan(col: 1, row: 1),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: LobbyIndicatorTile(metadata: metadata),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Warehouse Capacity'), findsOneWidget);
      expect(find.text('Main Facility'), findsOneWidget);
      expect(find.text('75.0%'), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
    });
  });
}
