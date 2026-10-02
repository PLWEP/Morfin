import 'dart:convert';
import '../metadata/entity_metadata.dart';

/// Helper utility for extracting and decoding parameter configs.
class ParamConfigParser {
  const ParamConfigParser._();

  static (Map<String, dynamic>, Set<String>, List<EntityFieldMetadata>) parse(String? cfg) {
    if (cfg == null || cfg.isEmpty) return (const {}, const {}, const []);
    final defaults = <String, dynamic>{};
    final hidden = <String>{};
    final explicit = <EntityFieldMetadata>[];

    final trimmed = cfg.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
        if (decoded.containsKey('fields') && decoded['fields'] is List) {
          final fieldsList = decoded['fields'] as List;
          for (final f in fieldsList) {
            if (f is Map) {
              explicit.add(EntityFieldMetadata.fromJson(Map<String, dynamic>.from(f)));
            }
          }
        }
        if (decoded.containsKey('defaults') && decoded['defaults'] is Map) {
          defaults.addAll(Map<String, dynamic>.from(decoded['defaults'] as Map));
        }
        if (decoded.containsKey('hide') && decoded['hide'] is List) {
          hidden.addAll((decoded['hide'] as List).map((e) => e.toString().toUpperCase()));
        }
        return (defaults, hidden, explicit);
      } catch (_) {}
    }

    for (final token in cfg.split('^')) {
      final t = token.trim();
      if (t.isEmpty) continue;
      final eq = t.indexOf('=');
      if (eq <= 0) continue;
      final k = t.substring(0, eq).trim();
      final v = t.substring(eq + 1).trim();
      if (k.toUpperCase() == 'HIDE') {
        hidden.addAll(v.split(',').map((s) => s.trim().toUpperCase()));
      } else {
        defaults[k] = v;
      }
    }
    return (defaults, hidden, explicit);
  }
}
