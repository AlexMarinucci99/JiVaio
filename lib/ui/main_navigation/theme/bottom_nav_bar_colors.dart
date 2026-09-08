import 'package:flutter/material.dart';

/// Palette cromatica della barra di navigazione principale.
class BottomNavBarColors {
  const BottomNavBarColors({
    this.backgroundColor = const Color.fromARGB(255, 4, 0, 49),
    this.borderColor = const Color(0x80FFFFFF),
    this.selectedColor = const Color.fromARGB(255, 20, 102, 150),
    this.unselectedColor = const Color.fromARGB(255, 198, 202, 206),
    this.selectedBackgroundColor = const Color(0xFFEAF2FF),
    this.splashColor = const Color(0x14102A6B),
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedBackgroundColor;
  final Color splashColor;
}
