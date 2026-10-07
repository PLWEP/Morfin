class RecordDisplayUtils {
  const RecordDisplayUtils._();

  static bool isMetadataKey(String key) {
    final lower = key.toLowerCase();
    return lower == 'luname' ||
        lower == 'keyref' ||
        lower == 'objid' ||
        lower == 'objversion' ||
        lower == 'objkey' ||
        lower == 'objstate' ||
        lower == 'objevents' ||
        lower.startsWith('@odata');
  }

  static List<(String, String)> extractDisplayRows(Map<String, dynamic> item) {
    final entries = item.entries.where((e) => !isMetadataKey(e.key) && e.value != null).toList();
    if (entries.isEmpty) return const [];

    return entries.take(2).map((e) {
      final label = formatLabel(e.key);
      final value = e.value.toString();
      return (label, value);
    }).toList();
  }

  static String formatLabel(String key) {
    return key.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}');
  }
}
