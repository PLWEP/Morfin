import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/metadata/record_metadata.dart';

void main() {
  group('RecordMetadata Unit Tests', () {
    test('RecordFieldMetadata parses all properties, nested fields, and types', () {
      final json = {
        'key': 'Lines',
        'label': 'Purchase Lines',
        'type': 'array',
        'isKey': false,
        'isRequired': 'TRUE',
        'options': ['optA', 'optB'],
        'lovReference': 'LineLov',
        'lovProjection': 'PurchaseHandling',
        'fields': [
          {'key': 'LineNo', 'label': 'Line Number', 'type': 'number', 'isRequired': true},
          {'key': 'PartNo', 'label': 'Part Number', 'type': 'text', 'isRequired': true},
        ],
      };

      final field = RecordFieldMetadata.fromJson(json);

      expect(field.key, 'Lines');
      expect(field.label, 'Purchase Lines');
      expect(field.type, FieldType.array);
      expect(field.isRequired, true);
      expect(field.options, ['optA', 'optB']);
      expect(field.lovReference, 'LineLov');
      expect(field.lovProjection, 'PurchaseHandling');
      expect(field.nestedFields.length, 2);
      expect(field.nestedFields.first.key, 'LineNo');
      expect(field.nestedFields.first.type, FieldType.number);

      // copyWith
      final updated = field.copyWith(label: 'Updated Lines', isRequired: false);
      expect(updated.label, 'Updated Lines');
      expect(updated.isRequired, false);
      expect(updated.key, 'Lines');
    });

    test('RecordActionMetadata parses global and record scopes with conditions', () {
      final jsonGlobal = {
        'name': 'CreatePO',
        'label': 'Create Purchase Order',
        'icon': 'add',
        'scope': 'global',
        'formFields': [
          {'key': 'VendorNo', 'label': 'Vendor', 'type': 'text', 'isRequired': true},
        ],
        'condition': 'Active == true',
      };

      final action = RecordActionMetadata.fromJson(jsonGlobal);
      expect(action.name, 'CreatePO');
      expect(action.label, 'Create Purchase Order');
      expect(action.icon, 'add');
      expect(action.scope, ActionScope.global);
      expect(action.formFields.length, 1);
      expect(action.condition, 'Active == true');
    });

    test('RecordListCardMetadata parses card layout fields', () {
      final json = {
        'codeField': 'OrderNo',
        'primaryField': 'VendorName',
        'secondaryField': 'Site',
        'statusField': 'Objstate',
        'priorityField': 'Priority',
        'metricField': 'TotalAmount',
      };

      final card = RecordListCardMetadata.fromJson(json);
      expect(card.codeField, 'OrderNo');
      expect(card.primaryField, 'VendorName');
      expect(card.secondaryField, 'Site');
      expect(card.statusField, 'Objstate');
      expect(card.priorityField, 'Priority');
      expect(card.metricField, 'TotalAmount');
    });

    test('RecordSchemaMetadata bundles entity schema with actions and fields', () {
      final json = {
        'recordType': 'PurchaseOrder',
        'title': 'Purchase Orders',
        'icon': 'shopping_cart',
        'projection': 'PurchaseOrderHandling',
        'entitySet': 'PurchaseOrderSet',
        'fields': [
          {'key': 'OrderNo', 'label': 'Order No', 'type': 'text', 'isKey': true},
        ],
        'actions': [
          {'name': 'Release', 'label': 'Release Order'},
        ],
        'listCard': {
          'codeField': 'OrderNo',
          'primaryField': 'OrderNo',
        },
      };

      final schema = RecordSchemaMetadata.fromJson(json);
      expect(schema.recordType, 'PurchaseOrder');
      expect(schema.entityName, 'PurchaseOrder');
      expect(schema.title, 'Purchase Orders');
      expect(schema.projection, 'PurchaseOrderHandling');
      expect(schema.entitySet, 'PurchaseOrderSet');
      expect(schema.fields.length, 1);
      expect(schema.actions.length, 1);
      expect(schema.listCard.codeField, 'OrderNo');
    });
  });
}
