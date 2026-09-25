import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_config.dart';

class AuthInterceptor extends Interceptor {
  final ApiConfig _config = ApiConfig.instance;

  static const Map<String, String> _internalHosts = {
    'isidemocloud.ifssi.co.id': '10.53.25.132',
    'isidemobtg.ifssi.co.id': '10.53.25.51',
    'csd-cloud.ifssi.co.id': '10.53.25.148',
    'app-demo.ifssi.co.id': '10.53.25.148',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    if (options.contentType == null && !options.headers.containsKey('Content-Type')) {
      options.headers['Content-Type'] = 'application/json;charset=utf-8';
    }

    final uri = options.uri;
    final mappedIp = _internalHosts[uri.host];
    if (mappedIp != null) {
      options.headers['Host'] = uri.host;
      options.path = uri.replace(host: mappedIp).toString();
    }

    if (_config.isAuthenticated) {
      options.headers['Authorization'] = 'Bearer ${_config.accessToken}';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && _config.refreshToken != null) {
      final success = await ApiClient.instance.refreshTokenOAuth();
      if (success) {
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${_config.accessToken}';
        try {
          final res = await Dio().fetch(opts);
          return handler.resolve(res);
        } catch (_) {}
      }
      _config.clearTokens();
    } else if (err.response?.statusCode == 401) {
      _config.clearTokens();
    }
    return handler.next(err);
  }
}
