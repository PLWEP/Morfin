import '../network/api_config.dart';

enum LogLevel { info, warning, error, network }

class ActivityLogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? details;

  const ActivityLogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.details,
  });
}

class ActivityLogService {
  static final ActivityLogService instance = ActivityLogService._();
  ActivityLogService._();

  final List<ActivityLogEntry> _logs = [];
  static const int _maxLogs = 100;

  List<ActivityLogEntry> get logs => List.unmodifiable(_logs);

  void log(String message, {LogLevel level = LogLevel.info, String? details}) {
    if (_logs.length >= _maxLogs) {
      _logs.removeAt(0);
    }
    _logs.add(
      ActivityLogEntry(
        timestamp: DateTime.now(),
        level: level,
        message: message,
        details: details,
      ),
    );
  }

  void logNetwork({
    required String method,
    required String url,
    required int? statusCode,
    Duration? duration,
    String? error,
  }) {
    final statusStr = statusCode != null ? '$statusCode' : 'FAIL';
    final durStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    final msg = '$method $url -> $statusStr$durStr';
    log(
      msg,
      level: (statusCode != null && statusCode < 400) ? LogLevel.network : LogLevel.error,
      details: error,
    );
  }

  String exportAsText() {
    final buffer = StringBuffer();
    buffer.writeln('=== MORFIN ACTIVITY LOG EXPORT ===');
    buffer.writeln('Export Time: ${DateTime.now().toIso8601String()}');
    buffer.writeln('Server URL: ${ApiConfig.instance.activeServer.baseUrl}');
    buffer.writeln('Realm: ${ApiConfig.instance.activeServer.realm}');
    buffer.writeln('Mode: Always-Online');
    buffer.writeln('Total Entries: ${_logs.length}');
    buffer.writeln('-----------------------------------');
    if (_logs.isEmpty) {
      buffer.writeln('No activity records captured.');
    } else {
      for (final entry in _logs) {
        final time = entry.timestamp.toIso8601String();
        final level = entry.level.name.toUpperCase().padRight(7);
        buffer.writeln('[$time] [$level] ${entry.message}');
        if (entry.details != null && entry.details!.isNotEmpty) {
          buffer.writeln('  Details: ${entry.details}');
        }
      }
    }
    buffer.writeln('===================================');
    return buffer.toString();
  }

  void clear() => _logs.clear();
}
