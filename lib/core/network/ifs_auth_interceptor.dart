import 'package:dio/dio.dart';
import 'ifs_api_config.dart';

class IfsAuthInterceptor extends Interceptor {
  final IfsApiConfig _config = IfsApiConfig.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json;charset=utf-8';

    if (_config.isAuthenticated) {
      options.headers['Authorization'] = 'Bearer ${_config.accessToken}';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _config.clearTokens();
    }
    return handler.next(err);
  }
}
