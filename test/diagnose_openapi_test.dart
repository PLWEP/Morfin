import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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

  setUpAll(() async {
    HttpOverrides.global = _TestHttpOverrides();
    if (!configFile.existsSync()) {
      fail('Missing test/real_api_config.json!');
    }
    config = jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;

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

    final username = config['username'] as String? ?? 'ifsapp';
    final password = config['password'] as String? ?? 'ifsapp';
    await ApiClient.instance.authenticateOAuth(
      username: username,
      password: password,
      scope: 'openid',
      responseType: 'id_token',
    );
  });

  test('Compare OData Metadata vs OpenAPI endpoints', () async {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${ApiConfig.instance.accessToken}';
    (dio.httpClientAdapter as dynamic).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final baseUrl = '${ApiConfig.instance.projectionBaseUrl}/PurchaseRequisitionHandling.svc';
    final endpoints = [
      r'$metadata',
      r'$openapi?V3',
      r'$openapi?V2&minimal=true',
      r'$openapi?V2',
    ];

    for (final ep in endpoints) {
      final sw = Stopwatch()..start();
      final url = '$baseUrl/$ep';
      try {
        final res = await dio.get<dynamic>(url);
        sw.stop();
        final rawData = res.data;
        int byteSize = 0;
        String snippet = '';
        if (rawData is String) {
          byteSize = rawData.length;
          snippet = rawData.substring(0, rawData.length > 200 ? 200 : rawData.length);
        } else if (rawData is Map) {
          final jsonStr = jsonEncode(rawData);
          byteSize = jsonStr.length;
          snippet = jsonStr.substring(0, jsonStr.length > 200 ? 200 : jsonStr.length);
        }

        // ignore: avoid_print
        print('-----------------------------------------');
        // ignore: avoid_print
        print('ENDPOINT: $ep');
        // ignore: avoid_print
        print('STATUS: ${res.statusCode} | TIME: ${sw.elapsedMilliseconds}ms | SIZE: ${(byteSize / 1024).toStringAsFixed(1)} KB');
        // ignore: avoid_print
        print('SNIPPET: $snippet');

        if (rawData is Map) {
          // If it's JSON OpenAPI, let's see keys
          // ignore: avoid_print
          print('Top-level JSON keys: ${rawData.keys.toList()}');
          if (rawData['paths'] != null && rawData['paths'] is Map) {
            final paths = (rawData['paths'] as Map).keys.take(5).toList();
            // ignore: avoid_print
            print('Paths sample: $paths');
          }
          if (rawData['definitions'] != null && rawData['definitions'] is Map) {
            final defs = (rawData['definitions'] as Map).keys.take(5).toList();
            // ignore: avoid_print
            print('Definitions sample: $defs');
          }
          if (rawData['components'] != null && rawData['components'] is Map) {
            final comp = (rawData['components'] as Map).keys.toList();
            // ignore: avoid_print
            print('Components sample: $comp');
          }
        }
      } catch (e) {
        sw.stop();
        // ignore: avoid_print
        print('-----------------------------------------');
        // ignore: avoid_print
        print('ENDPOINT $ep FAILED (${sw.elapsedMilliseconds}ms): $e');
      }
    }
  });
}
