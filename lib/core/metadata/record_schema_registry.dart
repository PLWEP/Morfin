import 'record_metadata.dart';

class RecordSchemaRegistry {
  const RecordSchemaRegistry._();

  static RecordSchemaMetadata? findByTarget(String target) {
    // Pure SDUI: All schemas are dynamically built from backend Projection, EntitySet, and ColumnConfig.
    return null;
  }
}
