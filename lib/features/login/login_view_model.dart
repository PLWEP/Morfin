import 'package:flutter/foundation.dart';
import 'login_contract.dart';
import 'models/server_config.dart';

class LoginViewModel extends ValueNotifier<LoginState> {
  LoginViewModel() : super(LoginState.initial());

  void dispatch(LoginAction action) {
    switch (action) {
      case LoginSelectServerAction(:final server):
        value = value.copyWith(selectedServer: server);

      case LoginAddServerAction(:final server):
        final updatedServers = [server, ...value.servers];
        value = value.copyWith(
          servers: updatedServers,
          selectedServer: server,
          notificationMessage: 'Added server: ${server.name}',
        );

      case LoginUpdateServerAction(:final server):
        final updatedServers = value.servers.map((s) {
          return s.id == server.id ? server : s;
        }).toList();
        final updatedSelected =
            value.selectedServer.id == server.id ? server : value.selectedServer;
        value = value.copyWith(
          servers: updatedServers,
          selectedServer: updatedSelected,
          notificationMessage: 'Updated server: ${server.name}',
        );

      case LoginDeleteServerAction(:final serverId):
        final target = value.servers.firstWhere((s) => s.id == serverId,
            orElse: () => value.selectedServer);
        final updatedServers =
            value.servers.where((s) => s.id != serverId).toList();
        final newSelected = value.selectedServer.id == serverId
            ? (updatedServers.isNotEmpty
                ? updatedServers.first
                : const ServerConfig(
                    id: 'fallback',
                    name: 'Default Server',
                    baseUrl: 'https://cloud.ifs.com',
                    realm: 'ifs',
                    clientId: 'IFS_mobile',
                    clientSecret: '',
                  ))
            : value.selectedServer;
        value = value.copyWith(
          servers: updatedServers,
          selectedServer: newSelected,
          notificationMessage: 'Deleted server: ${target.name}',
        );

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
    value = value.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    value = value.copyWith(isLoading: false, isSuccess: true);
  }
}
