import 'package:dio/dio.dart';
import '../services/activity_log_service.dart';

class ActivityLogInterceptor extends Interceptor {
  final Map<int, Stopwatch> _timers = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _timers[options.hashCode] = Stopwatch()..start();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final timer = _timers.remove(response.requestOptions.hashCode);
    timer?.stop();
    ActivityLogService.instance.logNetwork(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.path,
      statusCode: response.statusCode,
      duration: timer?.elapsed,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final timer = _timers.remove(err.requestOptions.hashCode);
    timer?.stop();
    ActivityLogService.instance.logNetwork(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.path,
      statusCode: err.response?.statusCode,
      duration: timer?.elapsed,
      error: err.message,
    );
    super.onError(err, handler);
  }
}
