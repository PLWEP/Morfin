import 'package:shared_preferences/shared_preferences.dart';
import '../storage/local_storage_service.dart';
import '../utils/schema_hasher.dart';
import '../metadata/record_metadata.dart';
import '../network/api_client.dart';
import '../network/api_config.dart';

class SchemaCatalogService {
  static final SchemaCatalogService instance = SchemaCatalogService._();
  SchemaCatalogService._();

  final Map<String, (DateTime, String)> _xmlCache = {};
  static const Duration _cacheTtl = Duration(minutes: 5);

  void clearCache() => _xmlCache.clear();
  void invalidateProjection(String projection) => _xmlCache.remove(projection);
  Future<String?> getSavedSchemaHash(String projection) async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs).getSchemaHash(projection);
  }

  Future<String?> _getMetadataXml(String projection) async {
    final cached = _xmlCache[projection];
    if (cached != null && DateTime.now().difference(cached.$1) < _cacheTtl) {
      return cached.$2;
    }
    final url = '${ApiConfig.instance.projectionBaseUrl}/$projection.svc/\$metadata';
    final xml = await ApiClient.instance.getRawXml(url);
    if (xml != null && xml.isNotEmpty) {
      _xmlCache[projection] = (DateTime.now(), xml);
      final hash = SchemaHasher.computeRawHash(xml);
      SharedPreferences.getInstance().then((prefs) => LocalStorageService(prefs).saveSchemaHash(projection, hash));
      return xml;
    }
    return null;
  }

  Future<List<RecordFieldMetadata>> fetchActionFields({
    required String projection,
    required String actionName,
  }) async {
    final meta = await _getMetadataXml(projection);
    if (meta == null) return [];

    final cleanName = actionName.split('/').last.split('?').first;
    final jsonRegex = RegExp('"$cleanName"\\s*:\\s*\\[([^\\]]+)\\]', caseSensitive: false);
    final jsonMatch = jsonRegex.firstMatch(meta);
    if (jsonMatch != null) {
      final pRegex = RegExp(r'"\$Name"\s*:\s*"([^"]+)"[^}]*"\$Type"\s*:\s*"([^"]+)"');
      final fields = <RecordFieldMetadata>[];
      for (final m in pRegex.allMatches(jsonMatch.group(1)!)) {
        final name = m.group(1) ?? '';
        final type = m.group(2) ?? 'Edm.String';
        if (name.isEmpty || name == 'FullSelection' || name == 'Selection') continue;
        fields.add(RecordFieldMetadata(key: name, label: _humanize(name), type: _resolveFieldType(type)));
      }
      if (fields.isNotEmpty) return fields;
    }

    final actRegex = RegExp('<Action\\s+Name="$cleanName"', caseSensitive: false);
    final match = actRegex.firstMatch(meta);
    if (match == null) return [];

    final actIdx = match.start;
    final actEnd = meta.indexOf('</Action>', actIdx);
    final snippet = actEnd != -1 ? meta.substring(actIdx, actEnd + 9) : meta.substring(actIdx);

    final paramRegex = RegExp(r'<Parameter\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)/>|<Parameter\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)></Parameter>');
    final fields = <RecordFieldMetadata>[];
    for (final m in paramRegex.allMatches(snippet)) {
      final name = m.group(1) ?? m.group(4) ?? '';
      final type = m.group(2) ?? m.group(5) ?? 'Edm.String';
      final attr = m.group(3) ?? m.group(6) ?? '';
      if (name.isEmpty || name == 'FullSelection' || name == 'Selection') continue;
      fields.add(RecordFieldMetadata(
        key: name, label: _humanize(name), type: _resolveFieldType(type), isRequired: !attr.contains('Nullable="true"'),
      ));
    }
    return fields;
  }

  Future<List<RecordFieldMetadata>> fetchRecordFields({
    required String projection,
    required String collectionOrType,
  }) async {
    final xml = await _getMetadataXml(projection);
    if (xml == null) return [];

    var typeName = collectionOrType.split('/').last.split('?').first;
    if (typeName.endsWith('Set')) {
      final esRegex = RegExp('<EntitySet\\s+Name="$typeName"\\s+EntityType="([^"]+)"', caseSensitive: false);
      final esMatch = esRegex.firstMatch(xml);
      if (esMatch != null) {
        typeName = esMatch.group(1)!.split('.').last;
      } else {
        typeName = typeName.substring(0, typeName.length - 3);
      }
    }

    final etRegex = RegExp('<EntityType\\s+Name="$typeName"', caseSensitive: false);
    final etMatch = etRegex.firstMatch(xml);
    if (etMatch == null) {
      final firstEtMatch = RegExp(r'<EntityType\s+Name="([^"]+)"').firstMatch(xml);
      if (firstEtMatch == null) return [];
      typeName = firstEtMatch.group(1)!;
    }

    final etIdx = xml.indexOf(RegExp('<EntityType\\s+Name="$typeName"', caseSensitive: false));
    if (etIdx == -1) return [];
    final etEnd = xml.indexOf('</EntityType>', etIdx);
    final snippet = etEnd != -1 ? xml.substring(etIdx, etEnd + 13) : xml.substring(etIdx);

    final propRegex = RegExp(r'<Property\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)');
    final fields = <RecordFieldMetadata>[];
    const systemFields = {'luname', 'keyref', 'objsite', 'objstate', 'objgrants'};

    for (final m in propRegex.allMatches(snippet)) {
      final name = m.group(1) ?? '';
      final type = m.group(2) ?? 'Edm.String';
      final attr = m.group(3) ?? '';
      if (name.isEmpty || systemFields.contains(name.toLowerCase())) continue;

      fields.add(RecordFieldMetadata(
        key: name, label: _humanize(name), type: _resolveFieldType(type), isRequired: attr.contains('Nullable="false"'),
      ));
    }
    return fields;
  }

  Future<List<String>> fetchKeyFields({
    required String projection,
    required String collectionOrType,
  }) async {
    final xml = await _getMetadataXml(projection);
    if (xml == null) return [];

    var typeName = collectionOrType.split('/').last.split('?').first;
    if (typeName.startsWith('Reference_')) {
      typeName = typeName.substring('Reference_'.length);
    }
    if (typeName.endsWith('Set')) {
      final esRegex = RegExp('<EntitySet\\s+Name="$typeName"\\s+EntityType="([^"]+)"', caseSensitive: false);
      final esMatch = esRegex.firstMatch(xml);
      if (esMatch != null) {
        typeName = esMatch.group(1)!.split('.').last;
      } else {
        typeName = typeName.substring(0, typeName.length - 3);
      }
    }

    final etRegex = RegExp('<EntityType\\s+Name="$typeName"[^>]*>', caseSensitive: false);
    final match = etRegex.firstMatch(xml);
    if (match == null) return [];

    final startIdx = match.start;
    final endIdx = xml.indexOf('</EntityType>', startIdx);
    if (endIdx == -1) return [];

    final snippet = xml.substring(startIdx, endIdx + 13);
    final keyBlockMatch = RegExp(r'<Key>(.*?)</Key>', dotAll: true).firstMatch(snippet);
    if (keyBlockMatch == null) return [];

    final propRefRegex = RegExp(r'<PropertyRef\s+Name="([^"]+)"');
    final keys = <String>[];
    for (final m in propRefRegex.allMatches(keyBlockMatch.group(1)!)) {
      final keyName = m.group(1);
      if (keyName != null && keyName.isNotEmpty) {
        keys.add(keyName);
      }
    }
    return keys;
  }

  static FieldType _resolveFieldType(String typeName) {
    final t = typeName.toLowerCase();
    if (t.contains('decimal') || t.contains('int') || t.contains('double')) return FieldType.number;
    if (t.contains('date') || t.contains('time')) return FieldType.date;
    if (t.contains('boolean')) return FieldType.boolean;
    if (t.contains('collection(') || t.contains('list<') || t.contains('structure') || t.contains('array')) return FieldType.array;
    return FieldType.text;
  }

  static String _humanize(String key) => key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}').trim();
}

