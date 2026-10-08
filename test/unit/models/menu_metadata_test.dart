import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/metadata/action_metadata.dart';
import 'package:morfin/core/metadata/menu_metadata.dart';

void main() {
  group('MenuMetadata', () {
    test('MenuItemMetadata fromJson and toJson roundtrip', () {
      final json = {
        'id': 'item-1',
        'code': 'WO',
        'title': 'Work Orders',
        'subtitle': 'Manage Field Tasks',
        'category': 'Maintenance',
        'badgeText': 'New',
        'badgeType': 'warning',
        'action': {
          'type': 'navigate',
          'target': '/record_list',
          'params': {'projection': 'WorkOrderHandling'},
        },
      };

      final item = MenuItemMetadata.fromJson(json);
      expect(item.id, 'item-1');
      expect(item.code, 'WO');
      expect(item.title, 'Work Orders');
      expect(item.subtitle, 'Manage Field Tasks');
      expect(item.category, 'Maintenance');
      expect(item.badgeText, 'New');
      expect(item.badgeType, 'warning');
      expect(item.action, isNotNull);
      expect(item.action!.type, ActionType.navigate);
      expect(item.action!.target, '/record_list');

      final serialized = item.toJson();
      expect(serialized['id'], 'item-1');
      expect(serialized['badgeText'], 'New');
      expect(serialized['action']['target'], '/record_list');
    });

    test('MenuGroupMetadata and MenuMetadata aggregate items', () {
      final json = {
        'version': '2.0.0',
        'groups': [
          {
            'id': 'grp-1',
            'title': 'Operations',
            'items': [
              {'id': '1', 'title': 'WO List', 'category': 'Operations'},
              {'id': '2', 'title': 'Tasks', 'category': 'Operations'},
            ],
          },
          {
            'id': 'grp-2',
            'title': 'Inventory',
            'items': [
              {'id': '3', 'title': 'Stock', 'category': 'Inventory'},
            ],
          },
        ],
      };

      final menu = MenuMetadata.fromJson(json);
      expect(menu.version, '2.0.0');
      expect(menu.groups.length, 2);
      expect(menu.allItems.length, 3);
      expect(menu.allItems.map((i) => i.id).toList(), ['1', '2', '3']);
    });
  });
}
