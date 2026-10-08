import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/network/activity_log_interceptor.dart';
import 'package:morfin/core/services/activity_log_service.dart';

class _MockErrorHandler extends ErrorInterceptorHandler {
  DioException? passedError;

  @override
  void next(DioException err) {
    passedError = err;
  }
}

void main() {
  group('ActivityLogInterceptor Unit Tests', () {
    late ActivityLogInterceptor interceptor;

    setUp(() {
      interceptor = ActivityLogInterceptor();
      ActivityLogService.instance.clear();
    });

    test('onRequest and onResponse flow records network log entry', () {
      final req = RequestOptions(path: '/PurchaseOrderSet', method: 'GET');
      final reqHandler = RequestInterceptorHandler();
      interceptor.onRequest(req, reqHandler);

      final resp = Response(
        requestOptions: req,
        statusCode: 200,
      );
      final respHandler = ResponseInterceptorHandler();
      interceptor.onResponse(resp, respHandler);

      expect(ActivityLogService.instance.logs.length, 1);
      final entry = ActivityLogService.instance.logs.first;
      expect(entry.level, LogLevel.network);
      expect(entry.message.contains('GET /PurchaseOrderSet -> 200'), true);
    });

    test('onError flow records error log entry', () {
      final req = RequestOptions(path: '/FailEndpoint', method: 'POST');
      final reqHandler = RequestInterceptorHandler();
      interceptor.onRequest(req, reqHandler);

      final err = DioException(
        requestOptions: req,
        response: Response(requestOptions: req, statusCode: 500),
        message: 'Server Error',
      );
      final errHandler = _MockErrorHandler();
      interceptor.onError(err, errHandler);

      expect(errHandler.passedError, err);
      expect(ActivityLogService.instance.logs.length, 1);
      final entry = ActivityLogService.instance.logs.first;
      expect(entry.level, LogLevel.error);
      expect(entry.message.contains('POST /FailEndpoint -> 500'), true);
      expect(entry.details, 'Server Error');
    });
  });
}
