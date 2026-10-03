import '../metadata/action_param_metadata.dart';
import '../metadata/record_metadata.dart';
import 'record_display_utils.dart';

class ActionFieldConsolidator {
  const ActionFieldConsolidator._();

  static List<RecordFieldMetadata> consolidate({
    required List<RecordFieldMetadata> formFields,
    required Set<String> mandatoryFields,
    required Set<String> optionalFields,
    required Set<String> hiddenFields,
  }) {
    final topLevelFields = <String, RecordFieldMetadata>{};
    final nestedMap = <String, List<RecordFieldMetadata>>{};

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

    final consolidated = <RecordFieldMetadata>[];
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

  static List<RecordFieldMetadata> buildAllDefinitions({
    required List<RecordFieldMetadata> formFields,
    required List<Map<String, dynamic>> rawParams,
    required String projection,
  }) {
    final allTopLevel = <String, RecordFieldMetadata>{};
    final allNested = <String, List<RecordFieldMetadata>>{};

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

    final allDefs = <RecordFieldMetadata>[];
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

  /// Falls back to [projection] for any field (or nested field) without its own LOV projection.
  static List<RecordFieldMetadata> applyLovProjection(List<RecordFieldMetadata> fields, String projection) {
    final proj = projection.replaceAll('/', '').trim();
    String? pick(String? p) => (p == null || p.isEmpty) ? proj : p;
    return fields
        .map((f) => f.copyWith(
              lovProjection: pick(f.lovProjection),
              nestedFields: f.nestedFields.map((nf) => nf.copyWith(lovProjection: pick(nf.lovProjection))).toList(),
            ))
        .toList();
  }

  /// Seeds form values: configured defaults win over record values (case-insensitive key match),
  /// then remaining top-level defaults and record keys are carried along for payload context.
  static Map<String, dynamic> resolveInitialValues({
    required List<RecordFieldMetadata> fields,
    required Map<String, dynamic> defaults,
    required Map<String, dynamic> record,
  }) {
    dynamic lookup(Map<String, dynamic> src, String key) =>
        src.entries.where((e) => e.key.toLowerCase() == key.toLowerCase() && e.value != null).firstOrNull?.value;

    final values = <String, dynamic>{};
    for (final f in fields) {
      final v = lookup(defaults, f.key) ?? lookup(record, f.key);
      if (v != null) values[f.key] = v;
    }
    for (final e in defaults.entries) {
      if (!e.key.contains('.')) values.putIfAbsent(e.key, () => e.value);
    }
    for (final e in record.entries) {
      values.putIfAbsent(e.key, () => e.value);
    }
    return values;
  }
}
