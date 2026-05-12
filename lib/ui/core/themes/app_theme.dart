import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF061A3A)),
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
    );
  }
}
