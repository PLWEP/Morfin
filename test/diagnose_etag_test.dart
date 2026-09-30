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

  test(r'Check ETag / If-None-Match support on $metadata and $openapi', () async {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${ApiConfig.instance.accessToken}';
    (dio.httpClientAdapter as dynamic).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final baseUrl = '${ApiConfig.instance.projectionBaseUrl}/PurchaseRequisitionHandling.svc';

    // 1. Test $metadata ETag
    final metaRes = await dio.get<String>('$baseUrl/\$metadata');
    final metaEtag = metaRes.headers.value('etag');
    final metaLastMod = metaRes.headers.value('last-modified');
    // ignore: avoid_print
    print('Metadata ETag: $metaEtag | Last-Modified: $metaLastMod');

    if (metaEtag != null) {
      try {
        final recheck = await dio.get<dynamic>(
          '$baseUrl/\$metadata',
          options: Options(headers: {'If-None-Match': metaEtag}),
        );
        // ignore: avoid_print
        print('Metadata with If-None-Match status: ${recheck.statusCode}');
      } on DioException catch (e) {
        // ignore: avoid_print
        print('Metadata with If-None-Match response: ${e.response?.statusCode}');
      }
    }

    // 2. Test $openapi?V2&minimal=true ETag
    final openapiRes = await dio.get<dynamic>('$baseUrl/\$openapi?V2&minimal=true');
    final openapiEtag = openapiRes.headers.value('etag');
    final openapiLastMod = openapiRes.headers.value('last-modified');
    // ignore: avoid_print
    print('OpenAPI ETag: $openapiEtag | Last-Modified: $openapiLastMod');

    // 3. Inspect OpenAPI V2 minimal definitions for PurchaseRequisition
    if (openapiRes.data is Map) {
      final defs = (openapiRes.data as Map)['definitions'] as Map?;
      final targetDef = defs?['PurchaseRequisition-Insert'] ?? defs?['PurchaseRequisition'];
      // ignore: avoid_print
      print('OpenAPI PurchaseRequisition def found: ${targetDef != null}');
      if (targetDef is Map) {
        final props = targetDef['properties'] as Map?;
        final requiredFields = targetDef['required'] as List?;
        // ignore: avoid_print
        print('Properties count: ${props?.length}');
        // ignore: avoid_print
        print('Required fields: $requiredFields');
        if (props != null) {
          for (final key in props.keys.take(6)) {
            // ignore: avoid_print
            print('  Prop: $key -> ${props[key]}');
          }
        }
      }
    }
  });
}
