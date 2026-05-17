import 'package:flutter/material.dart';

import '../../core/widgets/bottom_nav_bar.dart';
import '../../home/widgets/home_placeholder_screen.dart';
import '../../lines/widgets/lines_screen.dart';
import '../../settings/widgets/settings_screen.dart';

// Schermata principale dopo login/registrazione.
// Contiene le tre sezioni principali dell'app e la navbar inferiore.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  // Stato locale della navbar.
  int _selectedIndex = 0;

  // Schermate principali dell'app.
  // IndexedStack mantiene vive le schermate quando cambi tab.
  static const List<Widget> _pages = [
    HomePlaceholderScreen(key: PageStorageKey<String>('home-search-screen')),
    LinesScreen(key: PageStorageKey<String>('lines-screen')),
    SettingsScreen(key: PageStorageKey<String>('settings-screen')),
  ];

  // Cambio tab navbar.
  void _onItemSelected(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Permette alla navbar flottante di sovrapporsi leggermente al body.
      extendBody: true,

      // Cambia schermata in base al tab selezionato.
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // Navbar inferiore.
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
