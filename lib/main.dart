import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_client.dart';
import 'core/network/api_config.dart';
import 'core/services/app_navigator.dart';
import 'core/storage/local_storage_service.dart';
import 'features/login/login_screen.dart';
import 'features/shell/main_shell_screen.dart';
import 'features/splash/splash_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorageService(prefs);
  storage.clearLegacyMockData();
  final activeServer = storage.getActiveServer();
  if (activeServer != null) {
    ApiConfig.instance.setServer(activeServer);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MorfinApp(),
    ),
  );
}

class MorfinApp extends ConsumerStatefulWidget {
  const MorfinApp({super.key});

  @override
  ConsumerState<MorfinApp> createState() => _MorfinAppState();
}

class _MorfinAppState extends ConsumerState<MorfinApp> {
  bool _isSessionDialogShowing = false;

  @override
  void initState() {
    super.initState();
    ApiClient.instance.onSessionExpired.addListener(_handleSessionExpired);
  }

  @override
  void dispose() {
    ApiClient.instance.onSessionExpired.removeListener(_handleSessionExpired);
    super.dispose();
  }

  void _handleSessionExpired() {
    if (!ApiClient.instance.onSessionExpired.value || _isSessionDialogShowing) return;

    final context = AppNavigator.currentContext;
    if (context == null) return;

    _isSessionDialogShowing = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.lock_clock_outlined, color: Colors.orangeAccent),
              SizedBox(width: 8),
              Text('Sesi Berakhir'),
            ],
          ),
          content: const Text(
            'Sesi Anda telah kedaluwarsa atau tidak valid. Silakan login kembali untuk melanjutkan.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _isSessionDialogShowing = false;
                ApiClient.instance.resetSessionExpired();
                Navigator.of(dialogCtx).pop();
                AppNavigator.pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text('Login Kembali'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      title: 'Morfin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/lobby': (context) => const MainShellScreen(initialIndex: 0),
      },
    );
  }
}

