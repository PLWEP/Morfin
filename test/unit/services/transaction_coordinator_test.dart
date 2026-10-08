import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/services/transaction_coordinator.dart';

void main() {
  group('TransactionCoordinator Unit Tests', () {
    final coordinator = TransactionCoordinator.instance;

    test('generateFingerprint produces identical hash regardless of parameter map key order', () {
      final fp1 = coordinator.generateFingerprint('PurchaseOrderHandling', 'ReleaseOrder', {
        'OrderNo': '1001',
        'Company': '10',
        'Notify': true,
      });

      final fp2 = coordinator.generateFingerprint('PurchaseOrderHandling', 'ReleaseOrder', {
        'Notify': true,
        'OrderNo': '1001',
        'Company': '10',
      });

      expect(fp1, fp2);
      expect(fp1, 'PurchaseOrderHandling/ReleaseOrder:{"Company":"10","Notify":true,"OrderNo":"1001"}');
    });

    test('enqueue deduplicates concurrent in-flight requests when singleFlight is true', () async {
      int executionCount = 0;
      final completer = Completer<String>();

      final f1 = coordinator.enqueue(
        projection: 'PartHandling',
        actionName: 'RecalculateStock',
        parameters: {'PartNo': 'P100'},
        action: () async {
          executionCount++;
          return completer.future;
        },
      );

      final f2 = coordinator.enqueue(
        projection: 'PartHandling',
        actionName: 'RecalculateStock',
        parameters: {'PartNo': 'P100'},
        action: () async {
          executionCount++;
          return 'second';
        },
      );

      completer.complete('first_success');
      final results = await Future.wait([f1, f2]);

      expect(results[0], 'first_success');
      expect(results[1], 'first_success');
      expect(executionCount, 1);
    });

    test('enqueue converts DioException receiveTimeout to ambiguous TransactionException', () async {
      final dioTimeout = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.receiveTimeout,
      );

      expect(
        () => coordinator.enqueue(
          projection: 'TestProj',
          actionName: 'TestAction',
          parameters: {'id': 1},
          action: () async => throw dioTimeout,
        ),
        throwsA(
          isA<TransactionException>()
              .having((e) => e.type, 'type', TransactionFailureType.receiveTimeout)
              .having((e) => e.isAmbiguousTimeout, 'isAmbiguousTimeout', true),
        ),
      );
    });

    test('enqueue converts DioException connectionTimeout to non-ambiguous TransactionException', () async {
      final dioConnErr = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        () => coordinator.enqueue(
          projection: 'TestProj',
          actionName: 'TestAction2',
          parameters: {'id': 2},
          action: () async => throw dioConnErr,
        ),
        throwsA(
          isA<TransactionException>()
              .having((e) => e.type, 'type', TransactionFailureType.connectionTimeout)
              .having((e) => e.isAmbiguousTimeout, 'isAmbiguousTimeout', false),
        ),
      );
    });
  });
}
