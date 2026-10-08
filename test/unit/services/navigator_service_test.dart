import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/services/navigator_service.dart';

void main() {
  group('NavigatorService Unit Tests', () {
    final service = NavigatorService.instance;

    setUp(() {
      service.clearCache();
    });

    test('parseTargetUrl handles various URL formats', () {
      expect(service.parseTargetUrlForTesting(null), (null, null));
      expect(service.parseTargetUrlForTesting(''), (null, null));
      expect(service.parseTargetUrlForTesting('invalid_url_without_svc'), (null, null));

      final (proj1, ep1) = service.parseTargetUrlForTesting('PurchaseOrderHandling.svc/PurchaseOrderSet');
      expect(proj1, 'PurchaseOrderHandling');
      expect(ep1, 'PurchaseOrderSet');

      final (proj2, ep2) = service.parseTargetUrlForTesting('/MobileAppDesignHandling.svc/MobileAppDesignSet?\$filter=Active eq true');
      expect(proj2, 'MobileAppDesignHandling');
      expect(ep2, 'MobileAppDesignSet');
    });

    test('transformNodesForTesting structures hierarchy and actions correctly', () {
      final mockNodes = [
        {
          'NodeId': 'ROOT_PROC',
          'ParentId': null,
          'Label': 'Procurement',
          'ActionType': 'PARENT',
        },
        {
          'NodeId': 'ITEM_PO',
          'ParentId': 'ROOT_PROC',
          'Label': 'Purchase Orders',
          'ActionType': 'LIST',
          'TargetUrl': 'PurchaseOrderHandling.svc/PurchaseOrderSet',
          'ColumnConfig': 'TITLE=OrderNo^SUBTITLE=VendorName',
          'ChildCount': 2,
        },
        {
          'NodeId': 'ACTION_CREATE_PO',
          'ParentId': 'ITEM_PO',
          'Label': 'Create PO',
          'ActionType': 'FORM',
          'TargetUrl': 'PurchaseOrderHandling.svc/CreateOrder',
        },
        {
          'NodeId': 'ACTION_RELEASE_PO',
          'ParentId': 'ITEM_PO',
          'Label': 'Release PO',
          'ActionType': 'ACTION',
          'TargetUrl': 'PurchaseOrderHandling.svc/ReleaseOrder',
        },
        {
          'NodeId': 'ITEM_SHEET',
          'ParentId': 'ROOT_PROC',
          'Label': 'Sub Navigation',
          'ActionType': 'BOTTOM_SHEET',
          'ChildCount': 0,
        },
      ];

      final menu = service.transformNodesForTesting(mockNodes);

      expect(menu.groups.length, 1);
      final procGroup = menu.groups.first;
      expect(procGroup.id, 'ROOT_PROC');
      expect(procGroup.title, 'Procurement');
      expect(procGroup.items.length, 2);

      final poItem = procGroup.items.firstWhere((i) => i.id == 'ITEM_PO');
      expect(poItem.title, 'Purchase Orders');
      expect(poItem.action!.target, '/PurchaseOrderHandling');
      expect(poItem.action!.params['entitySet'], 'PurchaseOrderSet');
      expect(poItem.action!.params['hasChildren'], true);
      expect(poItem.action!.params['columnConfig'], 'TITLE=OrderNo^SUBTITLE=VendorName');

      final sheetItem = procGroup.items.firstWhere((i) => i.id == 'ITEM_SHEET');
      expect(sheetItem.action!.target, '/bottom_sheet');
      expect(sheetItem.action!.params['hasChildren'], true);

      // Verify getChildActions extracts action nodes
      final childActions = service.getChildActions('ITEM_PO');
      expect(childActions.length, 2);
      expect(childActions.map((a) => a['NodeId']).toSet(), {'ACTION_CREATE_PO', 'ACTION_RELEASE_PO'});

      // Form item badge verification
      final formChildren = service.getChildrenOfNode('ITEM_PO');
      final formChild = formChildren.firstWhere((c) => c.id == 'ACTION_CREATE_PO');
      expect(formChild.badgeText, 'Form');
      expect(formChild.badgeType, 'warning');
    });

    test('clearCache purges cached nodes and groups', () {
      final mockNodes = [
        {'NodeId': 'R1', 'ParentId': null, 'Label': 'Inventory', 'ActionType': 'PARENT'},
        {'NodeId': 'C1', 'ParentId': 'R1', 'Label': 'Parts', 'ActionType': 'LIST'},
      ];

      service.transformNodesForTesting(mockNodes);
      expect(service.cachedNodes.length, 2);

      service.clearCache();
      expect(service.cachedNodes.isEmpty, true);
      expect(service.cachedMenu, isNull);
      expect(service.getChildrenOfNode('R1').isEmpty, true);
    });
  });
}
