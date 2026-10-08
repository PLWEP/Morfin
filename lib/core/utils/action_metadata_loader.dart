import 'package:flutter/foundation.dart';
import '../metadata/action_param_metadata.dart';
import '../metadata/record_metadata.dart';
import '../network/data_query.dart';
import '../services/backend_service.dart';
import '../services/schema_catalog_service.dart';

class ActionMetadataLoader {
  const ActionMetadataLoader._();

  static Future<(List<RecordFieldMetadata>, List<Map<String, dynamic>>)> load({
    required String projection,
    required String actionName,
    required RecordSchemaMetadata schema,
  }) async {
    List<RecordFieldMetadata> formFields = [];
    List<Map<String, dynamic>> rawParams = [];
    try {
      rawParams = await BackendService.instance.fetchCollection(
        projection: 'MobileAppDesignHandling',
        entitySet: 'ActionParamSet',
        query: DataQuery(filter: "ProjectionName eq '$projection' and ActionName eq '$actionName'"),
      );

      if (rawParams.isNotEmpty) {
        formFields = rawParams.map((p) => ActionParamMetadata.fromJson(p).toFormField(projection: projection)).toList();
      } else {
        formFields = await SchemaCatalogService.instance.fetchActionFields(projection: projection, actionName: actionName);
        if (formFields.isEmpty) {
          formFields = await SchemaCatalogService.instance.fetchRecordFields(
            projection: projection,
            collectionOrType: schema.entitySet.isNotEmpty ? schema.entitySet : actionName,
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to load action metadata: $e');
    }
    return (formFields, rawParams);
  }
}
