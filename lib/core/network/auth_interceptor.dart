import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_config.dart';

class AuthInterceptor extends Interceptor {
  final ApiConfig _config = ApiConfig.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.headers.containsKey('Accept')) {
      options.headers['Accept'] = 'application/json';
    }
    if (options.contentType == null && !options.headers.containsKey('Content-Type')) {
      options.headers['Content-Type'] = 'application/json;charset=utf-8';
    }

    final customHost = _config.activeServer.customHost;
    if (customHost.isNotEmpty) {
      options.headers['Host'] = customHost;
    }

    if (_config.isAuthenticated) {
      options.headers['Authorization'] = 'Bearer ${_config.accessToken}';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    // Ignore token endpoint itself to avoid recursion
    final isTokenEndpoint = err.requestOptions.path.contains('token') ||
        err.requestOptions.path.contains('auth');

    if (is401 && !isTokenEndpoint) {
      if (_config.refreshToken != null && _config.refreshToken!.isNotEmpty) {
        final success = await ApiClient.instance.refreshTokenOAuth();
        if (success) {
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${_config.accessToken}';
          try {
            final res = await ApiClient.instance.fetchWithSelfSigned(opts);
            return handler.resolve(res);
          } on DioException catch (retryErr) {
            if (retryErr.response?.statusCode == 401) {
              _config.clearTokens();
              ApiClient.instance.notifySessionExpired();
            }
            return handler.next(retryErr);
          } catch (_) {}
        }
      }

      _config.clearTokens();
      ApiClient.instance.notifySessionExpired();
    }
    return handler.next(err);
  }
}
