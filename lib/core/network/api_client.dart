import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'activity_log_interceptor.dart';
import 'api_config.dart';
import 'auth_interceptor.dart';
import 'data_query.dart';

class ApiClient {
  static final ApiClient instance = ApiClient._();
  late final Dio _dio;
  final ApiConfig _config = ApiConfig.instance;
  String? lastAuthError;

  ApiClient._() {
    _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 15), responseType: ResponseType.json));
    _dio.interceptors.addAll([AuthInterceptor(), ActivityLogInterceptor()]);
    enableSelfSignedCertificates();
  }

  void enableSelfSignedCertificates() {
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () => HttpClient()..badCertificateCallback = (cert, host, port) => true;
    }
  }

  Dio get dio => _dio;
  final ValueNotifier<bool> onSessionExpired = ValueNotifier<bool>(false);
  bool _isRefreshing = false;

  void notifySessionExpired() { if (!onSessionExpired.value) onSessionExpired.value = true; }
  void resetSessionExpired() => onSessionExpired.value = false;
  void logout() => _config.clearTokens();
  Future<Response<T>> fetchWithSelfSigned<T>(RequestOptions opts) => _dio.fetch<T>(opts);

  Future<List<Map<String, dynamic>>> getCollection(String proj, String entitySet, {DataQuery? query}) async {
    var url = '${_config.projectionBaseUrl}/$proj.svc/$entitySet';
    if (query != null) {
      final qp = query.toQueryParams();
      if (qp.isNotEmpty) {
        final parts = qp.entries.where((e) => e.value != null).map((e) {
          final enc = Uri.encodeComponent(e.value.toString()).replaceAll('+', '%20').replaceAll('%27', "'").replaceAll('%28', '(').replaceAll('%29', ')').replaceAll('%3A', ':').replaceAll('%2C', ',');
          return '${e.key}=$enc';
        }).toList();
        url += '?${parts.join('&')}';
      }
    }
    final res = await _dio.get<Map<String, dynamic>>(url);
    final val = res.data?['value'];
    return (val is List) ? val.map((i) => Map<String, dynamic>.from(i as Map)).toList() : [];
  }

  Future<Map<String, dynamic>> getRecord(String proj, String entitySet, String key) async => (await _dio.get<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$entitySet($key)')).data ?? {};
  Future<Map<String, dynamic>> postRecord(String proj, String entitySet, Map<String, dynamic> data) async => (await _dio.post<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$entitySet', data: data)).data ?? {};
  Future<Map<String, dynamic>> patchRecord(String proj, String entitySet, String key, Map<String, dynamic> data) async => (await _dio.patch<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$entitySet($key)', data: data)).data ?? {};
  Future<Map<String, dynamic>> callAction(String proj, String actionName, Map<String, dynamic> params) async => (await _dio.post<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$actionName', data: params)).data ?? {};
  Future<Map<String, dynamic>> callFunction(String proj, String funcName, {Map<String, dynamic>? query}) async => (await _dio.get<Map<String, dynamic>>('${_config.projectionBaseUrl}/$proj.svc/$funcName', queryParameters: query)).data ?? {};

    Future<int> getCount(String proj, String entitySet, {String? filter}) async {
    var url = '${_config.projectionBaseUrl}/$proj.svc/$entitySet/\$count';
    if (filter != null && filter.isNotEmpty) {
      final enc = Uri.encodeComponent(filter).replaceAll('+', '%20').replaceAll('%27', "'").replaceAll('%28', '(').replaceAll('%29', ')').replaceAll('%3A', ':').replaceAll('%2C', ',');
      url += '?\$filter=$enc';
    }
    final res = await _dio.get<String>(url, options: Options(responseType: ResponseType.plain));
    return int.tryParse(res.data?.trim() ?? '') ?? 0;
  }

  Future<String?> getRawXml(String url) async {
    try {
      return (await _dio.get<String>(url, options: Options(responseType: ResponseType.plain, headers: {'Accept': 'application/xml, text/xml, */*'}))).data;
    } catch (e) {
      debugPrint('ApiClient.getRawXml error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserInformation() async {
    try {
      final res = await callFunction('FrameworkServices', 'GetCurrentUserInformation()');
      return res.isNotEmpty ? res : null;
    } catch (e) {
      debugPrint('ApiClient.getCurrentUserInformation error: $e');
      return null;
    }
  }

  Future<bool> authenticateOAuth({required String username, required String password, String scope = 'openid', String? responseType}) async {
    lastAuthError = null;
    try {
      final payload = <String, dynamic>{
        'grant_type': 'password',
        'client_id': _config.activeServer.clientId,
        if (_config.activeServer.clientSecret.isNotEmpty) 'client_secret': _config.activeServer.clientSecret,
        'username': username,
        'password': password,
        if (scope.isNotEmpty) 'scope': scope,
        if (responseType != null && responseType.isNotEmpty) 'response_type': responseType,
      };
      final res = await _dio.post<Map<String, dynamic>>(_config.tokenEndpoint, data: payload, options: Options(contentType: Headers.formUrlEncodedContentType));
      final data = res.data;
      if (data != null && data['access_token'] != null) {
        _config.setTokens(access: data['access_token'] as String, refresh: data['refresh_token'] as String?, expiresInSeconds: data['expires_in'] as int?);
        return true;
      }
      lastAuthError = 'No access token received from server';
      return false;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      String? desc;
      if (data is Map) {
        desc = (data['error_description'] ?? data['error'])?.toString();
      } else if (data is String) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is Map) {
            desc = (decoded['error_description'] ?? decoded['error'])?.toString();
          }
        } catch (_) {
          if (!data.contains('<html') && data.length < 200) {
            desc = data.trim();
          }
        }
      }
      if (desc != null && desc.isNotEmpty) {
        lastAuthError = statusCode != null ? '[$statusCode] $desc' : desc;
      } else {
        lastAuthError = statusCode != null ? 'HTTP $statusCode: ${e.message}' : (e.message ?? 'Authentication request failed');
      }
      debugPrint('ApiClient.authenticateOAuth error: $lastAuthError');
      return false;
    } catch (e) {
      lastAuthError = e.toString();
      debugPrint('ApiClient.authenticateOAuth error: $e');
      return false;
    }
  }

  Future<bool> refreshTokenOAuth({String grantType = 'refresh_token', String scope = 'openid', String? responseType}) async {
    if (_isRefreshing) {
      int attempts = 0;
      while (_isRefreshing && attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }
      return _config.isAuthenticated;
    }
    final refresh = _config.refreshToken;
    if (refresh == null || refresh.isEmpty) return false;
    _isRefreshing = true;
    try {
      final payload = <String, dynamic>{
        'grant_type': grantType, 'client_id': _config.activeServer.clientId,
        if (_config.activeServer.clientSecret.isNotEmpty) 'client_secret': _config.activeServer.clientSecret,
        'refresh_token': refresh,
        if (scope.isNotEmpty) 'scope': scope,
        if (responseType != null && responseType.isNotEmpty) 'response_type': responseType,
      };
      final res = await _dio.post<Map<String, dynamic>>(_config.tokenEndpoint, data: payload, options: Options(contentType: Headers.formUrlEncodedContentType));
      final data = res.data;
      if (data != null && data['access_token'] != null) {
        _config.setTokens(access: data['access_token'] as String, refresh: data['refresh_token'] as String? ?? refresh, expiresInSeconds: data['expires_in'] as int?);
        return true;
      }
    } catch (e) {
      debugPrint('ApiClient.refreshTokenOAuth error: $e');
    } finally {
      _isRefreshing = false;
    }
    _config.clearTokens();
    return false;
  }
}
