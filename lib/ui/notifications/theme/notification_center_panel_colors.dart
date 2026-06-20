import 'package:flutter/material.dart';

/// Palette grafica del pannello flottante delle notifiche.
///
/// Centralizza i colori del pannello, evitando che il widget definisca
/// direttamente valori cromatici nella struttura UI.
class NotificationCenterPanelColors {
  const NotificationCenterPanelColors({
    this.backgroundColor = const Color(0xF2071733),
    this.borderColor = const Color(0x334E6A92),
    this.shadowColor = const Color(0x4D000000),
    this.titleColor = Colors.white,
    this.subtitleColor = const Color(0xFF90A4C2),
    this.actionTextColor = const Color(0xFF8CB7FF),
    this.disabledActionTextColor = const Color(0xFF60718B),
    this.closeIconColor = const Color(0xFFD7E0EF),
    this.closeSplashColor = const Color(0x14FFFFFF),
    this.dividerColor = const Color(0x244E6A92),
    this.loadingIndicatorColor = const Color(0xFF8CB7FF),
    this.emptyIconColor = const Color(0xFF7084A2),
    this.emptyTitleColor = const Color(0xFFD7E0EF),
    this.emptyMessageColor = const Color(0xFF90A4C2),
    this.errorIconColor = const Color(0xFFFFB4A6),
    this.errorTextColor = const Color(0xFFFFD2CA),
  });

  final Color backgroundColor;

  final Color borderColor;

  final Color shadowColor;

  final Color titleColor;

  final Color subtitleColor;

  final Color actionTextColor;

  final Color disabledActionTextColor;

  final Color closeIconColor;

  final Color closeSplashColor;

  final Color dividerColor;

  final Color loadingIndicatorColor;

  final Color emptyIconColor;
  final Color emptyTitleColor;
  final Color emptyMessageColor;

  final Color errorIconColor;
  final Color errorTextColor;
}
