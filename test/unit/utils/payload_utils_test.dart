import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/utils/payload_utils.dart';

void main() {
  group('PayloadUtils', () {
    test('sanitize strips IFS internal metadata keys', () {
      final input = {
        '@odata.context': 'https://...',
        '@odata.etag': 'W/"..."',
        'luname': 'WorkOrder',
        'objid': 'AAABBBCCC',
        'objversion': '20261007',
        'rowkey': 'UUID-1234',
        'rowstate': 'Planned',
        'rowtype': 'Custom',
        'OrderNo': '1001',
        'Customer': 'ACME',
      };

      final cleaned = PayloadUtils.sanitize(input);
      expect(cleaned, {
        'OrderNo': '1001',
        'Customer': 'ACME',
      });
    });

    test('formatActionPayload coerces numbers and booleans properly', () {
      final raw = {
        'Qty': '25',
        'Active': 'TRUE',
        'Note': 'Urgent',
      };

      final fieldDefs = [
        {'key': 'Qty', 'type': 'number', 'isRequired': true},
        {'key': 'Active', 'type': 'boolean', 'isRequired': false},
        {'key': 'Note', 'type': 'string', 'isRequired': false},
      ];

      final formatted = PayloadUtils.formatActionPayload(
        rawValues: raw,
        allFieldDefs: fieldDefs,
      );

      expect(formatted['Qty'], 25);
      expect(formatted['Active'], true);
      expect(formatted['Note'], 'Urgent');
    });

    test('extractErrorMessage parses nested Dio error structures', () {
      final dioErr = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {
            'error': {
              'code': 'VALIDATION_FAILED',
              'message': 'General error',
              'details': [
                {'message': 'Specific quantity constraint failed.'},
              ],
            },
          },
        ),
      );

      final msg = PayloadUtils.extractErrorMessage(dioErr);
      expect(msg, 'Specific quantity constraint failed.');
    });

    test('extractSuccessMessage resolves candidate response keys', () {
      final res1 = {'message': 'Operation completed successfully'};
      expect(PayloadUtils.extractSuccessMessage(res1, fallback: 'Done'), 'Operation completed successfully');

      final res2 = {'value': 'Created PO 2005'};
      expect(PayloadUtils.extractSuccessMessage(res2, fallback: 'Done'), 'Created PO 2005');

      final res3 = <String, dynamic>{};
      expect(PayloadUtils.extractSuccessMessage(res3, fallback: 'Fallback msg'), 'Fallback msg');
    });
  });
}
