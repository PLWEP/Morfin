import 'package:flutter/foundation.dart';

@immutable
class LoginState {
  final List<String> servers;
  final String selectedServer;
  final String username;
  final String password;
  final bool isObscurePassword;
  final bool isLoading;
  final bool isSuccess;
  final String? notificationMessage;

  const LoginState({
    required this.servers,
    required this.selectedServer,
    required this.username,
    required this.password,
    required this.isObscurePassword,
    required this.isLoading,
    required this.isSuccess,
    this.notificationMessage,
  });

  factory LoginState.initial() {
    const defaultServers = [
      'IFS Cloud Prod (ap-southeast-1)',
      'IFS Cloud Prod (eu-central-1)',
      'IFS Cloud Prod (us-east-1)',
      'IFS Cloud UAT / Staging',
    ];
    return const LoginState(
      servers: defaultServers,
      selectedServer: 'IFS Cloud Prod (ap-southeast-1)',
      username: 'diana.prince@operations.ifs',
      password: '••••••••••••',
      isObscurePassword: true,
      isLoading: false,
      isSuccess: false,
      notificationMessage: null,
    );
  }

  LoginState copyWith({
    List<String>? servers,
    String? selectedServer,
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
      selectedServer: selectedServer ?? this.selectedServer,
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
  final String server;
  const LoginSelectServerAction(this.server);
}

class LoginAddServerAction extends LoginAction {
  final String alias;
  final String url;
  const LoginAddServerAction(this.alias, this.url);
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
