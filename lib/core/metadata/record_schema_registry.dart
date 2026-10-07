import 'record_metadata.dart';

/// Runtime registry for dynamically discovered or pre-registered SDUI record schemas.
class RecordSchemaRegistry {
  const RecordSchemaRegistry._();

  static final Map<String, RecordSchemaMetadata> _registry = {};

  /// Registers a schema dynamically using its target, recordType, or projection as lookup keys.
  static void register(String key, RecordSchemaMetadata schema) {
    _registry[key.toLowerCase()] = schema;
    if (schema.recordType.isNotEmpty) {
      _registry[schema.recordType.toLowerCase()] = schema;
    }
    if (schema.projection.isNotEmpty) {
      _registry[schema.projection.toLowerCase()] = schema;
    }
  }

  /// Finds a registered schema by target path, projection name, or recordType.
  static RecordSchemaMetadata? findByTarget(String target) {
    final cleaned = target.replaceAll('/', '').trim().toLowerCase();
    return _registry[cleaned] ?? _registry[target.toLowerCase()];
  }

  /// Checks if a schema is registered for the given target.
  static bool has(String target) => findByTarget(target) != null;

  /// Clears the in-memory schema cache.
  static void clear() => _registry.clear();
}
