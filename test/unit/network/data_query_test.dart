import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/data_query.dart';

void main() {
  group('DataQuery Unit Tests', () {
    test('toQueryParams formats all OData query clauses correctly', () {
      const query = DataQuery(
        filter: "Objstate eq 'Planned'",
        select: ['OrderNo', 'Contract', 'DateCreated'],
        orderby: 'DateCreated desc',
        top: 25,
        skip: 50,
        expand: ['OrderLines', 'CustomerInfo'],
        customParams: {'customFlag': 'true'},
      );

      final params = query.toQueryParams();

      expect(params[r'$filter'], "Objstate eq 'Planned'");
      expect(params[r'$select'], 'OrderNo,Contract,DateCreated');
      expect(params[r'$orderby'], 'DateCreated desc');
      expect(params[r'$top'], 25);
      expect(params[r'$skip'], 50);
      expect(params[r'$expand'], 'OrderLines,CustomerInfo');
      expect(params['customFlag'], 'true');
    });

    test('copyWith updates specified query fields only', () {
      const initial = DataQuery(
        filter: 'Active eq true',
        top: 10,
      );

      final modified = initial.copyWith(
        top: 50,
        skip: 20,
      );

      expect(modified.filter, 'Active eq true');
      expect(modified.top, 50);
      expect(modified.skip, 20);
    });

    test('combineFilters normalizes 0bjstate and joins multi-field search conditions', () {
      // 1. objstate typo correction
      final f1 = DataQuery.combineFilters(defaultFilter: "0bjstate eq 'Planned'");
      expect(f1, "Objstate eq 'Planned'");

      // 2. search query with multiple fields
      final f2 = DataQuery.combineFilters(
        searchQuery: 'PUMP',
        searchFields: ['PartNo', 'Description'],
      );
      expect(f2, "(contains(PartNo, 'PUMP') or contains(Description, 'PUMP'))");

      // 3. both combined
      final f3 = DataQuery.combineFilters(
        defaultFilter: "Contract eq '2WFCC'",
        searchQuery: 'BOLT',
        searchFields: ['PartNo'],
      );
      expect(f3, "(Contract eq '2WFCC') and (contains(PartNo, 'BOLT'))");

      // 4. empty returns null
      expect(DataQuery.combineFilters(), isNull);
      expect(DataQuery.combineFilters(defaultFilter: '   '), isNull);
    });
  });
}
