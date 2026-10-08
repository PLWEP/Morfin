import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/api_config.dart';
import 'package:morfin/features/login/models/server_config.dart';

void main() {
  group('ApiConfig Unit Tests', () {
    final config = ApiConfig.instance;

    setUp(() {
      config.clearTokens();
      config.setServer(const ServerConfig(
        id: '',
        name: '',
        baseUrl: '',
        realm: 'default',
        clientId: '',
        clientSecret: '',
      ));
    });

    test('isServerConfigured reflects baseUrl state', () {
      expect(config.isServerConfigured, false);

      config.setServer(const ServerConfig(
        id: '1',
        name: 'Demo',
        baseUrl: 'https://demo.ifs.cloud',
        realm: 'isidemo',
        clientId: 'morfin',
        clientSecret: '',
      ));

      expect(config.isServerConfigured, true);
    });

    test('token management and isAuthenticated state', () {
      expect(config.isAuthenticated, false);
      expect(config.accessToken, isNull);

      config.setTokens(
        access: 'eyJhbGciOi...',
        refresh: 'eyJhbGciOi_refresh...',
        expiresInSeconds: 3600,
      );

      expect(config.isAuthenticated, true);
      expect(config.accessToken, 'eyJhbGciOi...');
      expect(config.refreshToken, 'eyJhbGciOi_refresh...');
      expect(config.tokenExpiry != null, true);
      expect(config.tokenExpiry!.isAfter(DateTime.now()), true);

      config.clearTokens();
      expect(config.isAuthenticated, false);
      expect(config.accessToken, isNull);
      expect(config.refreshToken, isNull);
      expect(config.tokenExpiry, isNull);
    });

    test('projectionBaseUrl and tokenEndpoint strip trailing slashes', () {
      config.setServer(const ServerConfig(
        id: '1',
        name: 'Trailing Slashes Server',
        baseUrl: 'https://demo.ifs.cloud:48080////',
        realm: 'corp_realm',
        clientId: 'client_id',
        clientSecret: '',
      ));

      expect(
        config.projectionBaseUrl,
        'https://demo.ifs.cloud:48080/main/ifsapplications/projection/v1',
      );

      expect(
        config.tokenEndpoint,
        'https://demo.ifs.cloud:48080/auth/realms/corp_realm/protocol/openid-connect/token',
      );
    });

    test('tokenEndpoint falls back to default realm if blank', () {
      config.setServer(const ServerConfig(
        id: '2',
        name: 'Blank Realm Server',
        baseUrl: 'https://demo.ifs.cloud',
        realm: '   ',
        clientId: 'client_id',
        clientSecret: '',
      ));

      expect(
        config.tokenEndpoint,
        'https://demo.ifs.cloud/auth/realms/default/protocol/openid-connect/token',
      );
    });
  });
}
