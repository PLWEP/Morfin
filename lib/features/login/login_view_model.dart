import 'package:flutter/foundation.dart';
import 'login_contract.dart';

class LoginViewModel extends ValueNotifier<LoginState> {
  LoginViewModel() : super(LoginState.initial());

  void dispatch(LoginAction action) {
    switch (action) {
      case LoginSelectServerAction(:final server):
        value = value.copyWith(selectedServer: server);

      case LoginAddServerAction(:final alias, :final url):
        final updatedServers = [alias, ...value.servers];
        value = value.copyWith(
          servers: updatedServers,
          selectedServer: alias,
          notificationMessage: 'Added server: $alias ($url)',
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
