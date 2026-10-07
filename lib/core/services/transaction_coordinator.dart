import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum TransactionFailureType {
  connectionTimeout,
  receiveTimeout,
  badResponse,
  unknown,
}

class TransactionException implements Exception {
  final TransactionFailureType type;
  final String message;
  final bool isAmbiguousTimeout;

  const TransactionException({
    required this.type,
    required this.message,
    this.isAmbiguousTimeout = false,
  });

  @override
  String toString() => message;
}

class TransactionCoordinator {
  static final TransactionCoordinator instance = TransactionCoordinator();

  final Map<String, Future<dynamic>> _activeSingleFlights = {};
  final Map<String, Completer<void>> _queueLocks = {};

  String generateFingerprint(String projection, String actionName, Map<String, dynamic> parameters) {
    final sortedKeys = parameters.keys.toList()..sort();
    final sortedMap = {for (var k in sortedKeys) k: parameters[k]};
    return '$projection/$actionName:${jsonEncode(sortedMap)}';
  }

  bool isBusy(String key) => _activeSingleFlights.containsKey(key);

  Future<T> enqueue<T>({
    required String projection,
    required String actionName,
    required Map<String, dynamic> parameters,
    required Future<T> Function() action,
    bool singleFlight = true,
  }) async {
    final fingerprint = generateFingerprint(projection, actionName, parameters);

    if (singleFlight && _activeSingleFlights.containsKey(fingerprint)) {
      debugPrint('[TransactionCoordinator] Deduplicated in-flight action: $fingerprint');
      return await (_activeSingleFlights[fingerprint] as Future<T>);
    }

    final queueKey = '$projection/$actionName';
    while (_queueLocks.containsKey(queueKey)) {
      await _queueLocks[queueKey]?.future;
    }
    final lockCompleter = Completer<void>();
    _queueLocks[queueKey] = lockCompleter;

    final actionFuture = _executeGuarded(action, fingerprint);
    if (singleFlight) {
      _activeSingleFlights[fingerprint] = actionFuture;
    }

    try {
      return await actionFuture;
    } finally {
      if (singleFlight) {
        _activeSingleFlights.remove(fingerprint);
      }
      _queueLocks.remove(queueKey);
      if (!lockCompleter.isCompleted) {
        lockCompleter.complete();
      }
    }
  }

  Future<T> _executeGuarded<T>(Future<T> Function() action, String fingerprint) async {
    try {
      return await action();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        throw TransactionException(
          type: TransactionFailureType.receiveTimeout,
          isAmbiguousTimeout: true,
          message: 'Server did not respond in time. The transaction may have succeeded in ERP. Please refresh before retrying.',
        );
      } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.connectionError) {
        throw TransactionException(
          type: TransactionFailureType.connectionTimeout,
          isAmbiguousTimeout: false,
          message: 'Connection failed. Please check network and try again.',
        );
      } else {
        rethrow;
      }
    }
  }
}
