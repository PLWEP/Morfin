import 'package:dio/dio.dart';

class PayloadUtils {
  const PayloadUtils._();

  static Map<String, dynamic> sanitize(Map<String, dynamic> raw) {
    const internalKeys = {'luname', 'objid', 'objversion', 'rowkey', 'rowstate', 'rowtype'};
    final cleaned = <String, dynamic>{};
    for (final entry in raw.entries) {
      if (!entry.key.startsWith('@') && !internalKeys.contains(entry.key.toLowerCase())) {
        cleaned[entry.key] = entry.value;
      }
    }
    return cleaned;
  }

  static Map<String, dynamic> formatActionPayload({
    required Map<String, dynamic> rawValues,
    required List<dynamic> allFieldDefs,
    Map<String, dynamic> defaultValues = const {},
  }) {
    final sanitized = sanitize(rawValues);
    final result = <String, dynamic>{};
    final fieldMap = <String, dynamic>{};
    for (final f in allFieldDefs) {
      if (f.key != null) fieldMap[f.key.toString().toLowerCase()] = f;
    }

    for (final entry in defaultValues.entries) {
      if (!entry.key.contains('.') && !sanitized.containsKey(entry.key) && !sanitized.keys.any((k) => k.toLowerCase() == entry.key.toLowerCase())) {
        sanitized[entry.key] = entry.value;
      }
    }

    final allKeys = <String>{
      ...fieldMap.keys.where((k) => !k.contains('.')),
      ...sanitized.keys.where((k) => !k.contains('.')).map((k) => k.toLowerCase()),
    };

    for (final lowerKey in allKeys) {
      final meta = fieldMap[lowerKey];
      final actualKey = meta?.key as String? ?? sanitized.keys.firstWhere((k) => k.toLowerCase() == lowerKey, orElse: () => lowerKey);
      dynamic val = sanitized[actualKey] ?? sanitized.entries.firstWhere((e) => e.key.toLowerCase() == lowerKey, orElse: () => const MapEntry('', null)).value;

      if ((val == null || (val is String && val.isEmpty)) && defaultValues.containsKey(actualKey)) {
        val = defaultValues[actualKey];
      }

      final isNumberType = meta != null && meta.type?.toString().contains('number') == true;
      final isArrayType = meta != null && meta.type?.toString().contains('array') == true;

      if (isArrayType || val is List) {
        final nestedDefs = (meta?.nestedFields as List<dynamic>?) ?? const [];
        final list = (val as List<dynamic>?) ?? const [];
        result[actualKey] = list.map((item) => item is Map<String, dynamic> ? _formatNestedItem(parentKey: actualKey, rawItem: item, nestedDefs: nestedDefs, defaultValues: defaultValues) : item).toList();
      } else if (isNumberType) {
        result[actualKey] = _parseNumber(val);
      } else {
        result[actualKey] = val ?? '';
      }
    }
    return result;
  }

  static Map<String, dynamic> _formatNestedItem({
    required String parentKey,
    required Map<String, dynamic> rawItem,
    required List<dynamic> nestedDefs,
    required Map<String, dynamic> defaultValues,
  }) {
    final sanitized = sanitize(rawItem);
    final result = <String, dynamic>{};
    final childMap = <String, dynamic>{};
    for (final child in nestedDefs) {
      if (child.key != null) childMap[child.key.toString().toLowerCase()] = child;
    }

    final prefix = '${parentKey.toLowerCase()}.';
    for (final entry in defaultValues.entries) {
      if (entry.key.toLowerCase().startsWith(prefix)) {
        final subKey = entry.key.substring(parentKey.length + 1);
        if (!sanitized.containsKey(subKey) && !sanitized.keys.any((sk) => sk.toLowerCase() == subKey.toLowerCase())) {
          sanitized[subKey] = entry.value;
        }
      }
    }

    final allChildKeys = <String>{...childMap.keys, ...sanitized.keys.map((k) => k.toLowerCase())};
    for (final lowerKey in allChildKeys) {
      final childMeta = childMap[lowerKey];
      final actualKey = childMeta?.key as String? ?? sanitized.keys.firstWhere((k) => k.toLowerCase() == lowerKey, orElse: () => lowerKey);
      dynamic val = sanitized[actualKey] ?? sanitized.entries.firstWhere((e) => e.key.toLowerCase() == lowerKey, orElse: () => const MapEntry('', null)).value;
      result[actualKey] = (childMeta != null && childMeta.type?.toString().contains('number') == true) ? _parseNumber(val) : (val ?? '');
    }
    return result;
  }

  static dynamic _parseNumber(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val;
    final str = val.toString().trim();
    if (str.isEmpty) return 0;
    return int.tryParse(str) ?? double.tryParse(str) ?? 0;
  }

  static String extractErrorMessage(dynamic error) {
    if (error is DioException && error.response?.data is Map) {
      final map = error.response!.data as Map;
      final err = map['error'];
      if (err is Map && err['message'] != null) return err['message'].toString();
    }
    return error.toString();
  }

  static String extractSuccessMessage(Map<String, dynamic>? response, {required String fallback}) {
    if (response == null || response.isEmpty) return fallback;
    final candidateKeys = ['message', 'msg', 'result', 'info', 'description', 'detail', 'statustext'];
    for (final entry in response.entries) {
      if (candidateKeys.contains(entry.key.toLowerCase()) && entry.value != null) {
        final val = entry.value.toString().trim();
        if (val.isNotEmpty) return val;
      }
    }
    if (response.containsKey('value') && response['value'] != null) {
      final val = response['value'];
      if (val is String && val.trim().isNotEmpty) return val.trim();
      if (val is Map<String, dynamic>) return extractSuccessMessage(val, fallback: fallback);
    }
    const skipKeys = {'@odata.context', '@odata.metadata', 'luname', 'objid', 'objversion', 'rowkey', 'rowstate', 'rowtype'};
    for (final entry in response.entries) {
      if (!entry.key.startsWith('@') && !skipKeys.contains(entry.key.toLowerCase()) && entry.value != null) {
        final valStr = entry.value.toString().trim();
        if (valStr.isNotEmpty && entry.value is! List && entry.value is! Map) return '${entry.key}: $valStr';
      }
    }
    return fallback;
  }
}
