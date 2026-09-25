import 'package:flutter/foundation.dart';
import 'models/server_config.dart';

@immutable
class LoginState {
  final List<ServerConfig> servers;
  final ServerConfig? selectedServer;
  final String username;
  final String password;
  final bool isObscurePassword;
  final bool isLoading;
  final bool isSuccess;
  final String? notificationMessage;

  const LoginState({
    required this.servers,
    this.selectedServer,
    required this.username,
    required this.password,
    required this.isObscurePassword,
    required this.isLoading,
    required this.isSuccess,
    this.notificationMessage,
  });

  factory LoginState.initial() {
    return const LoginState(
      servers: [],
      selectedServer: null,
      username: '',
      password: '',
      isObscurePassword: true,
      isLoading: false,
      isSuccess: false,
      notificationMessage: null,
    );
  }

  LoginState copyWith({
    List<ServerConfig>? servers,
    ServerConfig? selectedServer,
    bool clearSelectedServer = false,
    String? username,
    String? password,
    bool? isObscurePassword,
    bool? isLoading,
    bool? isSuccess,
    String? notificationMessage,
    bool clearNotification = false,
  }) {
    return LoginState(
      servers: servers ?? this.servers,
      selectedServer: clearSelectedServer ? null : (selectedServer ?? this.selectedServer),
      username: username ?? this.username,
      password: password ?? this.password,
      isObscurePassword: isObscurePassword ?? this.isObscurePassword,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      notificationMessage: clearNotification ? null : (notificationMessage ?? this.notificationMessage),
    );
  }
}

sealed class LoginAction {
  const LoginAction();
}

class LoginSelectServerAction extends LoginAction {
  final ServerConfig server;
  const LoginSelectServerAction(this.server);
}

class LoginAddServerAction extends LoginAction {
  final ServerConfig server;
  const LoginAddServerAction(this.server);
}

class LoginUpdateServerAction extends LoginAction {
  final ServerConfig server;
  const LoginUpdateServerAction(this.server);
}

class LoginDeleteServerAction extends LoginAction {
  final String serverId;
  const LoginDeleteServerAction(this.serverId);
}

class LoginUsernameChangedAction extends LoginAction {
  final String username;
  const LoginUsernameChangedAction(this.username);
}

class LoginPasswordChangedAction extends LoginAction {
  final String password;
  const LoginPasswordChangedAction(this.password);
}

class LoginTogglePasswordVisibilityAction extends LoginAction {
  const LoginTogglePasswordVisibilityAction();
}

class LoginSubmitAction extends LoginAction {
  const LoginSubmitAction();
}

class LoginConsumeNotificationAction extends LoginAction {
  const LoginConsumeNotificationAction();
}
