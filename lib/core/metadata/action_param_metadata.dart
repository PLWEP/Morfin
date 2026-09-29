import 'entity_metadata.dart';

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

  EntityFieldMetadata toFormField({String? projection}) {
    return EntityFieldMetadata(
      key: paramName,
      label: _humanize(paramName),
      type: _resolveType(dataType),
      isRequired: isMandatory,
      options: const [],
      lovReference: (lovReference != null && lovReference!.trim().isNotEmpty) ? lovReference!.trim() : null,
      lovProjection: projection,
    );
  }

  static FieldType _resolveType(String type) {
    switch (type.toUpperCase()) {
      case 'NUMBER':
      case 'INTEGER':
        return FieldType.number;
      case 'DATE':
      case 'DATETIME':
      case 'TIMESTAMP':
        return FieldType.date;
      case 'BOOLEAN':
        return FieldType.boolean;
      default:
        return FieldType.text;
    }
  }

  static String _humanize(String key) {
    return key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}').trim();
  }
}
