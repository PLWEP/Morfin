import '../metadata/entity_metadata.dart';
import '../network/api_client.dart';
import '../network/api_config.dart';

class SchemaCatalogService {
  static final SchemaCatalogService instance = SchemaCatalogService._();
  SchemaCatalogService._();

  final Map<String, (DateTime, String)> _xmlCache = {};
  static const Duration _cacheTtl = Duration(minutes: 5);

  void clearCache() => _xmlCache.clear();
  void invalidateProjection(String projection) => _xmlCache.remove(projection);

  Future<String?> _getMetadataXml(String projection) async {
    final cached = _xmlCache[projection];
    if (cached != null && DateTime.now().difference(cached.$1) < _cacheTtl) {
      return cached.$2;
    }
    final url = '${ApiConfig.instance.projectionBaseUrl}/$projection.svc/\$metadata';
    final xml = await ApiClient.instance.getRawXml(url);
    if (xml != null && xml.isNotEmpty) {
      _xmlCache[projection] = (DateTime.now(), xml);
      return xml;
    }
    return null;
  }

  Future<List<EntityFieldMetadata>> fetchActionFields({
    required String projection,
    required String actionName,
  }) async {
    final xml = await _getMetadataXml(projection);
    if (xml == null) return [];

    final cleanName = actionName.split('/').last.split('?').first;
    final actRegex = RegExp('<Action\\s+Name="$cleanName"', caseSensitive: false);
    final match = actRegex.firstMatch(xml);
    if (match == null) return [];

    final actIdx = match.start;
    final actEnd = xml.indexOf('</Action>', actIdx);
    final snippet = actEnd != -1 ? xml.substring(actIdx, actEnd + 9) : xml.substring(actIdx);

    final paramRegex = RegExp(
      r'<Parameter\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)/>|<Parameter\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)></Parameter>',
    );
    final matches = paramRegex.allMatches(snippet);
    final fields = <EntityFieldMetadata>[];

    for (final m in matches) {
      final name = m.group(1) ?? m.group(4) ?? '';
      final type = m.group(2) ?? m.group(5) ?? 'Edm.String';
      final attr = m.group(3) ?? m.group(6) ?? '';
      if (name.isEmpty || name == 'FullSelection' || name == 'Selection') continue;

      fields.add(EntityFieldMetadata(
        key: name,
        label: _humanize(name),
        type: _resolveFieldType(type),
        isRequired: !attr.contains('Nullable="true"'),
      ));
    }
    return fields;
  }

  Future<List<EntityFieldMetadata>> fetchRecordFields({
    required String projection,
    required String entitySetOrName,
  }) async {
    final xml = await _getMetadataXml(projection);
    if (xml == null) return [];

    var entityName = entitySetOrName.split('/').last.split('?').first;
    if (entityName.endsWith('Set')) {
      final esRegex = RegExp('<EntitySet\\s+Name="$entityName"\\s+EntityType="([^"]+)"', caseSensitive: false);
      final esMatch = esRegex.firstMatch(xml);
      if (esMatch != null) {
        entityName = esMatch.group(1)!.split('.').last;
      } else {
        entityName = entityName.substring(0, entityName.length - 3);
      }
    }

    final etRegex = RegExp('<EntityType\\s+Name="$entityName"', caseSensitive: false);
    final etMatch = etRegex.firstMatch(xml);
    if (etMatch == null) {
      final firstEtMatch = RegExp(r'<EntityType\s+Name="([^"]+)"').firstMatch(xml);
      if (firstEtMatch == null) return [];
      entityName = firstEtMatch.group(1)!;
    }

    final etIdx = xml.indexOf(RegExp('<EntityType\\s+Name="$entityName"', caseSensitive: false));
    if (etIdx == -1) return [];
    final etEnd = xml.indexOf('</EntityType>', etIdx);
    final snippet = etEnd != -1 ? xml.substring(etIdx, etEnd + 13) : xml.substring(etIdx);

    final propRegex = RegExp(r'<Property\s+Name="([^"]+)"\s+Type="([^"]+)"([^>]*)');
    final matches = propRegex.allMatches(snippet);
    final fields = <EntityFieldMetadata>[];
    const systemFields = {'luname', 'keyref', 'objsite', 'objstate', 'objgrants'};

    for (final m in matches) {
      final name = m.group(1) ?? '';
      final type = m.group(2) ?? 'Edm.String';
      final attr = m.group(3) ?? '';
      if (name.isEmpty || systemFields.contains(name.toLowerCase())) continue;

      fields.add(EntityFieldMetadata(
        key: name,
        label: _humanize(name),
        type: _resolveFieldType(type),
        isRequired: attr.contains('Nullable="false"'),
      ));
    }
    return fields;
  }

  static FieldType _resolveFieldType(String typeName) {
    final t = typeName.toLowerCase();
    if (t.contains('decimal') || t.contains('int') || t.contains('double')) return FieldType.number;
    if (t.contains('date') || t.contains('time')) return FieldType.date;
    if (t.contains('boolean')) return FieldType.boolean;
    return FieldType.text;
  }

  static String _humanize(String key) {
    return key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}').trim();
  }
}
