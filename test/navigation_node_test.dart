import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/models/navigation_node.dart';
import 'package:morfin/core/network/data_query.dart';

void main() {
  group('NavigationNode & defaultFilter test', () {
    test('NavigationNode parses defaultFilter properly from json', () {
      final json = {
        'NodeId': 4,
        'ParentId': 2,
        'Label': 'Release Purchase Requisition',
        'ActionType': 'LIST',
        'Icon': 'shopping_cart',
        'TargetUrl': 'PurchaseRequisitionHandling.svc/PurchaseRequisitionSet',
        'DefaultFilter': "Objstate eq 'Planned'",
        'ItemClickAction': null,
        'ItemClickTarget': null,
        'ItemClickFields': null,
        'ColumnConfig': 'TITLE=RequisitionNo^',
        'ParamConfig': 'BuyerCode=DEFAULT_USER^HIDE=FullSelection,OwnPoNumber^CentralOrderFlag=FALSE^',
        'SortOrder': 2,
        'ChildCount': 0,
      };

      final node = NavigationNode.fromJson(json);
      expect(node.nodeId, 4);
      expect(node.defaultFilter, "Objstate eq 'Planned'");
      expect(node.paramConfig, 'BuyerCode=DEFAULT_USER^HIDE=FullSelection,OwnPoNumber^CentralOrderFlag=FALSE^');
      expect(node.paramDefaults, {
        'BuyerCode': 'DEFAULT_USER',
        'CentralOrderFlag': 'FALSE',
      });
      expect(node.hiddenParams, {'FULLSELECTION', 'OWNPONUMBER'});
    });

    test('DataQuery.combineFilters formats filter query correctly', () {
      final f1 = DataQuery.combineFilters(
        defaultFilter: "0bjstate eq 'Planned'",
      );
      expect(f1, "Objstate eq 'Planned'");

      final f2 = DataQuery.combineFilters(
        defaultFilter: "Objstate eq 'Planned'",
        searchQuery: 'REQ100',
        searchFields: ['RequisitionNo', 'Description'],
      );
      expect(
        f2,
        "(Objstate eq 'Planned') and (contains(RequisitionNo, 'REQ100') or contains(Description, 'REQ100'))",
      );

      final f3 = DataQuery.combineFilters(
        searchQuery: 'TEST',
        searchFields: ['PartNo'],
      );
      expect(f3, "(contains(PartNo, 'TEST'))");

      final f4 = DataQuery.combineFilters();
      expect(f4, isNull);
    });

    test('DataQuery toQueryParams includes formatted \$filter', () {
      final query = DataQuery(
        filter: DataQuery.combineFilters(defaultFilter: "Objstate eq 'Planned'"),
        top: 20,
        skip: 0,
      );

      final params = query.toQueryParams();
      expect(params[r'$filter'], "Objstate eq 'Planned'");
      expect(params[r'$top'], 20);
      expect(params[r'$skip'], 0);
    });
  });
}
