import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/features/login/login_contract.dart';
import 'package:morfin/features/login/login_view_model.dart';
import 'package:morfin/features/login/models/server_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LoginViewModel Unit Tests', () {
    late LoginViewModel vm;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      vm = LoginViewModel();
    });

    tearDown(() {
      vm.dispose();
    });

    test('initial state has default values', () {
      final s = vm.value;
      expect(s.username, '');
      expect(s.password, '');
      expect(s.isObscurePassword, true);
      expect(s.isLoading, false);
      expect(s.isSuccess, false);
      expect(s.notificationMessage, isNull);
    });

    test('credential updates and password visibility toggling', () {
      vm.dispatch(const LoginUsernameChangedAction('ifsapp'));
      expect(vm.value.username, 'ifsapp');

      vm.dispatch(const LoginPasswordChangedAction('secret123'));
      expect(vm.value.password, 'secret123');

      expect(vm.value.isObscurePassword, true);
      vm.dispatch(const LoginTogglePasswordVisibilityAction());
      expect(vm.value.isObscurePassword, false);
      vm.dispatch(const LoginTogglePasswordVisibilityAction());
      expect(vm.value.isObscurePassword, true);
    });

    test('server management actions: add, update, select, and delete', () {
      const s1 = ServerConfig(
        id: 'srv-1',
        name: 'Demo Cloud',
        baseUrl: 'https://demo.ifs.cloud',
        realm: 'demo',
        clientId: 'morfin',
        clientSecret: '',
      );

      const s2 = ServerConfig(
        id: 'srv-2',
        name: 'UAT Cloud',
        baseUrl: 'https://uat.ifs.cloud',
        realm: 'uat',
        clientId: 'morfin',
        clientSecret: '',
      );

      // Add
      vm.dispatch(const LoginAddServerAction(s1));
      expect(vm.value.servers.length, 1);
      expect(vm.value.selectedServer?.id, 'srv-1');
      expect(vm.value.notificationMessage, 'Added server: Demo Cloud');

      vm.dispatch(const LoginAddServerAction(s2));
      expect(vm.value.servers.length, 2);
      expect(vm.value.selectedServer?.id, 'srv-2');

      // Update
      final updatedS1 = s1.copyWith(name: 'Demo Cloud Updated');
      vm.dispatch(LoginUpdateServerAction(updatedS1));
      expect(vm.value.servers.firstWhere((s) => s.id == 'srv-1').name, 'Demo Cloud Updated');

      // Select
      vm.dispatch(const LoginSelectServerAction(s1));
      expect(vm.value.selectedServer?.id, 'srv-1');

      // Delete
      vm.dispatch(const LoginDeleteServerAction('srv-1'));
      expect(vm.value.servers.length, 1);
      expect(vm.value.selectedServer?.id, 'srv-2');

      // Consume notification
      vm.dispatch(const LoginConsumeNotificationAction());
      expect(vm.value.notificationMessage, isNull);
    });

    test('submit validation triggers proper user notification', () {
      // 1. Without servers
      vm.dispatch(const LoginSubmitAction());
      expect(vm.value.notificationMessage, 'Please add and select a server environment first.');

      // 2. With server but empty credentials
      const s1 = ServerConfig(
        id: 'srv-1',
        name: 'Demo Cloud',
        baseUrl: 'https://demo.ifs.cloud',
        realm: 'demo',
        clientId: 'morfin',
        clientSecret: '',
      );
      vm.dispatch(const LoginAddServerAction(s1));
      vm.dispatch(const LoginConsumeNotificationAction());

      vm.dispatch(const LoginSubmitAction());
      expect(vm.value.notificationMessage, 'Please enter both username and password.');
    });
  });
}
