class ColumnConfig {
  final String titleField;
  final String? subtitleField;
  final List<String> detailFields;

  const ColumnConfig({
    required this.titleField,
    this.subtitleField,
    this.detailFields = const [],
  });

  factory ColumnConfig.parse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return const ColumnConfig(titleField: '');
    }
    final map = <String, String>{};
    for (final pair in raw.split('^')) {
      final kv = pair.split('=');
      if (kv.length == 2 && kv[0].trim().isNotEmpty) {
        map[kv[0].trim()] = kv[1].trim();
      }
    }
    final details = [
      for (int i = 1; i <= 5; i++)
        if (map.containsKey('COL$i') && map['COL$i']!.isNotEmpty) map['COL$i']!
    ];
    return ColumnConfig(
      titleField: map['TITLE'] ?? '',
      subtitleField: map['SUBTITLE'],
      detailFields: details,
    );
  }
}
