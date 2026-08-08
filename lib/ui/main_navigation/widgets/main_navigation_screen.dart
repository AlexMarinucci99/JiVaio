import 'package:flutter/material.dart';

import '../../../domain/models/app_user.dart';
import '../../home/widgets/home_screen.dart';
import '../../lines/widgets/lines_screen.dart';
import '../../settings/widgets/settings_screen.dart';
import 'bottom_nav_bar.dart';

/// Coordina le tre sezioni principali tramite la barra inferiore.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final AppUser? user;
  final Future<void> Function() onLogout;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const HomeScreen(key: PageStorageKey('home-screen')),
    const LinesScreen(key: PageStorageKey('lines-screen')),
    SettingsScreen(
      key: const PageStorageKey('settings-screen'),
      user: widget.user,
      onLogout: widget.onLogout,
    ),
  ];

  void _onItemSelected(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}
