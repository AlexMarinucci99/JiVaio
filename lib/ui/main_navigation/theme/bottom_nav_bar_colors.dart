import 'package:flutter/material.dart';

/// Palette cromatica della barra di navigazione principale.
class BottomNavBarColors {
  const BottomNavBarColors({
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0x80FFFFFF),
    this.selectedColor = const Color(0xFF102A6B),
    this.unselectedColor = const Color(0xFF9AA3AD),
    this.selectedBackgroundColor = const Color(0xFFEAF2FF),
    this.selectedGlowColor = const Color(0x33102A6B),
    this.splashColor = const Color(0x14102A6B),
    this.highlightColor = const Color(0x0A102A6B),
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedBackgroundColor;
  final Color selectedGlowColor;
  final Color splashColor;
  final Color highlightColor;
}
