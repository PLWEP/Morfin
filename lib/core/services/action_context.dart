import 'package:flutter/foundation.dart';

class ActionContext {
  static final ActionContext instance = ActionContext._();
  final Map<String, dynamic> _context = {};

  ActionContext._();

  void set(String key, dynamic value) {
    _context[key] = value;
    debugPrint('[ActionContext] set $key = $value');
  }

  void setAll(Map<String, dynamic> values) {
    _context.addAll(values);
  }

  dynamic get(String key) => _context[key];

  Map<String, dynamic> get snapshot => Map.unmodifiable(_context);

  void clear() {
    _context.clear();
  }

  String interpolate(String template) {
    if (!template.contains('{{')) return template;
    var result = template;
    final regex = RegExp(r'\{\{([a-zA-Z0-9_\.]+)\}\}');
    for (final match in regex.allMatches(template)) {
      final key = match.group(1);
      if (key != null && _context.containsKey(key)) {
        result = result.replaceAll(match.group(0)!, _context[key]?.toString() ?? '');
      }
    }
    return result;
  }
}
