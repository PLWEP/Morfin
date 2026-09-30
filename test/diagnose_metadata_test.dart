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

  test(r'Inspect OData $metadata for PurchaseRequisitionHandling', () async {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${ApiConfig.instance.accessToken}';
    (dio.httpClientAdapter as dynamic).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final url = '${ApiConfig.instance.projectionBaseUrl}/PurchaseRequisitionHandling.svc/\$metadata';
    // ignore: avoid_print
    print('GET: $url');

    try {
      final res = await dio.get<String>(url);
      final xml = res.data ?? '';
      // ignore: avoid_print
      print('Status: ${res.statusCode}');
      // ignore: avoid_print
      print('Metadata XML length: ${xml.length}');

      // Let's search for "CreatePurchaseRequisition" or Action in xml
      final hasAction = xml.contains('CreatePurchaseRequisition');
      // ignore: avoid_print
      print('Contains CreatePurchaseRequisition: $hasAction');

      // Let's find any <Action Name="...
      final actionRegex = RegExp(r'<Action\s+Name="([^"]+)"[^>]*>(.*?)</Action>', dotAll: true);
      final matches = actionRegex.allMatches(xml);
      // ignore: avoid_print
      print('Total Actions found: ${matches.length}');
      for (final m in matches.take(10)) {
        // ignore: avoid_print
        print('Action Found: ${m.group(1)}');
        // ignore: avoid_print
        print('Content: ${m.group(2)}');
      }

      // Search for EntityType with Name="PurchaseRequisition"
      final etIndex = xml.indexOf('<EntityType Name="PurchaseRequisition"');
      if (etIndex != -1) {
        final etEnd = xml.indexOf('</EntityType>', etIndex);
        final snippet = xml.substring(etIndex, etEnd + 13);
        // ignore: avoid_print
        print('=== PURCHASE REQUISITION SNIPPET ===');
        // ignore: avoid_print
        print(snippet.substring(0, snippet.length > 500 ? 500 : snippet.length));
        final props = RegExp(r'<Property\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)').allMatches(snippet);
        // ignore: avoid_print
        print('=== PURCHASE REQUISITION ENTITY PROPERTIES (${props.length}) ===');
        for (final p in props.take(15)) {
          final isNullable = p.group(3)?.contains('Nullable="false"') == true ? '[REQUIRED]' : '[OPTIONAL]';
          // ignore: avoid_print
          print('  -> Field: ${p.group(1)} | Type: ${p.group(2)} $isNullable');
        }
      }

      // Check Action CreateRequisitionLineToOrder parameters
      final actIndex = xml.indexOf('<Action Name="CreateRequisitionLineToOrder"');
      if (actIndex != -1) {
        final actEnd = xml.indexOf('</Action>', actIndex);
        final actSnippet = xml.substring(actIndex, actEnd + 9);
        final params = RegExp(r'<Parameter\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)/>|<Parameter\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)></Parameter>').allMatches(actSnippet);
        // ignore: avoid_print
        print('=== ACTION CreateRequisitionLineToOrder PARAMETERS (${params.length}) ===');
        for (final p in params) {
          final name = p.group(1) ?? p.group(4);
          final type = p.group(2) ?? p.group(5);
          // ignore: avoid_print
          print('  -> Param: $name | Type: $type');
        }
      }

    } catch (e) {
      // ignore: avoid_print
      print('Metadata request failed: $e');
    }
  });
}
