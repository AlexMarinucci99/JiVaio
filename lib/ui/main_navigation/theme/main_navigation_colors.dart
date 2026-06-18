import 'package:flutter/material.dart';

import '../../core/widgets/bottom_nav_bar.dart';

/// Palette della shell principale dell'app.
///
/// Contiene i colori della bottom navigation usata da MainNavigationScreen.
/// È separata dalla View per mantenere la schermata concentrata
/// su struttura, stato del tab selezionato e composizione delle pagine.
class MainNavigationColors {
  const MainNavigationColors();

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
