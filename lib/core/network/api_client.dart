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

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(AuthInterceptor());
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

  Future<List<Map<String, dynamic>>> getEntitySet(
    String projection,
    String entitySet, {
    ODataQuery? query,
  }) async {
    final url = '${_config.projectionBaseUrl}/$projection.svc/$entitySet';
    final response = await _dio.get<Map<String, dynamic>>(
      url,
      queryParameters: query?.toQueryParams(),
    );

    final data = response.data;
    if (data == null) return [];

    final value = data['value'];
    if (value is List) {
      return value.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getEntity(
    String projection,
    String entitySet,
    String key,
  ) async {
    final url = '${_config.projectionBaseUrl}/$projection.svc/$entitySet($key)';
    final response = await _dio.get<Map<String, dynamic>>(url);
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> postEntity(
    String projection,
    String entitySet,
    Map<String, dynamic> data,
  ) async {
    final url = '${_config.projectionBaseUrl}/$projection.svc/$entitySet';
    final response = await _dio.post<Map<String, dynamic>>(url, data: data);
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> patchEntity(
    String projection,
    String entitySet,
    String key,
    Map<String, dynamic> data,
  ) async {
    final url = '${_config.projectionBaseUrl}/$projection.svc/$entitySet($key)';
    final response = await _dio.patch<Map<String, dynamic>>(url, data: data);
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> callAction(
    String projection,
    String actionName,
    Map<String, dynamic> parameters,
  ) async {
    final url = '${_config.projectionBaseUrl}/$projection.svc/$actionName';
    final response = await _dio.post<Map<String, dynamic>>(url, data: parameters);
    return response.data ?? {};
  }

  Future<bool> authenticateOAuth({
    required String username,
    required String password,
    String scope = 'openid',
    String? responseType = 'id_token',
  }) async {
    final tokenUrl = _config.tokenEndpoint;
    try {
      final payload = <String, dynamic>{
        'grant_type': 'password',
        'client_id': _config.activeServer.clientId,
        'client_secret': _config.activeServer.clientSecret,
        'username': username,
        'password': password,
        if (scope.isNotEmpty) 'scope': scope,
        if (responseType != null && responseType.isNotEmpty) 'response_type': responseType,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        tokenUrl,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data;
      if (data != null && data['access_token'] != null) {
        _config.setTokens(
          access: data['access_token'] as String,
          refresh: data['refresh_token'] as String?,
          expiresInSeconds: data['expires_in'] as int?,
        );
        return true;
      }
      return false;
    } catch (e) {
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
        'client_secret': _config.activeServer.clientSecret,
        'refresh_token': refresh,
        if (scope.isNotEmpty) 'scope': scope,
        if (responseType != null && responseType.isNotEmpty) 'response_type': responseType,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        _config.tokenEndpoint,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data;
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
