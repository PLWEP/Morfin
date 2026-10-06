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

  test('Test MobileLobbyHandling API endpoints', () async {
    final configFile = File('test/real_api_config.json');
    final config = jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;

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

    final loginOk = await ApiClient.instance.authenticateOAuth(
      username: config['username'] as String? ?? 'ifsapp',
      password: config['password'] as String? ?? 'ifsapp',
    );
    print('Login result: $loginOk');
    expect(loginOk, isTrue);

    // 1. Test GetMobileLobby() function
    try {
      final lobbyFuncRes = await ApiClient.instance.callFunction(
        'MobileLobbyHandling',
        'GetMobileLobby()',
      );
      print('GetMobileLobby() function response:');
      print(jsonEncode(lobbyFuncRes));
    } catch (e) {
      print('GetMobileLobby() function error: $e');
    }

    // 2. Test MobileLobbyElementSet collection
    try {
      final lobbySetRes = await ApiClient.instance.getCollection(
        'MobileLobbyHandling',
        'MobileLobbyElementSet',
      );
      print('MobileLobbyElementSet count: ${lobbySetRes.length}');
      for (final item in lobbySetRes) {
        print('Element: ${item['ElementId']} - ${item['Title']} - ${item['ElementType']}');
      }
    } catch (e) {
      print('MobileLobbyElementSet error: $e');
    }
  });
}
