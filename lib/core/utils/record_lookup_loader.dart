import '../network/data_query.dart';
import '../services/backend_service.dart';
import '../services/schema_catalog_service.dart';

class RecordLookupLoader {
  const RecordLookupLoader._();

  static Future<(List<Map<String, dynamic>>, String?, String?, String?)> load({
    required String projection,
    required String lovReference,
    String? contextFilter,
    String? targetFieldKey,
    Map<String, dynamic> contextualValues = const {},
  }) async {
    final proj = projection.replaceAll('/', '').trim();
    if (proj.isEmpty) {
      return (<Map<String, dynamic>>[], null, null, 'Projection name is missing');
    }

    final ref = lovReference.trim();
    if (ref.isEmpty) {
      return (<Map<String, dynamic>>[], null, null, 'LOV reference name is missing');
    }

    final entitySet = ref.startsWith('Reference_') ? ref : 'Reference_$ref';

    try {
      String? effectiveFilter = (contextFilter != null && contextFilter.trim().isNotEmpty)
          ? contextFilter.trim()
          : null;

      String debugNotes = 'proj:$proj|set:$entitySet|target:$targetFieldKey';

      if (effectiveFilter == null &&
          contextualValues.isNotEmpty &&
          targetFieldKey != null &&
          targetFieldKey.isNotEmpty) {
        final entityKeys = await SchemaCatalogService.instance.fetchEntityKeys(
          projection: proj,
          entitySetOrName: entitySet,
        );

        final targetLower = targetFieldKey.toLowerCase();
        final dynamicParts = <String>[];

        for (final k in entityKeys) {
          if (k.toLowerCase() == targetLower) continue;

          final match = contextualValues.entries.firstWhere(
            (e) =>
                e.key.toLowerCase() == k.toLowerCase() &&
                e.value != null &&
                e.value.toString().isNotEmpty,
            orElse: () => const MapEntry('', null),
          );

          if (match.key.isNotEmpty) {
            dynamicParts.add("$k eq '${match.value}'");
          }
        }

        if (dynamicParts.isNotEmpty) {
          effectiveFilter = dynamicParts.join(' and ');
        }
        debugNotes += '|keys:${entityKeys.join(",")}|ctx:${contextualValues.keys.join(",")}';
      } else {
        debugNotes += '|ctxEmpty:${contextualValues.isEmpty}|ctx:$contextualValues';
      }

      final res = await BackendService.instance.fetchEntitySet(
        projection: proj,
        entitySet: entitySet,
        query: DataQuery(top: 50, filter: effectiveFilter),
      );

      return (res, effectiveFilter, debugNotes, null);
    } catch (e) {
      return (<Map<String, dynamic>>[], null, null, e.toString());
    }
  }
}
