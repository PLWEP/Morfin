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

  test('Test ConvertPrLineToOrder endpoint', () async {
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

    // 1. Let's fetch 1 released PR line to test with
    final prLines = await ApiClient.instance.getEntitySet(
      'MorfinApiHandling',
      'ReleasedPurchaseReqLineSet',
    );
    print('Found ${prLines.length} released PR lines');
    if (prLines.isNotEmpty) {
      final testPr = prLines.firstWhere((p) => p['RequisitionNo'].toString() == '1474', orElse: () => prLines.first);
      print('Testing with PR Line: ${testPr['RequisitionNo']} - ${testPr['LineNo']} - ${testPr['ReleaseNo']}');
      
      // Try calling with AuthorizeCode='*', OrderNo=null
      try {
        final payload1 = {
          'RequisitionNo': testPr['RequisitionNo'].toString(),
          'LineNo': testPr['LineNo'].toString(),
          'ReleaseNo': testPr['ReleaseNo'].toString(),
          'AuthorizeCode': '*',
          'OrderNo': null,
        };
        print('Testing payload1 (with OrderNo: null): $payload1');
        final res1 = await ApiClient.instance.callAction('MorfinApiHandling', 'ConvertPrLineToOrder', payload1);
        print('Result 1: $res1');
      } on DioException catch (e) {
        print('Error 1 Data: ${e.response?.data}');
      } catch (e) {
        print('Error 1: $e');
      }

      // Try calling with OrderNo omitted or empty string
      try {
        final payload2 = {
          'RequisitionNo': testPr['RequisitionNo'].toString(),
          'LineNo': testPr['LineNo'].toString(),
          'ReleaseNo': testPr['ReleaseNo'].toString(),
          'AuthorizeCode': '*',
        };
        print('Testing payload2 (omitted OrderNo): $payload2');
        final res2 = await ApiClient.instance.callAction('MorfinApiHandling', 'ConvertPrLineToOrder', payload2);
        print('Result 2: $res2');
      } on DioException catch (e) {
        print('Error 2 Data: ${e.response?.data}');
      } catch (e) {
        print('Error 2: $e');
      }
    }
  });
}
