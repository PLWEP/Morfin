import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_config.dart';
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

class MorfinApp extends ConsumerWidget {
  const MorfinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'IFS Cloud Mobile',
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
