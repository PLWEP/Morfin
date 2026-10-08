import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/metadata/action_metadata.dart';
import 'package:morfin/core/metadata/lobby_metadata.dart';

void main() {
  group('LobbyGridSpan', () {
    test('defaults to col=1, row=1', () {
      const span = LobbyGridSpan();
      expect(span.col, 1);
      expect(span.row, 1);
    });

    test('fromJson handles null', () {
      final span = LobbyGridSpan.fromJson(null);
      expect(span.col, 1);
      expect(span.row, 1);
    });

    test('fromJson parses custom values', () {
      final span = LobbyGridSpan.fromJson({'col': 2, 'row': 3});
      expect(span.col, 2);
      expect(span.row, 3);
    });
  });

  group('LobbyElementMetadata', () {
    test('parses counter element from IFS backend JSON', () {
      final json = {
        'ElementId': 1,
        'Title': 'Active Work Orders',
        'Subtitle': 'Critical & High Priority',
        'ElementType': 'Counter',
        'Icon': 'assignment',
        'ColorToken': 'critical',
        'SpanCol': 1,
        'SpanRow': 1,
        'TargetProjection': 'WorkOrderHandling',
        'TargetEndpoint': 'ActiveWorkOrderSet',
        'FilterConditions': "Priority eq 'High'",
        'SortOrder': 10,
        'Value': '24',
        'Unit': 'WOs',
        'Change': '+12%',
        'IsPositive': false,
        'TrendPoints': [10.0, 15.0, 24.0],
      };

      final elem = LobbyElementMetadata.fromJson(json);
      expect(elem.id, '1');
      expect(elem.title, 'Active Work Orders');
      expect(elem.subtitle, 'Critical & High Priority');
      expect(elem.type, LobbyElementType.counter);
      expect(elem.icon, 'assignment');
      expect(elem.colorToken, 'critical');
      expect(elem.span.col, 1);
      expect(elem.span.row, 1);
      expect(elem.value, '24');
      expect(elem.unit, 'WOs');
      expect(elem.change, '+12%');
      expect(elem.isPositive, false);
      expect(elem.trendPoints, [10.0, 15.0, 24.0]);
      expect(elem.targetProjection, 'WorkOrderHandling');
      expect(elem.targetEndpoint, 'ActiveWorkOrderSet');
      expect(elem.filterConditions, "Priority eq 'High'");
      expect(elem.action, isNotNull);
      expect(elem.action!.type, ActionType.navigate);
      expect(elem.action!.target, '/record_list');
    });

    test('parses indicator, barChart, lineChart, and unknown types', () {
      expect(
        LobbyElementMetadata.fromJson({'id': '1', 'title': 'T', 'elementType': 'indicator'}).type,
        LobbyElementType.indicator,
      );
      expect(
        LobbyElementMetadata.fromJson({'id': '2', 'title': 'T', 'elementType': 'gauge'}).type,
        LobbyElementType.indicator,
      );
      expect(
        LobbyElementMetadata.fromJson({'id': '3', 'title': 'T', 'elementType': 'barchart'}).type,
        LobbyElementType.barChart,
      );
      expect(
        LobbyElementMetadata.fromJson({'id': '4', 'title': 'T', 'elementType': 'bar_chart'}).type,
        LobbyElementType.barChart,
      );
      expect(
        LobbyElementMetadata.fromJson({'id': '5', 'title': 'T', 'elementType': 'linechart'}).type,
        LobbyElementType.lineChart,
      );
      expect(
        LobbyElementMetadata.fromJson({'id': '6', 'title': 'T', 'elementType': 'line_chart'}).type,
        LobbyElementType.lineChart,
      );
      expect(
        LobbyElementMetadata.fromJson({'id': '7', 'title': 'T', 'elementType': 'custom_unknown'}).type,
        LobbyElementType.unknown,
      );
    });

    test('decodes JSON within FilterConditions for chart points and targets', () {
      final json = {
        'ElementId': 2,
        'Title': 'Inventory Value',
        'ElementType': 'BarChart',
        'SpanCol': 2,
        'SpanRow': 1,
        'FilterConditions': '{"percentage": 78.5, "target": 100.0, "chartPoints": [{"label": "Jan", "value": 10}, {"label": "Feb", "value": 20}]}',
      };

      final elem = LobbyElementMetadata.fromJson(json);
      expect(elem.type, LobbyElementType.barChart);
      expect(elem.percentage, 78.5);
      expect(elem.target, 100.0);
      expect(elem.chartPoints.length, 2);
      expect(elem.chartPoints[0]['label'], 'Jan');
    });

    test('copyWith updates specified fields correctly', () {
      const orig = LobbyElementMetadata(
        id: '1',
        type: LobbyElementType.counter,
        title: 'Original',
        value: '10',
      );

      final updated = orig.copyWith(
        value: '20',
        change: '+10%',
        isPositive: true,
        percentage: 50.0,
      );

      expect(updated.id, '1');
      expect(updated.title, 'Original');
      expect(updated.value, '20');
      expect(updated.change, '+10%');
      expect(updated.isPositive, true);
      expect(updated.percentage, 50.0);
    });
  });

  group('LobbyPageMetadata', () {
    test('empty factory produces empty page', () {
      const page = LobbyPageMetadata.empty();
      expect(page.pageId, '');
      expect(page.title, '');
      expect(page.subtitle, isNull);
      expect(page.elements, isEmpty);
    });

    test('fromJson parses elements list from standard value key', () {
      final json = {
        'PageId': 'overview',
        'Title': 'Dashboard',
        'value': [
          {'ElementId': 10, 'Title': 'Tile 1', 'ElementType': 'Counter'},
          {'ElementId': 20, 'Title': 'Tile 2', 'ElementType': 'Indicator'},
        ],
      };

      final page = LobbyPageMetadata.fromJson(json);
      expect(page.pageId, 'overview');
      expect(page.title, 'Dashboard');
      expect(page.elements.length, 2);
      expect(page.elements[0].title, 'Tile 1');
      expect(page.elements[1].title, 'Tile 2');
    });
  });
}
