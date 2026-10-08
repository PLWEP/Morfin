import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/api_config.dart';
import 'package:morfin/core/services/activity_log_service.dart';
import 'package:morfin/features/login/models/server_config.dart';

void main() {
  group('ActivityLogService Unit Tests', () {
    final service = ActivityLogService.instance;

    setUp(() {
      service.clear();
      ApiConfig.instance.setServer(const ServerConfig(
        id: 'srv-test',
        name: 'Test Server',
        baseUrl: 'https://test.ifs.cloud',
        realm: 'test-realm',
        clientId: 'morfin',
        clientSecret: '',
      ));
    });

    test('log records entries and respects max circular cap of 100', () {
      expect(service.logs.isEmpty, true);

      service.log('First log', level: LogLevel.info, details: 'Initial bootstrap');
      expect(service.logs.length, 1);
      expect(service.logs.first.message, 'First log');
      expect(service.logs.first.level, LogLevel.info);
      expect(service.logs.first.details, 'Initial bootstrap');

      for (int i = 2; i <= 105; i++) {
        service.log('Log entry $i');
      }

      expect(service.logs.length, 100);
      expect(service.logs.first.message, 'Log entry 6');
      expect(service.logs.last.message, 'Log entry 105');
    });

    test('logNetwork categorizes status codes properly', () {
      service.logNetwork(
        method: 'GET',
        url: '/PurchaseOrderSet',
        statusCode: 200,
        duration: const Duration(milliseconds: 150),
      );

      service.logNetwork(
        method: 'POST',
        url: '/ReleaseOrder',
        statusCode: 500,
        duration: const Duration(milliseconds: 320),
        error: 'Internal Server Error',
      );

      service.logNetwork(
        method: 'GET',
        url: '/TimeoutEndpoint',
        statusCode: null,
        error: 'Network Unreachable',
      );

      expect(service.logs.length, 3);
      expect(service.logs[0].level, LogLevel.network);
      expect(service.logs[0].message, 'GET /PurchaseOrderSet -> 200 (150ms)');

      expect(service.logs[1].level, LogLevel.error);
      expect(service.logs[1].message, 'POST /ReleaseOrder -> 500 (320ms)');
      expect(service.logs[1].details, 'Internal Server Error');

      expect(service.logs[2].level, LogLevel.error);
      expect(service.logs[2].message, 'GET /TimeoutEndpoint -> FAIL');
      expect(service.logs[2].details, 'Network Unreachable');
    });

    test('exportAsText and clear operate reliably', () {
      service.log('Test export operation', level: LogLevel.warning);
      final export = service.exportAsText();

      expect(export.contains('=== MORFIN ACTIVITY LOG EXPORT ==='), true);
      expect(export.contains('Server URL: https://test.ifs.cloud'), true);
      expect(export.contains('Realm: test-realm'), true);
      expect(export.contains('[WARNING] Test export operation'), true);

      service.clear();
      expect(service.logs.isEmpty, true);
      final emptyExport = service.exportAsText();
      expect(emptyExport.contains('No activity records captured.'), true);
    });
  });
}
