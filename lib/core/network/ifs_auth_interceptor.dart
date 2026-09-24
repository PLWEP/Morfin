import 'package:dio/dio.dart';
import 'ifs_api_client.dart';
import 'ifs_api_config.dart';

class IfsAuthInterceptor extends Interceptor {
  final IfsApiConfig _config = IfsApiConfig.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    if (options.contentType == null && !options.headers.containsKey('Content-Type')) {
      options.headers['Content-Type'] = 'application/json;charset=utf-8';
    }

    if (_config.isAuthenticated) {
      options.headers['Authorization'] = 'Bearer ${_config.accessToken}';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && _config.refreshToken != null) {
      final success = await IfsApiClient.instance.refreshTokenOAuth();
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
