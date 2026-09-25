import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../../core/storage/local_storage_service.dart';
import 'login_contract.dart';
import 'models/server_config.dart';

class LoginViewModel extends ValueNotifier<LoginState> {
  LoginViewModel() : super(LoginState.initial()) {
    _loadStoredServers();
  }

  Future<void> _loadStoredServers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageService(prefs);
      final savedServers = storage.getServers();
      final selectedId = storage.getSelectedServerId();

      if (savedServers != null && savedServers.isNotEmpty) {
        final active = selectedId != null
            ? savedServers.firstWhere((s) => s.id == selectedId, orElse: () => savedServers.first)
            : savedServers.first;

        value = value.copyWith(servers: savedServers, selectedServer: active);
        ApiConfig.instance.setServer(active);
      } else {
        value = value.copyWith(servers: [], clearSelectedServer: true);
      }
    } catch (_) {}
  }

  Future<void> _persist(List<ServerConfig> servers, ServerConfig? selected) async {
    if (selected != null) {
      ApiConfig.instance.setServer(selected);
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageService(prefs);
      await storage.saveServers(servers);
      if (selected != null) {
        await storage.saveSelectedServerId(selected.id);
      }
    } catch (_) {}
  }

  void dispatch(LoginAction action) {
    switch (action) {
      case LoginSelectServerAction(:final server):
        value = value.copyWith(selectedServer: server);
        _persist(value.servers, server);

      case LoginAddServerAction(:final server):
        final updatedServers = [server, ...value.servers];
        value = value.copyWith(
          servers: updatedServers,
          selectedServer: server,
          notificationMessage: 'Added server: ${server.name}',
        );
        _persist(updatedServers, server);

      case LoginUpdateServerAction(:final server):
        final updatedServers = value.servers.map((s) => s.id == server.id ? server : s).toList();
        final updatedSelected = value.selectedServer?.id == server.id ? server : value.selectedServer;
        value = value.copyWith(
          servers: updatedServers,
          selectedServer: updatedSelected,
          notificationMessage: 'Updated server: ${server.name}',
        );
        _persist(updatedServers, updatedSelected);

      case LoginDeleteServerAction(:final serverId):
        final target = value.servers.where((s) => s.id == serverId).firstOrNull;
        final updatedServers = value.servers.where((s) => s.id != serverId).toList();
        final newSelected = value.selectedServer?.id == serverId
            ? (updatedServers.isNotEmpty ? updatedServers.first : null)
            : value.selectedServer;
        value = value.copyWith(
          servers: updatedServers,
          selectedServer: newSelected,
          clearSelectedServer: newSelected == null,
          notificationMessage: target != null ? 'Deleted server: ${target.name}' : 'Server deleted',
        );
        _persist(updatedServers, newSelected);

      case LoginUsernameChangedAction(:final username):
        value = value.copyWith(username: username);

      case LoginPasswordChangedAction(:final password):
        value = value.copyWith(password: password);

      case LoginTogglePasswordVisibilityAction():
        value = value.copyWith(isObscurePassword: !value.isObscurePassword);

      case LoginSubmitAction():
        _executeLogin();

      case LoginConsumeNotificationAction():
        value = value.copyWith(clearNotification: true);
    }
  }

  Future<void> _executeLogin() async {
    if (value.selectedServer == null || value.servers.isEmpty) {
      value = value.copyWith(
        isLoading: false,
        notificationMessage: 'Please add and select a server environment first.',
      );
      return;
    }

    final username = value.username.trim();
    final password = value.password.trim();

    if (username.isEmpty || password.isEmpty) {
      value = value.copyWith(
        isLoading: false,
        notificationMessage: 'Please enter both username and password.',
      );
      return;
    }

    value = value.copyWith(isLoading: true);
    final success = await ApiClient.instance.authenticateOAuth(
      username: username,
      password: password,
    );

    if (success) {
      value = value.copyWith(isLoading: false, isSuccess: true);
    } else {
      value = value.copyWith(
        isLoading: false,
        isSuccess: false,
        notificationMessage: ApiClient.instance.lastAuthError ??
            'Authentication failed. Please verify credentials or server URL.',
      );
    }
  }
}
