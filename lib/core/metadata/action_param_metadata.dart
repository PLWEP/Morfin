import 'record_metadata.dart';

class ActionParamMetadata {
  final String paramName;
  final String dataType;
  final bool isMandatory;
  final String? lovReference;

  const ActionParamMetadata({
    required this.paramName,
    required this.dataType,
    required this.isMandatory,
    this.lovReference,
  });

  factory ActionParamMetadata.fromJson(Map<String, dynamic> json) {
    final mandatoryVal = json['IsMandatory'];
    final isMandatory = mandatoryVal == true ||
        mandatoryVal == 'TRUE' ||
        mandatoryVal == 'true';

    return ActionParamMetadata(
      paramName: json['ParamName'] as String? ?? '',
      dataType: json['DataType'] as String? ?? 'Text',
      isMandatory: isMandatory,
      lovReference: json['LovReference'] as String?,
    );
  }

  RecordFieldMetadata toFormField({String? projection}) {
    final resolvedType = _resolveType(dataType);
    final isStructureOrArray = resolvedType == FieldType.array;

    return RecordFieldMetadata(
      key: paramName,
      label: _humanize(paramName),
      type: resolvedType,
      isRequired: isMandatory,
      options: const [],
      lovReference: (!isStructureOrArray && lovReference != null && lovReference!.trim().isNotEmpty) ? lovReference!.trim() : null,
      lovProjection: isStructureOrArray ? null : projection,
    );
  }

  static FieldType _resolveType(String type) {
    final upper = type.toUpperCase();
    if (upper == 'NUMBER' || upper == 'INTEGER' || upper == 'DECIMAL') {
      return FieldType.number;
    }
    if (upper == 'DATE' || upper == 'DATETIME' || upper == 'TIMESTAMP') {
      return FieldType.date;
    }
    if (upper == 'BOOLEAN') {
      return FieldType.boolean;
    }
    if (upper == 'STRUCTURE' || upper.startsWith('LIST<') || upper == 'ARRAY') {
      return FieldType.array;
    }
    return FieldType.text;
  }

  static String _humanize(String key) {
    return key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}').trim();
  }
}
