import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/api_client.dart';
import 'package:morfin/core/network/api_config.dart';
import 'package:morfin/features/login/models/server_config.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() {
  HttpOverrides.global = _TestHttpOverrides();

  late Map<String, dynamic> config;
  final configFile = File('test/real_api_config.json');

  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
    if (!configFile.existsSync()) {
      fail('Missing test/real_api_config.json!');
    }
    config = jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
  });

  test('Real API 01: Setup ServerConfig & Endpoint Configuration', () {
    final server = ServerConfig(
      id: 'isidemo_server',
      name: config['name'] as String? ?? 'ISI Demo Cloud',
      baseUrl: config['baseUrl'] as String,
      realm: config['realm'] as String? ?? 'isidemo',
      clientId: config['clientId'] as String? ?? 'IFS_connect',
      clientSecret: config['clientSecret'] as String? ?? '',
    );

    ApiConfig.instance.setServer(server);
    ApiClient.instance.enableSelfSignedCertificates();

    expect(ApiConfig.instance.activeServer.baseUrl, equals('https://isidemocloud.ifssi.co.id/'));
    expect(ApiConfig.instance.activeServer.realm, equals('isidemo'));
    expect(
      ApiConfig.instance.tokenEndpoint,
      equals('https://isidemocloud.ifssi.co.id/auth/realms/isidemo/protocol/openid-connect/token'),
    );
  });

  test('Real API 02: Login / Get Token (OAuth 2.0 Password Grant)', () async {
    final username = config['username'] as String? ?? 'ifsapp';
    final password = config['password'] as String? ?? 'ifsapp';
    final scope = config['scope'] as String? ?? 'openid';
    final responseType = config['response_type'] as String? ?? 'id_token';

    final success = await ApiClient.instance.authenticateOAuth(
      username: username,
      password: password,
      scope: scope,
      responseType: responseType,
    );

    expect(success, isTrue, reason: 'Login / token acquisition failed');
    expect(ApiConfig.instance.isAuthenticated, isTrue);
    expect(ApiConfig.instance.accessToken, isNotNull);

    final token = ApiConfig.instance.accessToken!;
    final preview = token.length > 20 ? '${token.substring(0, 10)}...${token.substring(token.length - 10)}' : token;
    // ignore: avoid_print
    print('SUCCESS: Received Access Token: $preview');
    // ignore: avoid_print
    print('Token Expiry: ${ApiConfig.instance.tokenExpiry}');
    // ignore: avoid_print
    print('Has Refresh Token: ${ApiConfig.instance.refreshToken != null}');
  });

  test('Real API 03: Refresh Token Cycle', () async {
    final refreshToken = ApiConfig.instance.refreshToken;
    expect(refreshToken, isNotNull, reason: 'No refresh token available from login step');

    final success = await ApiClient.instance.refreshTokenOAuth(
      grantType: 'refresh_token',
      scope: config['scope'] as String? ?? 'openid',
      responseType: config['response_type'] as String? ?? 'id_token',
    );

    expect(success, isTrue, reason: 'Refresh token request failed');
    expect(ApiConfig.instance.isAuthenticated, isTrue);
    expect(ApiConfig.instance.accessToken, isNotNull);

    final token = ApiConfig.instance.accessToken!;
    final preview = token.length > 20 ? '${token.substring(0, 10)}...${token.substring(token.length - 10)}' : token;
    // ignore: avoid_print
    print('SUCCESS: Successfully refreshed Access Token: $preview');
  });

  test('Real API 04: Fetch Current User Information', () async {
    final userInfo = await ApiClient.instance.getCurrentUserInformation();
    expect(userInfo, isNotNull);
    expect(userInfo!['UserId'], isNotNull);
    // ignore: avoid_print
    print('SUCCESS: Current User: ${userInfo['Name']} (${userInfo['UserId']})');
  });
}
