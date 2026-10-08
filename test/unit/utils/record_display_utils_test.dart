import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/utils/record_display_utils.dart';

void main() {
  group('RecordDisplayUtils Unit Tests', () {
    test('isMetadataKey accurately filters ERP system fields', () {
      expect(RecordDisplayUtils.isMetadataKey('luname'), true);
      expect(RecordDisplayUtils.isMetadataKey('LuName'), true);
      expect(RecordDisplayUtils.isMetadataKey('objid'), true);
      expect(RecordDisplayUtils.isMetadataKey('ObjVersion'), true);
      expect(RecordDisplayUtils.isMetadataKey('objstate'), true);
      expect(RecordDisplayUtils.isMetadataKey('objevents'), true);
      expect(RecordDisplayUtils.isMetadataKey('@odata.context'), true);
      expect(RecordDisplayUtils.isMetadataKey('@odata.etag'), true);

      expect(RecordDisplayUtils.isMetadataKey('OrderNo'), false);
      expect(RecordDisplayUtils.isMetadataKey('VendorName'), false);
      expect(RecordDisplayUtils.isMetadataKey('TotalAmount'), false);
    });

    test('formatLabel inserts spaces between camelCase boundaries', () {
      expect(RecordDisplayUtils.formatLabel('OrderNo'), 'Order No');
      expect(RecordDisplayUtils.formatLabel('deliveryAddress'), 'delivery Address');
      expect(RecordDisplayUtils.formatLabel('Site'), 'Site');
    });

    test('extractDisplayRows returns first two valid business properties', () {
      final record = {
        '@odata.context': 'https://...',
        'objid': '12345',
        'luname': 'CustomerOrder',
        'OrderNo': 'PO-9001',
        'CustomerName': 'MegaCorp Industries',
        'Amount': 50000,
      };

      final rows = RecordDisplayUtils.extractDisplayRows(record);
      expect(rows.length, 2);
      expect(rows[0], ('Order No', 'PO-9001'));
      expect(rows[1], ('Customer Name', 'MegaCorp Industries'));
    });

    test('extractDisplayRows returns empty list when all fields are metadata or null', () {
      final record = {
        'objid': '12345',
        'luname': 'CustomerOrder',
        'EmptyField': null,
      };

      final rows = RecordDisplayUtils.extractDisplayRows(record);
      expect(rows.isEmpty, true);
    });
  });
}
