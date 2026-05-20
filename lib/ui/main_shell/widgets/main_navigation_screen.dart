import 'package:flutter/material.dart';

import '../../core/widgets/bottom_nav_bar.dart';
import '../../home/widgets/home_placeholder_screen.dart';
import '../../lines/widgets/lines_screen.dart';
import '../../settings/widgets/settings_screen.dart';

// Schermata principale dopo login/registrazione.
// Contiene le tre sezioni principali dell'app e la navbar inferiore.
class MainNavigationScreen extends StatefulWidget{
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Stato locale della navbar.
  int _selectedIndex = 0;

  // Colori propri della main shell.
  static const _MainShellColors _colors = _MainShellColors();

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
          colors: _colors.bottomNavBarColors,
        ),
      ),
    );
  }
}

// Palette privata della shell principale.
// Qui si decide l'aspetto della navbar dentro la schermata principale.
class _MainShellColors {
  const _MainShellColors();

  final BottomNavBarColors bottomNavBarColors = const BottomNavBarColors(
    backgroundColor: Colors.white,
    shadowColor: Color(0x29000000),
    selectedColor: Color(0xFF102A6B),
    unselectedColor: Color(0xFF9AA3AD),
    selectedBackgroundColor: Color(0xFFEAF2FF),
    splashColor: Color(0x14102A6B),
    highlightColor: Color(0x0A102A6B),
  );
}