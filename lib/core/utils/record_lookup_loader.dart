import '../network/data_query.dart';
import '../services/backend_service.dart';
import '../services/schema_catalog_service.dart';

class RecordLookupLoader {
  const RecordLookupLoader._();

  static Future<(List<Map<String, dynamic>>, String?, String?)> load({
    required String projection,
    required String lovReference,
    String? contextFilter,
    String? targetFieldKey,
    Map<String, dynamic> contextualValues = const {},
  }) async {
    final proj = projection.replaceAll('/', '').trim();
    if (proj.isEmpty) {
      return (<Map<String, dynamic>>[], null, 'Projection name is missing');
    }

    final ref = lovReference.trim();
    if (ref.isEmpty) {
      return (<Map<String, dynamic>>[], null, 'LOV reference name is missing');
    }

    final entitySet = ref.startsWith('Reference_') ? ref : 'Reference_$ref';

    try {
      String? effectiveFilter = (contextFilter != null && contextFilter.trim().isNotEmpty)
          ? contextFilter.trim()
          : null;

      if (effectiveFilter == null &&
          contextualValues.isNotEmpty &&
          targetFieldKey != null &&
          targetFieldKey.isNotEmpty) {
        final keyFields = await SchemaCatalogService.instance.fetchKeyFields(
          projection: proj,
          collectionOrType: entitySet,
        );

        final targetLower = targetFieldKey.toLowerCase();
        final dynamicParts = <String>[];

        for (final k in keyFields) {
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
      }

      final res = await BackendService.instance.fetchCollection(
        projection: proj,
        entitySet: entitySet,
        query: DataQuery(top: 50, filter: effectiveFilter),
      );

      return (res, effectiveFilter, null);
    } catch (e) {
      return (<Map<String, dynamic>>[], null, e.toString());
    }
  }
}
