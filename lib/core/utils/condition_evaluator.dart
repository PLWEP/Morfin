class ConditionEvaluator {
  const ConditionEvaluator._();

  static bool evaluate(String? condition, Map<String, dynamic> record) {
    if (condition == null || condition.trim().isEmpty) return true;
    final cond = condition.trim();

    if (cond.contains('&&')) {
      final subConditions = cond.split('&&');
      return subConditions.every((c) => evaluate(c, record));
    }

    if (cond.contains('||')) {
      final subConditions = cond.split('||');
      return subConditions.any((c) => evaluate(c, record));
    }

    return _evaluateSingle(cond, record);
  }

  static bool _evaluateSingle(String singleCond, Map<String, dynamic> record) {
    var expr = singleCond.trim();
    if (expr.startsWith('(') && expr.endsWith(')')) {
      expr = expr.substring(1, expr.length - 1).trim();
    }

    String? op;
    if (expr.contains('==')) {
      op = '==';
    } else if (expr.contains('!=')) {
      op = '!=';
    } else if (expr.contains('>=')) {
      op = '>=';
    } else if (expr.contains('<=')) {
      op = '<=';
    } else if (expr.contains('>')) {
      op = '>';
    } else if (expr.contains('<')) {
      op = '<';
    } else if (expr.toLowerCase().contains('contains')) {
      op = 'contains';
    }

    if (op == null) {
      final key = _extractKey(expr);
      final val = record[key];
      if (val is bool) return val;
      return val != null && val.toString().trim().isNotEmpty && val != '0';
    }

    final parts = expr.split(op);
    if (parts.length != 2) return true;

    final leftKey = _extractKey(parts[0]);
    final rawRight = parts[1].trim().replaceAll("'", '').replaceAll('"', '');

    final leftValue = record[leftKey];
    final leftStr = leftValue?.toString().trim() ?? '';

    switch (op) {
      case '==':
        return leftStr.toLowerCase() == rawRight.toLowerCase();
      case '!=':
        return leftStr.toLowerCase() != rawRight.toLowerCase();
      case '>':
        final lNum = num.tryParse(leftStr);
        final rNum = num.tryParse(rawRight);
        if (lNum != null && rNum != null) return lNum > rNum;
        return false;
      case '>=':
        final lNum = num.tryParse(leftStr);
        final rNum = num.tryParse(rawRight);
        if (lNum != null && rNum != null) return lNum >= rNum;
        return false;
      case '<':
        final lNum = num.tryParse(leftStr);
        final rNum = num.tryParse(rawRight);
        if (lNum != null && rNum != null) return lNum < rNum;
        return false;
      case '<=':
        final lNum = num.tryParse(leftStr);
        final rNum = num.tryParse(rawRight);
        if (lNum != null && rNum != null) return lNum <= rNum;
        return false;
      case 'contains':
        return leftStr.toLowerCase().contains(rawRight.toLowerCase());
      default:
        return true;
    }
  }

  static String _extractKey(String raw) {
    return raw.trim().replaceAll('[', '').replaceAll(']', '').replaceAll('{', '').replaceAll('}', '');
  }
}
