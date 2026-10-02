import '../metadata/action_param_metadata.dart';
import '../metadata/entity_metadata.dart';
import 'record_display_utils.dart';

class ActionFieldConsolidator {
  const ActionFieldConsolidator._();

  static List<EntityFieldMetadata> consolidate({
    required List<EntityFieldMetadata> formFields,
    required Set<String> mandatoryFields,
    required Set<String> optionalFields,
    required Set<String> hiddenFields,
  }) {
    final topLevelFields = <String, EntityFieldMetadata>{};
    final nestedMap = <String, List<EntityFieldMetadata>>{};

    for (final f in formFields) {
      if (f.key.contains('.')) {
        final parts = f.key.split('.');
        final parentKey = parts[0];
        final childKey = parts.sublist(1).join('.');

        final childField = f.copyWith(
          key: childKey,
          label: RecordDisplayUtils.formatLabel(childKey),
          isRequired: mandatoryFields.contains(f.key.toUpperCase())
              ? true
              : (optionalFields.contains(f.key.toUpperCase()) ? false : f.isRequired),
        );

        nestedMap.putIfAbsent(parentKey, () => []).add(childField);
      } else {
        final isReq = mandatoryFields.contains(f.key.toUpperCase())
            ? true
            : (optionalFields.contains(f.key.toUpperCase()) ? false : f.isRequired);
        topLevelFields[f.key] = f.copyWith(isRequired: isReq);
      }
    }

    final consolidated = <EntityFieldMetadata>[];
    for (final entry in topLevelFields.entries) {
      var parentField = entry.value;
      if (nestedMap.containsKey(parentField.key)) {
        final children = nestedMap[parentField.key]!;
        final visibleChildren = children
            .where((c) =>
                !hiddenFields.contains('${parentField.key}.${c.key}'.toUpperCase()) &&
                !hiddenFields.contains(c.key.toUpperCase()))
            .toList();
        parentField = parentField.copyWith(
          nestedFields: visibleChildren,
          type: FieldType.array,
        );
      }
      consolidated.add(parentField);
    }

    if (hiddenFields.isNotEmpty) {
      return consolidated.where((f) => !hiddenFields.contains(f.key.toUpperCase())).toList();
    }
    return consolidated;
  }

  static List<EntityFieldMetadata> buildAllDefinitions({
    required List<EntityFieldMetadata> formFields,
    required List<Map<String, dynamic>> rawParams,
    required String projection,
  }) {
    final allTopLevel = <String, EntityFieldMetadata>{};
    final allNested = <String, List<EntityFieldMetadata>>{};

    for (final f in formFields) {
      allTopLevel[f.key] = f;
    }

    for (final f in rawParams.map((p) => ActionParamMetadata.fromJson(p).toFormField(projection: projection))) {
      if (f.key.contains('.')) {
        final parts = f.key.split('.');
        allNested.putIfAbsent(parts[0], () => []).add(f.copyWith(key: parts.sublist(1).join('.')));
      } else {
        allTopLevel.putIfAbsent(f.key, () => f);
      }
    }

    final allDefs = <EntityFieldMetadata>[];
    for (final entry in allTopLevel.entries) {
      var field = entry.value;
      if (allNested.containsKey(field.key)) {
        field = field.copyWith(
          nestedFields: allNested[field.key]!,
          type: FieldType.array,
        );
      }
      allDefs.add(field);
    }
    return allDefs;
  }
}
