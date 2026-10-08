import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/storage/local_storage_service.dart';
import 'package:morfin/features/login/models/server_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalStorageService Unit Tests', () {
    late LocalStorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = LocalStorageService(prefs);
    });

    test('theme mode get and save', () async {
      expect(storage.getThemeMode(), isNull);
      await storage.saveThemeMode('dark');
      expect(storage.getThemeMode(), 'dark');
    });

    test('servers get and save with legacy filter', () async {
      expect(storage.getServers(), isNull);

      final servers = [
        const ServerConfig(
          id: 'valid-srv-1',
          name: 'Demo Server',
          baseUrl: 'https://demo.ifs.com',
          realm: 'demo',
          clientId: 'morfin',
          clientSecret: '',
        ),
        const ServerConfig(
          id: 'srv-prod-legacy',
          name: 'Old Prod',
          baseUrl: 'https://prod.ifs.com',
          realm: 'prod',
          clientId: 'morfin',
          clientSecret: '',
        ),
      ];

      await storage.saveServers(servers);
      final retrieved = storage.getServers();

      expect(retrieved, isNotNull);
      expect(retrieved!.length, 1);
      expect(retrieved.first.id, 'valid-srv-1');
    });

    test('active server resolution with selected server ID', () async {
      final s1 = const ServerConfig(
        id: 'srv-1',
        name: 'Server One',
        baseUrl: 'https://s1.ifs.com',
        realm: 'r1',
        clientId: 'c1',
        clientSecret: '',
      );
      final s2 = const ServerConfig(
        id: 'srv-2',
        name: 'Server Two',
        baseUrl: 'https://s2.ifs.com',
        realm: 'r2',
        clientId: 'c2',
        clientSecret: '',
      );

      await storage.saveServers([s1, s2]);
      expect(storage.getActiveServer()?.id, 'srv-1');

      await storage.saveSelectedServerId('srv-2');
      expect(storage.getActiveServer()?.id, 'srv-2');
    });

    test('industrial mode and sound feedback flags', () async {
      expect(storage.getIndustrialMode(), false);
      expect(storage.getSoundFeedback(), true);

      await storage.saveIndustrialMode(true);
      await storage.saveSoundFeedback(false);

      expect(storage.getIndustrialMode(), true);
      expect(storage.getSoundFeedback(), false);
    });

    test('favorite menu IDs toggle and retrieve', () async {
      expect(storage.getFavoriteMenuIds(), isEmpty);

      await storage.toggleFavoriteMenuId('MENU_PO');
      expect(storage.getFavoriteMenuIds(), ['MENU_PO']);

      await storage.toggleFavoriteMenuId('MENU_PR');
      expect(storage.getFavoriteMenuIds(), ['MENU_PO', 'MENU_PR']);

      await storage.toggleFavoriteMenuId('MENU_PO'); // Remove
      expect(storage.getFavoriteMenuIds(), ['MENU_PR']);
    });

    test('schema hash and clearAll', () async {
      await storage.saveSchemaHash('PurchaseOrder', 'hash123');
      expect(storage.getSchemaHash('PurchaseOrder'), 'hash123');

      await storage.saveThemeMode('light');
      await storage.clearAll();

      expect(storage.getThemeMode(), isNull);
      expect(storage.getServers(), isNull);
      expect(storage.getFavoriteMenuIds(), isEmpty);
    });
  });
}
