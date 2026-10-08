import 'package:dio/dio.dart';

class PayloadUtils {
  const PayloadUtils._();

  static String? _extractKey(dynamic f) {
    if (f == null) return null;
    if (f is Map) return f['key']?.toString();
    try {
      return (f.key as dynamic)?.toString();
    } catch (_) {
      return null;
    }
  }

  static String? _extractType(dynamic f) {
    if (f == null) return null;
    if (f is Map) return f['type']?.toString();
    try {
      return (f.type as dynamic)?.toString();
    } catch (_) {
      return null;
    }
  }

  static bool _extractIsRequired(dynamic f) {
    if (f == null) return false;
    if (f is Map) return f['isRequired'] == true;
    try {
      return (f.isRequired as dynamic) == true;
    } catch (_) {
      return false;
    }
  }

  static List<dynamic>? _extractNestedFields(dynamic f) {
    if (f == null) return null;
    if (f is Map) return f['nestedFields'] as List<dynamic>?;
    try {
      return (f.nestedFields as dynamic) as List<dynamic>?;
    } catch (_) {
      return null;
    }
  }

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
      final key = _extractKey(f);
      if (key != null) fieldMap[key.toLowerCase()] = f;
    }

    for (final entry in defaultValues.entries) {
      if (!entry.key.contains('.') && !sanitized.containsKey(entry.key) && !sanitized.keys.any((k) => k.toLowerCase() == entry.key.toLowerCase())) {
        sanitized[entry.key] = entry.value;
      }
    }

    final allKeys = fieldMap.isNotEmpty
        ? fieldMap.keys.where((k) => !k.contains('.')).toSet()
        : <String>{
            ...sanitized.keys.where((k) => !k.contains('.')).map((k) => k.toLowerCase()),
          };

    for (final lowerKey in allKeys) {
      final meta = fieldMap[lowerKey];
      final actualKey = _extractKey(meta) ?? sanitized.keys.firstWhere((k) => k.toLowerCase() == lowerKey, orElse: () => lowerKey);
      dynamic val = sanitized[actualKey] ?? sanitized.entries.firstWhere((e) => e.key.toLowerCase() == lowerKey, orElse: () => const MapEntry('', null)).value;

      if ((val == null || (val is String && val.isEmpty)) && defaultValues.containsKey(actualKey)) {
        val = defaultValues[actualKey];
      }

      final typeStr = _extractType(meta) ?? '';
      final isNumberType = typeStr.contains('number');
      final isArrayType = typeStr.contains('array');
      final isBoolType = typeStr.contains('boolean');

      if (isArrayType || val is List) {
        final nestedDefs = _extractNestedFields(meta) ?? const [];
        final list = (val as List<dynamic>?) ?? const [];
        result[actualKey] = list.map((item) => item is Map<String, dynamic> ? _formatNestedItem(parentKey: actualKey, rawItem: item, nestedDefs: nestedDefs, defaultValues: defaultValues) : item).toList();
      } else if (isNumberType) {
        result[actualKey] = _parseNumber(val);
      } else if (isBoolType) {
        if (val == null) {
          result[actualKey] = null;
        } else {
          result[actualKey] = (val == true || val.toString().toUpperCase() == 'TRUE');
        }
      } else {
        if (val == null || (val is String && val.trim().isEmpty)) {
          final isReq = _extractIsRequired(meta);
          result[actualKey] = isReq ? '' : null;
        } else {
          result[actualKey] = val;
        }
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
      final key = _extractKey(child);
      if (key != null) childMap[key.toLowerCase()] = child;
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
      final actualKey = _extractKey(childMeta) ?? sanitized.keys.firstWhere((k) => k.toLowerCase() == lowerKey, orElse: () => lowerKey);
      dynamic val = sanitized[actualKey] ?? sanitized.entries.firstWhere((e) => e.key.toLowerCase() == lowerKey, orElse: () => const MapEntry('', null)).value;
      final typeStr = _extractType(childMeta) ?? '';
      result[actualKey] = typeStr.contains('number') ? _parseNumber(val) : (val ?? '');
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
      if (err is Map) {
        if (err['details'] is List && (err['details'] as List).isNotEmpty) {
          final firstDetail = (err['details'] as List).first;
          if (firstDetail is Map && firstDetail['message'] != null) {
            return firstDetail['message'].toString();
          }
        }
        if (err['message'] != null) return err['message'].toString();
      }
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
