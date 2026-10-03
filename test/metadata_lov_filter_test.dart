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

/// Helper to parse keys of an EntityType from OData $metadata XML
List<String> extractKeyFields(String xml, String entityName) {
  // Find <EntityType Name="entityName" ...> ... </EntityType>
  final etRegex = RegExp('<EntityType\\s+Name="$entityName"[^>]*>', caseSensitive: false);
  final match = etRegex.firstMatch(xml);
  if (match == null) return [];

  final startIdx = match.start;
  final endIdx = xml.indexOf('</EntityType>', startIdx);
  if (endIdx == -1) return [];

  final snippet = xml.substring(startIdx, endIdx + 13);
  final keyBlockMatch = RegExp(r'<Key>(.*?)</Key>', dotAll: true).firstMatch(snippet);
  if (keyBlockMatch == null) return [];

  final propRefRegex = RegExp(r'<PropertyRef\s+Name="([^"]+)"');
  final keys = <String>[];
  for (final m in propRefRegex.allMatches(keyBlockMatch.group(1)!)) {
    final keyName = m.group(1);
    if (keyName != null && keyName.isNotEmpty) {
      keys.add(keyName);
    }
  }
  return keys;
}

/// Resolve dynamic filter URL based on metadata keys and available form values
String? buildMetadataDrivenFilter({
  required List<String> keyFields,
  required String targetFieldKey,
  required Map<String, dynamic> availableValues,
}) {
  final targetLower = targetFieldKey.toLowerCase();
  final filterParts = <String>[];

  // For each key of the LOV entity, check if it's NOT the target field itself,
  // and see if the form has a value for this key!
  for (final key in keyFields) {
    if (key.toLowerCase() == targetLower) continue;

    // Check if availableValues has this key
    final matchingEntry = availableValues.entries.firstWhere(
      (e) => e.key.toLowerCase() == key.toLowerCase() && e.value != null && e.value.toString().isNotEmpty,
      orElse: () => const MapEntry('', null),
    );

    if (matchingEntry.key.isNotEmpty) {
      filterParts.add("$key eq '${matchingEntry.value}'");
    }
  }

  if (filterParts.isEmpty) return null;
  return filterParts.join(' and ');
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

  test('Verify Metadata-Driven LOV Filtering on MorfinApiHandling', () async {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${ApiConfig.instance.accessToken}';
    (dio.httpClientAdapter as dynamic).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // 1. Fetch live OData $metadata XML
    final metaUrl = '${ApiConfig.instance.projectionBaseUrl}/MorfinApiHandling.svc/\$metadata';
    final response = await dio.get<String>(metaUrl);
    expect(response.statusCode, 200);
    final xml = response.data!;

    // 2. Extract keys for PurchasePartLov, IsoUnit, IsoCurrency
    final partKeys = extractKeyFields(xml, 'PurchasePartLov');
    final unitKeys = extractKeyFields(xml, 'IsoUnit');
    final currencyKeys = extractKeyFields(xml, 'IsoCurrency');

    print('================ METADATA KEYS ================');
    print('PurchasePartLov keys: $partKeys');
    print('IsoUnit keys:         $unitKeys');
    print('IsoCurrency keys:     $currencyKeys');
    print('================================================');

    expect(partKeys, containsAll(['Contract', 'PartNo']));
    expect(unitKeys, contains('UnitCode'));
    expect(unitKeys, isNot(contains('Contract')));
    expect(currencyKeys, contains('CurrencyCode'));
    expect(currencyKeys, isNot(contains('Contract')));

    // 3. Simulate form state
    final formValues = <String, dynamic>{
      'Contract': '2WFCC',
      'BuyerId': '*',
      'Quantity': 1,
      'Price': 1000,
    };

    // 4. Test filter generation for PartNo
    final partFilter = buildMetadataDrivenFilter(
      keyFields: partKeys,
      targetFieldKey: 'PartNo',
      availableValues: formValues,
    );
    print('PartNo LOV Filter:     $partFilter');
    expect(partFilter, "Contract eq '2WFCC'");

    // 5. Test filter generation for UnitMeasure (Should be NULL!)
    final unitFilter = buildMetadataDrivenFilter(
      keyFields: unitKeys,
      targetFieldKey: 'UnitMeasure',
      availableValues: formValues,
    );
    print('UnitMeasure LOV Filter: $unitFilter');
    expect(unitFilter, isNull);

    // 6. Test filter generation for CurrencyCode (Should be NULL!)
    final currFilter = buildMetadataDrivenFilter(
      keyFields: currencyKeys,
      targetFieldKey: 'CurrencyCode',
      availableValues: formValues,
    );
    print('Currency LOV Filter:    $currFilter');
    expect(currFilter, isNull);

    // 7. Execute actual HTTP queries to verify the live API accepts them
    print('================ EXECUTING LIVE QUERIES ================');
    final partQueryUrl = '${ApiConfig.instance.projectionBaseUrl}/MorfinApiHandling.svc/Reference_PurchasePartLov?\$filter=$partFilter&\$top=5';
    print('Testing Part Query: $partQueryUrl');
    final partRes = await dio.get<Map<String, dynamic>>(partQueryUrl);
    expect(partRes.statusCode, 200);
    final partList = (partRes.data!['value'] as List);
    print('Part records returned: ${partList.length}');
    for (final item in partList.take(3)) {
      print('  -> Contract: ${item['Contract']}, PartNo: ${item['PartNo']}');
      expect(item['Contract'], '2WFCC');
    }

    final unitQueryUrl = '${ApiConfig.instance.projectionBaseUrl}/MorfinApiHandling.svc/Reference_IsoUnit?\$top=3';
    print('Testing Unit Query: $unitQueryUrl');
    final unitRes = await dio.get<Map<String, dynamic>>(unitQueryUrl);
    expect(unitRes.statusCode, 200);
    print('Unit records returned: ${(unitRes.data!['value'] as List).length}');

    print('================ ALL TESTS PASSED SUCCESSFULLY! ================');
  });

  test('Simulate End-to-End SDUI Form and Line Item LOV Filter Flow', () async {
    print('\n================ SIMULATING END-TO-END SDUI NESTED FORM FLOW ================');

    // 1. Simulasikan Form Header: Pengguna memilih Header Contract
    final headerValues = <String, dynamic>{
      'Contract': '2WFCC',
      'Requisitioner': '*',
      'Description': 'Test PR Mobile',
    };

    // 2. Simulasikan Auto-Cascade SDUI murni (tanpa hardcode nama field)
    // Ketika dialog line item dibuka untuk field 'ReqLines' (structure PrLineInput)
    final lineFieldDefinitions = [
      'Contract',
      'PartNo',
      'Description',
      'Quantity',
      'UnitMeasure',
      'Price',
      'CurrencyCode',
    ];

    final lineDraft = <String, dynamic>{};
    for (final fieldKey in lineFieldDefinitions) {
      // Generic match: jika ada di headerValues, cascade nilainya
      final matchHeader = headerValues.entries.firstWhere(
        (e) => e.key.toLowerCase() == fieldKey.toLowerCase() && e.value != null && e.value.toString().isNotEmpty,
        orElse: () => const MapEntry('', null),
      );
      if (matchHeader.key.isNotEmpty) {
        lineDraft[fieldKey] = matchHeader.value;
      }
    }

    print('1. Header Values: $headerValues');
    print('2. Cascaded Line Draft: $lineDraft');
    expect(lineDraft['Contract'], '2WFCC');

    // 3. Gabungkan Context untuk LOV (parentValues + lineDraft)
    final combinedContext = <String, dynamic>{
      ...headerValues,
      ...lineDraft,
    };

    // 4. Buka LOV PartNo: Baca Entity Keys dari OData $metadata
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${ApiConfig.instance.accessToken}';
    (dio.httpClientAdapter as dynamic).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final metaUrl = '${ApiConfig.instance.projectionBaseUrl}/MorfinApiHandling.svc/\$metadata';
    final response = await dio.get<String>(metaUrl);
    final xml = response.data!;
    final partKeys = extractKeyFields(xml, 'PurchasePartLov');

    // 5. Build dynamic filter secara generik
    final dynamicFilter = buildMetadataDrivenFilter(
      keyFields: partKeys,
      targetFieldKey: 'PartNo',
      availableValues: combinedContext,
    );

    print('3. Target LOV Field: PartNo');
    print('4. OData Entity Keys: $partKeys');
    print('5. Resolved Dynamic Filter: $dynamicFilter');
    expect(dynamicFilter, "Contract eq '2WFCC'");

    // 6. Verifikasi eksekusi query OData ke IFS Cloud
    final url = '${ApiConfig.instance.projectionBaseUrl}/MorfinApiHandling.svc/Reference_PurchasePartLov?\$filter=$dynamicFilter&\$top=5';
    final res = await dio.get<Map<String, dynamic>>(url);
    expect(res.statusCode, 200);

    final items = res.data!['value'] as List;
    print('6. IFS Response: ${items.length} records returned');
    expect(items.isNotEmpty, true);
    for (final item in items) {
      expect(item['Contract'], '2WFCC');
    }
    print('================ E2E SDUI TEST PASSED SUCCESSFULLY! ================\n');
  });
}

