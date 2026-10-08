import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/api_client.dart';
import 'package:morfin/core/network/api_config.dart';
import 'package:morfin/core/services/navigator_service.dart';
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

  test('Diagnose API Menu Nodes & Navigator Transformation', () async {
    // Check MobileAppDesignHandling vs MobileNavMenu vs MobileAppNavigator
    try {
      final res1 = await ApiClient.instance.callFunction(
        'MobileAppDesignHandling',
        "GetMobileMenu(ScopeId='global',DeviceType='phone')",
      );
      print('MobileAppDesignHandling result: ${res1.runtimeType} -> ${res1['value']?.length} items');
      if (res1['value'] is List) {
        for (var i = 0; i < (res1['value'] as List).length; i++) {
          print('Item $i: ${res1['value'][i]}');
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('MobileAppDesignHandling failed: $e');
    }

    // Check ActionParamSet
    // Check ActionParamSet
    try {
      final res = await ApiClient.instance.getCollection('MobileAppDesignHandling', 'ActionParamSet');
      print('ActionParamSet count: ${res.length}');
      if (res.isNotEmpty) {
        print('ActionParamSet item 0: ${res[0]}');
      }
    } catch (e) {
      print('ActionParamSet failed: $e');
    }

    // 2. Transform into MenuMetadata via NavigatorService
    final menu = await NavigatorService.instance.fetchMenuMetadata(forceRefresh: true);
    // ignore: avoid_print
    print('MENU GROUPS: ${menu.groups.length}');
    for (final g in menu.groups) {
      // ignore: avoid_print
      print('GROUP: id=${g.id}, title="${g.title}", items=${g.items.length}');
      for (final it in g.items) {
        // ignore: avoid_print
        print('  ITEM: id=${it.id}, title="${it.title}", target="${it.action?.target}", params=${it.action?.params}');
        final children = NavigatorService.instance.getChildrenOfNode(it.id);
        if (children.isNotEmpty) {
          // ignore: avoid_print
          print('    CHILDREN of ${it.id} (${children.length}):');
          for (final ch in children) {
            // ignore: avoid_print
            print('      CHILD: id=${ch.id}, title="${ch.title}", target="${ch.action?.target}", params=${ch.action?.params}');
            final childActions = NavigatorService.instance.getChildActions(ch.id);
            if (childActions.isNotEmpty) {
              print('        CHILD ACTIONS of ${ch.id} (${childActions.length}): $childActions');
            }
          }
        }
      }
    }
  });
}
