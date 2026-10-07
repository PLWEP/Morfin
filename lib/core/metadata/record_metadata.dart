import 'package:flutter/foundation.dart';

enum FieldType { text, number, status, priority, date, boolean, currency, array, barcode }
enum ActionScope { global, record }

@immutable
class RecordFieldMetadata {
  final String key;
  final String label;
  final FieldType type;
  final bool isKey;
  final bool isRequired;
  final List<String> options;
  final String? lovReference;
  final String? lovProjection;
  final List<RecordFieldMetadata> nestedFields;

  const RecordFieldMetadata({
    required this.key,
    required this.label,
    this.type = FieldType.text,
    this.isKey = false,
    this.isRequired = false,
    this.options = const [],
    this.lovReference,
    this.lovProjection,
    this.nestedFields = const [],
  });

  factory RecordFieldMetadata.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'text';
    final fieldType = FieldType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => FieldType.text,
    );
    final rawOpts = json['options'] as List<dynamic>? ?? [];
    final rawNested = json['fields'] as List<dynamic>? ?? [];

    final isReq = json['isRequired'] == true || json['required'] == true ||
        json['isRequired'] == 'TRUE' || json['required'] == 'TRUE';

    return RecordFieldMetadata(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: fieldType,
      isKey: json['isKey'] as bool? ?? false,
      isRequired: isReq,
      options: rawOpts.map((e) => e.toString()).toList(),
      lovReference: json['lovReference'] as String?,
      lovProjection: json['lovProjection'] as String?,
      nestedFields: rawNested.map((e) => RecordFieldMetadata.fromJson(Map<String, dynamic>.from(e as Map))).toList(),
    );
  }

  RecordFieldMetadata copyWith({
    String? key,
    String? label,
    FieldType? type,
    bool? isKey,
    bool? isRequired,
    List<String>? options,
    String? lovReference,
    String? lovProjection,
    List<RecordFieldMetadata>? nestedFields,
  }) {
    return RecordFieldMetadata(
      key: key ?? this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      isKey: isKey ?? this.isKey,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
      lovReference: lovReference ?? this.lovReference,
      lovProjection: lovProjection ?? this.lovProjection,
      nestedFields: nestedFields ?? this.nestedFields,
    );
  }
}

@immutable
class RecordActionMetadata {
  final String name;
  final String label;
  final String? icon;
  final ActionScope scope;
  final List<RecordFieldMetadata> formFields;
  final String? condition;

  const RecordActionMetadata({
    required this.name,
    required this.label,
    this.icon,
    this.scope = ActionScope.record,
    this.formFields = const [],
    this.condition,
  });

  factory RecordActionMetadata.fromJson(Map<String, dynamic> json) {
    final scopeStr = json['scope'] as String? ?? 'record';
    final rawFields = json['formFields'] as List<dynamic>? ?? [];
    return RecordActionMetadata(
      name: json['name'] as String? ?? '',
      label: json['label'] as String? ?? '',
      icon: json['icon'] as String?,
      scope: scopeStr == 'global' ? ActionScope.global : ActionScope.record,
      formFields: rawFields
          .map((f) => RecordFieldMetadata.fromJson(f as Map<String, dynamic>))
          .toList(),
      condition: json['condition'] as String? ?? json['Condition'] as String? ?? json['visible'] as String?,
    );
  }
}

@immutable
class RecordListCardMetadata {
  final String codeField;
  final String primaryField;
  final String? secondaryField;
  final String? tertiaryField;
  final String? statusField;
  final String? priorityField;
  final String? metricField;

  const RecordListCardMetadata({
    required this.codeField,
    required this.primaryField,
    this.secondaryField,
    this.tertiaryField,
    this.statusField,
    this.priorityField,
    this.metricField,
  });

  factory RecordListCardMetadata.fromJson(Map<String, dynamic> json) => RecordListCardMetadata(
    codeField: json['codeField'] as String? ?? 'code',
    primaryField: json['primaryField'] as String? ?? 'title',
    secondaryField: json['secondaryField'] as String?,
    tertiaryField: json['tertiaryField'] as String?,
    statusField: json['statusField'] as String?,
    priorityField: json['priorityField'] as String?,
    metricField: json['metricField'] as String?,
  );
}

@immutable
class RecordSchemaMetadata {
  final String entityName;
  final String title;
  final String icon;
  final String projection;
  final String entitySet;
  final List<RecordFieldMetadata> fields;
  final List<RecordActionMetadata> actions;
  final RecordListCardMetadata listCard;

  const RecordSchemaMetadata({
    required this.entityName,
    required this.title,
    this.icon = 'assignment',
    this.projection = '',
    this.entitySet = '',
    this.fields = const [],
    this.actions = const [],
    required this.listCard,
  });

  factory RecordSchemaMetadata.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'] as List<dynamic>? ?? [];
    final rawActions = json['actions'] as List<dynamic>? ?? [];
    return RecordSchemaMetadata(
      entityName: json['entityName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? 'assignment',
      projection: json['projection'] as String? ?? '',
      entitySet: json['entitySet'] as String? ?? '',
      fields: rawFields.map((f) => RecordFieldMetadata.fromJson(f as Map<String, dynamic>)).toList(),
      actions: rawActions.map((a) => RecordActionMetadata.fromJson(a as Map<String, dynamic>)).toList(),
      listCard: RecordListCardMetadata.fromJson(json['listCard'] as Map<String, dynamic>? ?? {}),
    );
  }
}

