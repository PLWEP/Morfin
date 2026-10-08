import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/api_config.dart';
import 'package:morfin/core/network/auth_interceptor.dart';
import 'package:morfin/features/login/models/server_config.dart';

void main() {
  group('AuthInterceptor Unit Tests', () {
    late AuthInterceptor interceptor;

    setUp(() {
      interceptor = AuthInterceptor();
      ApiConfig.instance.clearTokens();
      ApiConfig.instance.setServer(const ServerConfig(
        id: 'srv-test',
        name: 'Test Server',
        baseUrl: 'https://test.ifs.cloud',
        realm: 'test',
        clientId: 'morfin',
        clientSecret: '',
        customHost: 'custom.proxy.internal',
      ));
    });

    test('onRequest injects default Accept, Content-Type, Host and Bearer tokens', () {
      ApiConfig.instance.setTokens(access: 'token_abc123');

      final req = RequestOptions(path: '/PurchaseOrderSet');
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(req, handler);

      expect(req.headers['Accept'], 'application/json');
      expect(req.headers['Content-Type'], 'application/json;charset=utf-8');
      expect(req.headers['Host'], 'custom.proxy.internal');
      expect(req.headers['Authorization'], 'Bearer token_abc123');
    });

    test('onRequest preserves existing Accept or Content-Type headers', () {
      final req = RequestOptions(
        path: '/ExportFile',
        headers: {
          'Accept': 'application/pdf',
          'Content-Type': 'multipart/form-data',
        },
      );
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(req, handler);

      expect(req.headers['Accept'], 'application/pdf');
      expect(req.headers['Content-Type'], 'multipart/form-data');
    });
  });
}
