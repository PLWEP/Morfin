import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/utils/schema_hasher.dart';

void main() {
  group('SchemaHasher Unit Tests', () {
    test('computeRawHash is deterministic and produces hex string', () {
      final h1 = SchemaHasher.computeRawHash('WorkOrderHandling');
      final h2 = SchemaHasher.computeRawHash('WorkOrderHandling');
      expect(h1, h2);
      expect(h1.isNotEmpty, true);
      expect(RegExp(r'^[0-9a-fA-F]+$').hasMatch(h1), true);
    });

    test('computeSignature is deterministic regardless of field order in schema', () {
      final schemaA = {
        'type': 'entity',
        'fields': [
          {'key': 'Description', 'type': 'string', 'isRequired': false},
          {'key': 'OrderNo', 'type': 'number', 'isRequired': true},
        ],
        'actions': ['ReleaseOrder', 'CancelOrder'],
      };

      final schemaB = {
        'type': 'entity',
        'fields': [
          {'key': 'OrderNo', 'type': 'number', 'isRequired': true},
          {'key': 'Description', 'type': 'string', 'isRequired': false},
        ],
        'actions': ['CancelOrder', 'ReleaseOrder'],
      };

      final sigA = SchemaHasher.computeSignature(schemaA);
      final sigB = SchemaHasher.computeSignature(schemaB);

      expect(sigA, sigB);
    });

    test('computeSignature changes when field type or requirement changes', () {
      final schemaBase = {
        'type': 'entity',
        'fields': [
          {'key': 'OrderNo', 'type': 'number', 'isRequired': true},
        ],
      };

      final schemaModified = {
        'type': 'entity',
        'fields': [
          {'key': 'OrderNo', 'type': 'string', 'isRequired': true},
        ],
      };

      expect(
        SchemaHasher.computeSignature(schemaBase) != SchemaHasher.computeSignature(schemaModified),
        true,
      );
    });

    test('computeSignature supports property map representation', () {
      final schemaWithMap = {
        'type': 'entity',
        'properties': {
          'PartNo': {'type': 'string'},
          'Qty': {'type': 'number'},
        },
      };

      final sig = SchemaHasher.computeSignature(schemaWithMap);
      expect(sig.isNotEmpty, true);
    });
  });
}
