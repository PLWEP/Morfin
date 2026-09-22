import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/login/login_screen.dart';
import 'features/lobby/lobby_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IfsCloudMobileApp());
}

class IfsCloudMobileApp extends StatelessWidget {
  const IfsCloudMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IFS Cloud Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/lobby': (context) => const LobbyScreen(),
      },
    );
  }
}
