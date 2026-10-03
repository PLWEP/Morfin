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

  test('Setup MobileNavMenu items via MobileNavMenuHandling.svc', () async {
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
    expect(loginOk, isTrue);

    final existing = await ApiClient.instance.getCollection(
      'MobileNavMenuHandling',
      'MobileNavMenuSet',
    );
    print('Current menus count: ${existing.length}');
    for (final m in existing) {
      print('ID: ${m['NodeId']}, Parent: ${m['ParentId']}, Label: ${m['Label']}, ActionType: ${m['ActionType']}');
    }

    final hasList = existing.any((m) => m['Label'] == 'Released PR Lines' || m['NodeId'] == 15);
    if (!hasList) {
      print('Inserting Node 15 (Released PR Lines)...');
      final resList = await ApiClient.instance.postRecord(
        'MobileNavMenuHandling',
        'MobileNavMenuSet',
        {
          'ParentId': 10,
          'Label': 'Released PR Lines',
          'ActionType': 'List',
          'Icon': 'list_alt_rounded',
          'TargetProjection': 'MorfinApiHandling',
          'TargetEndpoint': 'ReleasedPurchaseReqLineSet',
          'SortOrder': 2,
          'Active': true,
          'ColumnConfig': 'TITLE=PartNo^SUBTITLE=Description^COL1=RequisitionNo^COL2=Contract^COL3=OriginalQty^',
        },
      );
      print('Created Node 15: ${resList['NodeId']}');
    } else {
      print('Node 15 already exists');
    }

    // Refresh existing list to get exact NodeId of Released PR Lines
    final refreshed = await ApiClient.instance.getCollection(
      'MobileNavMenuHandling',
      'MobileNavMenuSet',
    );
    final prLineNode = refreshed.firstWhere((m) => m['Label'] == 'Released PR Lines');
    final prLineNodeId = prLineNode['NodeId'];
    print('prLineNodeId: $prLineNodeId');

    final hasAction = refreshed.any((m) => m['Label'] == 'Convert to PO');
    if (!hasAction) {
      print('Inserting Action Convert to PO under Node $prLineNodeId...');
      final resAction = await ApiClient.instance.postRecord(
        'MobileNavMenuHandling',
        'MobileNavMenuSet',
        {
          'ParentId': prLineNodeId,
          'Label': 'Convert to PO',
          'ActionType': 'Form',
          'Icon': 'transform_rounded',
          'TargetProjection': 'MorfinApiHandling',
          'TargetEndpoint': 'ConvertPrLineToOrder',
          'SortOrder': 1,
          'Active': true,
        },
      );
      print('Created Action: ${resAction['NodeId']}');
    } else {
      print('Convert to PO action already exists');
    }

    // Verify GetMobileMenu
    final menuRes = await ApiClient.instance.callFunction(
      'MobileNavMenuHandling',
      "GetMobileMenu(ScopeId='global',DeviceType='phone')",
    );
    final menuItems = menuRes['value'] as List<dynamic>? ?? [];
    print('=== GET MOBILE MENU ITEMS (${menuItems.length}) ===');
    for (final item in menuItems) {
      print('NodeId: ${item['NodeId']}, ParentId: ${item['ParentId']}, Label: ${item['Label']}, ActionType: ${item['ActionType']}, TargetUrl: ${item['TargetUrl']}, ChildCount: ${item['ChildCount']}');
    }
  });
}
