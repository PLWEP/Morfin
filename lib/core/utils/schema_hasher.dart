class SchemaHasher {
  const SchemaHasher._();

  static String computeSignature(Map<String, dynamic> schema) {
    final buffer = StringBuffer();
    final type = schema['type'] ?? schema['DataType'] ?? 'entity';
    buffer.write('t:$type;');

    final fields = schema['fields'] ?? schema['properties'];
    if (fields is List) {
      final sortedFields = List.from(fields)
        ..sort((a, b) => (a['key'] ?? a['name'] ?? '').toString().compareTo((b['key'] ?? b['name'] ?? '').toString()));
      buffer.write('f:[');
      for (final f in sortedFields) {
        if (f is Map) {
          final k = f['key'] ?? f['name'] ?? '';
          final t = f['type'] ?? f['dataType'] ?? '';
          final req = f['isRequired'] ?? f['required'] ?? false;
          buffer.write('$k:$t:$req;');
        }
      }
      buffer.write('];');
    } else if (fields is Map) {
      final sortedKeys = fields.keys.toList()..sort();
      buffer.write('p:[');
      for (final k in sortedKeys) {
        final val = fields[k];
        buffer.write('$k:${val is Map ? val['type'] ?? '' : ''};');
      }
      buffer.write('];');
    }

    final actions = schema['actions'];
    if (actions is List) {
      final actionNames = actions.map((a) => (a is Map ? (a['name'] ?? '') : a).toString()).toList()..sort();
      buffer.write('a:[${actionNames.join(',')}];');
    }

    return _hashString(buffer.toString());
  }

  static String computeRawHash(String input) => _hashString(input);

  static String _hashString(String input) {
    var hash = 0xcbf29ce484222325;
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    return hash.toRadixString(16);
  }
}
