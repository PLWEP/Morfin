import 'package:dio/dio.dart';

class PayloadUtils {
  const PayloadUtils._();

  static Map<String, dynamic> sanitize(Map<String, dynamic> raw) {
    const internalKeys = {'luname', 'objid', 'objversion', 'rowkey', 'rowstate', 'rowtype'};
    final cleaned = <String, dynamic>{};
    for (final entry in raw.entries) {
      final k = entry.key;
      if (!k.startsWith('@') && !internalKeys.contains(k.toLowerCase())) {
        cleaned[k] = entry.value;
      }
    }
    return cleaned;
  }

  static String extractErrorMessage(dynamic error) {
    if (error is DioException && error.response?.data is Map) {
      final map = error.response!.data as Map;
      final err = map['error'];
      if (err is Map && err['message'] != null) {
        return err['message'].toString();
      }
    }
    return error.toString();
  }
}
