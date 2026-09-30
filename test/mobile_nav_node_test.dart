import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/models/mobile_nav_node.dart';
import 'package:morfin/core/network/odata_query.dart';

void main() {
  group('MobileNavNode & defaultFilter test', () {
    test('MobileNavNode parses defaultFilter properly from json', () {
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
        'SortOrder': 2,
        'ChildCount': 0,
      };

      final node = MobileNavNode.fromJson(json);
      expect(node.nodeId, 4);
      expect(node.defaultFilter, "Objstate eq 'Planned'");
      expect(node.actionType, 'LIST');
    });

    test('ODataQuery.combineFilters formats filter query correctly', () {
      // 1. Only default filter
      final f1 = ODataQuery.combineFilters(
        defaultFilter: "Objstate eq 'Planned'",
      );
      expect(f1, "(Objstate eq 'Planned')");

      // 2. Default filter + search query
      final f2 = ODataQuery.combineFilters(
        defaultFilter: "Objstate eq 'Planned'",
        searchQuery: 'REQ100',
        searchFields: ['RequisitionNo', 'Description'],
      );
      expect(
        f2,
        "(Objstate eq 'Planned') and (contains(RequisitionNo, 'REQ100') or contains(Description, 'REQ100'))",
      );

      // 3. Only search query
      final f3 = ODataQuery.combineFilters(
        searchQuery: 'TEST',
        searchFields: ['PartNo'],
      );
      expect(f3, "(contains(PartNo, 'TEST'))");

      // 4. Null filters
      final f4 = ODataQuery.combineFilters();
      expect(f4, isNull);
    });

    test('ODataQuery toQueryParams includes formatted \$filter', () {
      final query = ODataQuery(
        filter: ODataQuery.combineFilters(defaultFilter: "Objstate eq 'Planned'"),
        top: 20,
        skip: 0,
      );

      final params = query.toQueryParams();
      expect(params[r'$filter'], "(Objstate eq 'Planned')");
      expect(params[r'$top'], 20);
      expect(params[r'$skip'], 0);
    });
  });
}
