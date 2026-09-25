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
  static const _keyServers = 'app_server_configs';
  static const _keySelectedServerId = 'app_selected_server_id';

  const LocalStorageService(this._prefs);

  String? getThemeMode() => _prefs.getString(_keyTheme);

  Future<bool> saveThemeMode(String mode) => _prefs.setString(_keyTheme, mode);

  List<ServerConfig>? getServers() {
    final raw = _prefs.getString(_keyServers);
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => ServerConfig.fromJson(item as Map<String, dynamic>)).toList();
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

  Future<void> clearAll() async {
    await _prefs.remove(_keyTheme);
    await _prefs.remove(_keyServers);
    await _prefs.remove(_keySelectedServerId);
  }
}
