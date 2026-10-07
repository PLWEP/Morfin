import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/login/models/server_config.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in ProviderScope');
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

class LocalStorageService {
  final SharedPreferences _prefs;

  static const _keyTheme = 'app_theme_mode';
  static const _keyServers = 'app_user_servers_v2';
  static const _keySelectedServerId = 'app_user_selected_server_id_v2';

  const LocalStorageService(this._prefs);

  void clearLegacyMockData() {
    _prefs.remove('app_server_configs');
    _prefs.remove('app_selected_server_id');
  }

  String? getThemeMode() => _prefs.getString(_keyTheme);

  Future<bool> saveThemeMode(String mode) => _prefs.setString(_keyTheme, mode);

  List<ServerConfig>? getServers() {
    clearLegacyMockData();
    final raw = _prefs.getString(_keyServers);
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final valid = list
          .map((item) => ServerConfig.fromJson(item as Map<String, dynamic>))
          .where((s) => !s.id.startsWith('srv-prod-') && !s.id.startsWith('srv-uat-'))
          .toList();
      return valid.isNotEmpty ? valid : null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveServers(List<ServerConfig> servers) {
    final encoded = jsonEncode(servers.map((s) => s.toJson()).toList());
    return _prefs.setString(_keyServers, encoded);
  }

  String? getSelectedServerId() => _prefs.getString(_keySelectedServerId);

  Future<bool> saveSelectedServerId(String id) => _prefs.setString(_keySelectedServerId, id);

  ServerConfig? getActiveServer() {
    final servers = getServers();
    if (servers == null || servers.isEmpty) return null;
    final selectedId = getSelectedServerId();
    if (selectedId != null) {
      return servers.firstWhere((s) => s.id == selectedId, orElse: () => servers.first);
    }
    return servers.first;
  }

  static const _keyIndustrialMode = 'app_industrial_mode_v1';
  static const _keySoundFeedback = 'app_sound_feedback_v1';

  bool getIndustrialMode() => _prefs.getBool(_keyIndustrialMode) ?? false;
  Future<bool> saveIndustrialMode(bool enabled) => _prefs.setBool(_keyIndustrialMode, enabled);

  bool getSoundFeedback() => _prefs.getBool(_keySoundFeedback) ?? true;
  Future<bool> saveSoundFeedback(bool enabled) => _prefs.setBool(_keySoundFeedback, enabled);

  String? getSchemaHash(String key) => _prefs.getString('schema_hash_$key');
  Future<bool> saveSchemaHash(String key, String hash) => _prefs.setString('schema_hash_$key', hash);

  static const _keyFavorites = 'app_favorite_menu_ids_v1';

  List<String> getFavoriteMenuIds() => _prefs.getStringList(_keyFavorites) ?? [];

  Future<bool> saveFavoriteMenuIds(List<String> ids) => _prefs.setStringList(_keyFavorites, ids);

  Future<bool> toggleFavoriteMenuId(String id) async {
    final current = getFavoriteMenuIds().toList();
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    return saveFavoriteMenuIds(current);
  }

  Future<void> clearAll() async {
    clearLegacyMockData();
    await _prefs.remove(_keyTheme);
    await _prefs.remove(_keyServers);
    await _prefs.remove(_keySelectedServerId);
    await _prefs.remove(_keyFavorites);
  }
}
