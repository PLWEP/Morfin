/// OData v4 field data types for filter expression formatting.
enum ODataFieldType {
  string,
  number,
  date,
  dateTime,
  enumType,
  boolType,
}

/// OData v4 filter operators.
enum ODataFilterOp {
  eq,
  ne,
  lt,
  le,
  gt,
  ge,
  contains,
  startswith,
  between,
}

extension ODataFilterOpLabel on ODataFilterOp {
  String get symbol {
    switch (this) {
      case ODataFilterOp.eq:
        return 'eq';
      case ODataFilterOp.ne:
        return 'ne';
      case ODataFilterOp.lt:
        return 'lt';
      case ODataFilterOp.le:
        return 'le';
      case ODataFilterOp.gt:
        return 'gt';
      case ODataFilterOp.ge:
        return 'ge';
      case ODataFilterOp.contains:
        return 'contains';
      case ODataFilterOp.startswith:
        return 'startswith';
      case ODataFilterOp.between:
        return 'between';
    }
  }
}

class ODataFilterEntry {
  final String odataField;
  final ODataFilterOp op;
  final ODataFieldType fieldType;
  final String? label;
  final String? value;
  final String? valueTo;
  final Set<String> selectedValues;
  final String? enumQualifier;

  const ODataFilterEntry({
    required this.odataField,
    required this.op,
    required this.fieldType,
    this.label,
    this.value,
    this.valueTo,
    this.selectedValues = const {},
    this.enumQualifier,
  });
}

class ODataFilterBuilder {
  const ODataFilterBuilder._();

  static String? build(List<ODataFilterEntry> entries) {
    final parts = <String>[];
    for (final entry in entries) {
      final hasValue = entry.fieldType == ODataFieldType.enumType
          ? entry.selectedValues.isNotEmpty
          : (entry.value != null && entry.value!.trim().isNotEmpty);
      if (!hasValue) continue;
      final expr = _buildExpression(entry);
      if (expr != null) parts.add(expr);
    }
    return parts.isEmpty ? null : parts.join(' and ');
  }

  static String? _buildExpression(ODataFilterEntry entry) {
    switch (entry.fieldType) {
      case ODataFieldType.string:
        return _stringExpr(entry);
      case ODataFieldType.number:
        return _numberExpr(entry);
      case ODataFieldType.date:
      case ODataFieldType.dateTime:
        return _dateExpr(entry);
      case ODataFieldType.enumType:
        return _enumExpr(entry);
      case ODataFieldType.boolType:
        return _boolExpr(entry);
    }
  }

  static String? _stringExpr(ODataFilterEntry e) {
    final val = e.value?.trim();
    if (val == null || val.isEmpty) return null;
    switch (e.op) {
      case ODataFilterOp.contains:
        return "contains(${e.odataField},'$val')";
      case ODataFilterOp.startswith:
        return "startswith(${e.odataField},'$val')";
      case ODataFilterOp.ne:
        return "${e.odataField} ne '$val'";
      default:
        return "${e.odataField} eq '$val'";
    }
  }

  static String? _numberExpr(ODataFilterEntry e) {
    final val = e.value?.trim();
    if (val == null || val.isEmpty) return null;
    if (e.op == ODataFilterOp.between && e.valueTo != null && e.valueTo!.trim().isNotEmpty) {
      return '(${e.odataField} ge $val and ${e.odataField} le ${e.valueTo!.trim()})';
    }
    return '${e.odataField} ${e.op.symbol} $val';
  }

  static String? _dateExpr(ODataFilterEntry e) {
    final val = e.value?.trim();
    if (val == null || val.isEmpty) return null;
    if (e.op == ODataFilterOp.between && e.valueTo != null && e.valueTo!.trim().isNotEmpty) {
      return '(${e.odataField} ge $val and ${e.odataField} le ${e.valueTo!.trim()})';
    }
    return '${e.odataField} ${e.op.symbol} $val';
  }

  static String? _enumExpr(ODataFilterEntry e) {
    if (e.selectedValues.isEmpty) return null;
    final qualifier = e.enumQualifier != null && e.enumQualifier!.isNotEmpty
        ? "${e.enumQualifier!}'"
        : "'";
    if (e.selectedValues.length == 1) {
      return "${e.odataField} eq $qualifier${e.selectedValues.first}'";
    }
    final conditions = e.selectedValues
        .map((v) => "${e.odataField} eq $qualifier$v'")
        .join(' or ');
    return '($conditions)';
  }

  static String? _boolExpr(ODataFilterEntry e) {
    final val = e.value?.trim();
    if (val == null || val.isEmpty) return null;
    return '${e.odataField} eq $val';
  }

  static String autoQualifyEnum({
    required String fieldName,
    required String value,
    required String projection,
    String? enumTypeName,
  }) {
    final typeName = enumTypeName ?? '${projection}State';
    return "$fieldName eq IfsApp.$projection.$typeName'$value'";
  }
}
