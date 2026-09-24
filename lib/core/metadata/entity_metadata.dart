import 'package:flutter/foundation.dart';

enum FieldType { text, number, status, priority, date, boolean, currency }
enum ActionScope { global, record }

@immutable
class EntityFieldMetadata {
  final String key;
  final String label;
  final FieldType type;
  final bool isKey;
  final bool isRequired;
  final List<String> options;

  const EntityFieldMetadata({
    required this.key,
    required this.label,
    this.type = FieldType.text,
    this.isKey = false,
    this.isRequired = false,
    this.options = const [],
  });

  factory EntityFieldMetadata.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'text';
    final fieldType = FieldType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => FieldType.text,
    );
    final rawOpts = json['options'] as List<dynamic>? ?? [];

    return EntityFieldMetadata(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: fieldType,
      isKey: json['isKey'] as bool? ?? false,
      isRequired: json['isRequired'] as bool? ?? false,
      options: rawOpts.map((e) => e.toString()).toList(),
    );
  }
}

@immutable
class EntityActionMetadata {
  final String name;
  final String label;
  final String? icon;
  final ActionScope scope;
  final List<EntityFieldMetadata> formFields;

  const EntityActionMetadata({
    required this.name,
    required this.label,
    this.icon,
    this.scope = ActionScope.record,
    this.formFields = const [],
  });

  factory EntityActionMetadata.fromJson(Map<String, dynamic> json) {
    final scopeStr = json['scope'] as String? ?? 'record';
    final rawFields = json['formFields'] as List<dynamic>? ?? [];
    return EntityActionMetadata(
      name: json['name'] as String? ?? '',
      label: json['label'] as String? ?? '',
      icon: json['icon'] as String?,
      scope: scopeStr == 'global' ? ActionScope.global : ActionScope.record,
      formFields: rawFields
          .map((f) => EntityFieldMetadata.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }
}

@immutable
class EntityListCardMetadata {
  final String codeField;
  final String primaryField;
  final String? secondaryField;
  final String? tertiaryField;
  final String? statusField;
  final String? priorityField;
  final String? metricField;

  const EntityListCardMetadata({
    required this.codeField,
    required this.primaryField,
    this.secondaryField,
    this.tertiaryField,
    this.statusField,
    this.priorityField,
    this.metricField,
  });

  factory EntityListCardMetadata.fromJson(Map<String, dynamic> json) {
    return EntityListCardMetadata(
      codeField: json['codeField'] as String? ?? 'code',
      primaryField: json['primaryField'] as String? ?? 'title',
      secondaryField: json['secondaryField'] as String?,
      tertiaryField: json['tertiaryField'] as String?,
      statusField: json['statusField'] as String?,
      priorityField: json['priorityField'] as String?,
      metricField: json['metricField'] as String?,
    );
  }
}

@immutable
class EntitySchemaMetadata {
  final String entityName;
  final String title;
  final String icon;
  final List<EntityFieldMetadata> fields;
  final List<EntityActionMetadata> actions;
  final EntityListCardMetadata listCard;

  const EntitySchemaMetadata({
    required this.entityName,
    required this.title,
    this.icon = 'assignment',
    this.fields = const [],
    this.actions = const [],
    required this.listCard,
  });

  factory EntitySchemaMetadata.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'] as List<dynamic>? ?? [];
    final rawActions = json['actions'] as List<dynamic>? ?? [];
    return EntitySchemaMetadata(
      entityName: json['entityName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? 'assignment',
      fields: rawFields
          .map((f) => EntityFieldMetadata.fromJson(f as Map<String, dynamic>))
          .toList(),
      actions: rawActions
          .map((a) => EntityActionMetadata.fromJson(a as Map<String, dynamic>))
          .toList(),
      listCard: EntityListCardMetadata.fromJson(
        json['listCard'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
