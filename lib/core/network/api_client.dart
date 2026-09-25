import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'api_config.dart';
import 'auth_interceptor.dart';
import 'odata_query.dart';

class ApiClient {
  static final ApiClient instance = ApiClient._();

  late final Dio _dio;
  final ApiConfig _config = ApiConfig.instance;
  String? lastAuthError;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(AuthInterceptor());
    enableSelfSignedCertificates();
  }

  void enableSelfSignedCertificates() {
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
  }

  void logout() => _config.clearTokens();

  Future<List<Map<String, dynamic>>> getEntitySet(
    String projection,
    String entitySet, {
    ODataQuery? query,
  }) async {
    final url = '${_config.projectionBaseUrl}/$projection.svc/$entitySet';
    final res = await _dio.get<Map<String, dynamic>>(url, queryParameters: query?.toQueryParams());
    final val = res.data?['value'];
    return (val is List) ? val.map((i) => Map<String, dynamic>.from(i as Map)).toList() : [];
  }

  Future<Map<String, dynamic>> getEntity(String proj, String entitySet, String key) async =>
      (await _dio.get<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$entitySet($key)')).data ?? {};

  Future<Map<String, dynamic>> postEntity(String proj, String entitySet, Map<String, dynamic> data) async =>
      (await _dio.post<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$entitySet', data: data)).data ?? {};

  Future<Map<String, dynamic>> patchEntity(String proj, String entitySet, String key, Map<String, dynamic> data) async =>
      (await _dio.patch<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$entitySet($key)', data: data)).data ?? {};

  Future<Map<String, dynamic>> callAction(String proj, String actionName, Map<String, dynamic> params) async =>
      (await _dio.post<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$actionName', data: params)).data ?? {};

  Future<Map<String, dynamic>> callFunction(String proj, String funcName, {Map<String, dynamic>? query}) async =>
      (await _dio.get<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$funcName', queryParameters: query)).data ?? {};

  Future<Map<String, dynamic>?> getCurrentUserInformation() async {
    try {
      final res = await callFunction('FrameworkServices', 'GetCurrentUserInformation()');
      return res.isNotEmpty ? res : null;
    } catch (e) {
      debugPrint('ApiClient.getCurrentUserInformation error: $e');
      return null;
    }
  }

  Future<bool> authenticateOAuth({
    required String username,
    required String password,
    String scope = 'openid',
    String? responseType = 'id_token',
  }) async {
    lastAuthError = null;
    final tokenUrl = _config.tokenEndpoint;
    try {
      final payload = <String, dynamic>{
        'grant_type': 'password',
        'client_id': _config.activeServer.clientId,
        if (_config.activeServer.clientSecret.isNotEmpty)
          'client_secret': _config.activeServer.clientSecret,
        'username': username,
        'password': password,
        if (scope.isNotEmpty) 'scope': scope,
        if (responseType != null && responseType.isNotEmpty) 'response_type': responseType,
      };

      final res = await _dio.post<Map<String, dynamic>>(
        tokenUrl,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = res.data;
      if (data != null && data['access_token'] != null) {
        _config.setTokens(
          access: data['access_token'] as String,
          refresh: data['refresh_token'] as String?,
          expiresInSeconds: data['expires_in'] as int?,
        );
        return true;
      }
      lastAuthError = 'No access token received from server';
      return false;
    } on DioException catch (e) {
      final data = e.response?.data;
      final desc = data is Map ? (data['error_description'] ?? data['error']) : null;
      lastAuthError = desc?.toString() ?? e.message ?? 'Authentication request failed';
      debugPrint('ApiClient.authenticateOAuth error: $lastAuthError');
      return false;
    } catch (e) {
      lastAuthError = e.toString();
      debugPrint('ApiClient.authenticateOAuth error: $e');
      return false;
    }
  }

  Future<bool> refreshTokenOAuth({
    String grantType = 'refresh_token',
    String scope = 'openid',
    String? responseType = 'id_token',
  }) async {
    final refresh = _config.refreshToken;
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final payload = <String, dynamic>{
        'grant_type': grantType,
        'client_id': _config.activeServer.clientId,
        if (_config.activeServer.clientSecret.isNotEmpty)
          'client_secret': _config.activeServer.clientSecret,
        'refresh_token': refresh,
        if (scope.isNotEmpty) 'scope': scope,
        if (responseType != null && responseType.isNotEmpty) 'response_type': responseType,
      };

      final res = await _dio.post<Map<String, dynamic>>(
        _config.tokenEndpoint,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = res.data;
      if (data != null && data['access_token'] != null) {
        _config.setTokens(
          access: data['access_token'] as String,
          refresh: data['refresh_token'] as String? ?? refresh,
          expiresInSeconds: data['expires_in'] as int?,
        );
        return true;
      }
    } catch (e) {
      debugPrint('ApiClient.refreshTokenOAuth error: $e');
    }
    _config.clearTokens();
    return false;
  }
}
