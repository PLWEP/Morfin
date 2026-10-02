import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/data_query.dart';
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

  test('Verify Requisition 1574 in IFS Database via OData Endpoint', () async {
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
    expect(loginOk, isTrue, reason: 'Login must succeed');

    final header = await ApiClient.instance.getEntity(
      'PurchaseRequisitionHandling',
      'PurchaseRequisitionSet',
      "RequisitionNo='1574'",
    );
    print('=== IFS DB PR HEADER ===');
    print('RequisitionNo: ${header['RequisitionNo']}');
    print('Contract:      ${header['Contract']}');
    print('Requisitioner: ${header['RequisitionerCode']}');
    print('Objstate:      ${header['Objstate']}');
    expect(header['RequisitionNo'], equals('1574'));
    expect(header['Contract'], equals('2WFCC'));

    final linesRes = await ApiClient.instance.getEntitySet(
      'PurchaseRequisitionHandling',
      'PurchaseReqLinePartSet',
      query: DataQuery(filter: "RequisitionNo eq '1574'"),
    );
    print('=== IFS DB PR LINES (${linesRes.length} items) ===');
    for (final line in linesRes) {
      print('LineNo: ${line['LineNo']}, ReleaseNo: ${line['ReleaseNo']}, PartNo: ${line['PartNo']}, Qty: ${line['OriginalQty']}, State: ${line['Objstate']}');
    }
    expect(linesRes.isNotEmpty, isTrue);
  });
}
