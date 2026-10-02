import 'entity_metadata.dart';

class EntitySchemaRegistry {
  const EntitySchemaRegistry._();

  static EntitySchemaMetadata? findByTarget(String target) {
    // Pure SDUI: All schemas are dynamically built from backend Projection, EntitySet, and ColumnConfig.
    return null;
  }
}
