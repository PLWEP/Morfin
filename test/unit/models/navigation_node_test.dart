import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/models/navigation_node.dart';

void main() {
  group('NavigationNode Unit Tests', () {
    test('fromJson and toJson roundtrip preserves all fields', () {
      final json = {
        'NodeId': 101,
        'ParentId': 10,
        'Label': 'Work Orders',
        'ActionType': 'LIST',
        'TargetUrl': 'ActiveSeparateHandling.svc/ActiveSeparateSet',
        'TargetProjection': 'ActiveSeparateHandling',
        'TargetEndpoint': 'ActiveSeparateSet',
        'DefaultFilter': "Objstate eq 'Prepared'",
        'ItemClickAction': 'NAVIGATE',
        'ItemClickTarget': '/detail',
        'ItemClickFields': 'WoNo,Contract',
        'ColumnConfig': 'TITLE=WoNo^SUBTITLE=ErrDescr',
        'ParamConfig': 'Contract=2WFCC^HIDE=Objstate,KeyRef^Priority=1',
        'SortOrder': 5,
        'ChildCount': 2,
      };

      final node = NavigationNode.fromJson(json);

      expect(node.nodeId, 101);
      expect(node.parentId, 10);
      expect(node.label, 'Work Orders');
      expect(node.actionType, 'LIST');
      expect(node.targetUrl, 'ActiveSeparateHandling.svc/ActiveSeparateSet');
      expect(node.targetProjection, 'ActiveSeparateHandling');
      expect(node.targetEndpoint, 'ActiveSeparateSet');
      expect(node.defaultFilter, "Objstate eq 'Prepared'");
      expect(node.itemClickAction, 'NAVIGATE');
      expect(node.itemClickTarget, '/detail');
      expect(node.itemClickFields, 'WoNo,Contract');
      expect(node.columnConfig, 'TITLE=WoNo^SUBTITLE=ErrDescr');
      expect(node.paramConfig, 'Contract=2WFCC^HIDE=Objstate,KeyRef^Priority=1');
      expect(node.sortOrder, 5);
      expect(node.childCount, 2);

      // Verify toJson
      final serialized = node.toJson();
      expect(serialized['NodeId'], 101);
      expect(serialized['Label'], 'Work Orders');
      expect(serialized['ColumnConfig'], 'TITLE=WoNo^SUBTITLE=ErrDescr');

      // Verify getters
      expect(node.paramDefaults, {
        'Contract': '2WFCC',
        'Priority': '1',
      });
      expect(node.hiddenParams, {'OBJSTATE', 'KEYREF'});
    });

    test('handles empty or null paramConfig gracefully', () {
      const node = NavigationNode(
        nodeId: 1,
        label: 'Simple',
        actionType: 'LIST',
        sortOrder: 1,
        childCount: 0,
      );

      expect(node.paramDefaults, isEmpty);
      expect(node.hiddenParams, isEmpty);
    });
  });
}
