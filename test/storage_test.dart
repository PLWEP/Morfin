import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morfin/core/storage/local_storage_service.dart';
import 'package:morfin/features/login/models/server_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LocalStorageService persists theme mode', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);

    expect(storage.getThemeMode(), isNull);
    await storage.saveThemeMode('light');
    expect(storage.getThemeMode(), equals('light'));
  });

  test('LocalStorageService persists servers and active selection', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);

    const srv1 = ServerConfig(
      id: 'srv-1',
      name: 'Prod IFS',
      baseUrl: 'https://ifs.prod.corp',
      realm: 'ifs',
      clientId: 'mobile_app',
      clientSecret: 'secret123',
    );
    const srv2 = ServerConfig(
      id: 'srv-2',
      name: 'Dev IFS',
      baseUrl: 'https://ifs.dev.corp',
      realm: 'ifs',
      clientId: 'mobile_dev',
      clientSecret: '',
    );

    expect(storage.getServers(), isNull);
    await storage.saveServers([srv1, srv2]);
    await storage.saveSelectedServerId('srv-2');

    final loaded = storage.getServers();
    expect(loaded, isNotNull);
    expect(loaded!.length, equals(2));
    expect(storage.getSelectedServerId(), equals('srv-2'));

    final active = storage.getActiveServer();
    expect(active, isNotNull);
    expect(active!.id, equals('srv-2'));
    expect(active.baseUrl, equals('https://ifs.dev.corp'));
  });

  test('LocalStorageService persists custom client logo', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);

    expect(storage.getCustomLogo(), isNull);
    await storage.saveCustomLogo('https://client.corp/logo.png');
    expect(storage.getCustomLogo(), equals('https://client.corp/logo.png'));
    await storage.clearCustomLogo();
    expect(storage.getCustomLogo(), isNull);
  });
}
