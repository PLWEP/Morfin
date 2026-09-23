import 'package:flutter/material.dart';
import '../lobby/lobby_screen.dart';
import '../menu/menu_screen.dart';
import '../settings/settings_screen.dart';
import 'components/app_bottom_nav.dart';

class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({super.key, this.initialIndex = 1});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MenuScreen(),
          LobbyScreen(showBottomNav: false),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
