import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/odata_filter_builder.dart';

void main() {
  group('ODataFilterBuilder', () {
    test('builds string filter expressions', () {
      final f1 = ODataFilterBuilder.build([
        const ODataFilterEntry(
          odataField: 'Contract',
          op: ODataFilterOp.eq,
          fieldType: ODataFieldType.string,
          value: '2WFCC',
        ),
      ]);
      expect(f1, "Contract eq '2WFCC'");

      final f2 = ODataFilterBuilder.build([
        const ODataFilterEntry(
          odataField: 'Description',
          op: ODataFilterOp.contains,
          fieldType: ODataFieldType.string,
          value: 'Valve',
        ),
      ]);
      expect(f2, "contains(Description,'Valve')");

      final f3 = ODataFilterBuilder.build([
        const ODataFilterEntry(
          odataField: 'PartNo',
          op: ODataFilterOp.startswith,
          fieldType: ODataFieldType.string,
          value: 'CP-',
        ),
      ]);
      expect(f3, "startswith(PartNo,'CP-')");
    });

    test('builds number and between filter expressions', () {
      final fNum = ODataFilterBuilder.build([
        const ODataFilterEntry(
          odataField: 'OriginalQty',
          op: ODataFilterOp.gt,
          fieldType: ODataFieldType.number,
          value: '10',
        ),
      ]);
      expect(fNum, 'OriginalQty gt 10');

      final fBetween = ODataFilterBuilder.build([
        const ODataFilterEntry(
          odataField: 'OriginalQty',
          op: ODataFilterOp.between,
          fieldType: ODataFieldType.number,
          value: '5',
          valueTo: '25',
        ),
      ]);
      expect(fBetween, '(OriginalQty ge 5 and OriginalQty le 25)');
    });

    test('builds enum filter expressions with qualifier', () {
      final fSingleEnum = ODataFilterBuilder.build([
        const ODataFilterEntry(
          odataField: 'Objstate',
          op: ODataFilterOp.eq,
          fieldType: ODataFieldType.enumType,
          selectedValues: {'Planned'},
          enumQualifier: 'IfsApp.PurchaseRequisitionHandling.PurchaseReqLineState',
        ),
      ]);
      expect(
        fSingleEnum,
        "Objstate eq IfsApp.PurchaseRequisitionHandling.PurchaseReqLineState'Planned'",
      );

      final fMultiEnum = ODataFilterBuilder.build([
        const ODataFilterEntry(
          odataField: 'Objstate',
          op: ODataFilterOp.eq,
          fieldType: ODataFieldType.enumType,
          selectedValues: {'Planned', 'Released'},
        ),
      ]);
      expect(
        fMultiEnum,
        "(Objstate eq 'Planned' or Objstate eq 'Released')",
      );
    });

    test('autoQualifyEnum produces qualified IFS Cloud state literal', () {
      final res = ODataFilterBuilder.autoQualifyEnum(
        fieldName: 'Objstate',
        value: 'Planned',
        projection: 'PurchaseRequisitionHandling',
      );
      expect(res, "Objstate eq IfsApp.PurchaseRequisitionHandling.PurchaseRequisitionHandlingState'Planned'");
    });
  });
}
