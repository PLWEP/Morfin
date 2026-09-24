import 'package:flutter/foundation.dart';

enum FieldType {
  text,
  number,
  status,
  priority,
  date,
  boolean,
  currency,
}

@immutable
class EntityFieldMetadata {
  final String key;
  final String label;
  final FieldType type;
  final bool isKey;

  const EntityFieldMetadata({
    required this.key,
    required this.label,
    this.type = FieldType.text,
    this.isKey = false,
  });

  factory EntityFieldMetadata.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'text';
    final fieldType = FieldType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => FieldType.text,
    );

    return EntityFieldMetadata(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: fieldType,
      isKey: json['isKey'] as bool? ?? false,
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
  final EntityListCardMetadata listCard;

  const EntitySchemaMetadata({
    required this.entityName,
    required this.title,
    this.icon = 'assignment',
    this.fields = const [],
    required this.listCard,
  });

  factory EntitySchemaMetadata.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'] as List<dynamic>? ?? [];
    return EntitySchemaMetadata(
      entityName: json['entityName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? 'assignment',
      fields: rawFields
          .map((f) => EntityFieldMetadata.fromJson(f as Map<String, dynamic>))
          .toList(),
      listCard: EntityListCardMetadata.fromJson(
        json['listCard'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
