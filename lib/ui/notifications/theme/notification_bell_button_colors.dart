import 'package:flutter/material.dart';

/// Palette grafica del pulsante che apre il centro notifiche.
///
/// Il widget riceve questa configurazione dall'esterno, così i colori
/// possono essere modificati senza intervenire sulla struttura del componente.
class NotificationBellButtonColors {
  const NotificationBellButtonColors({
    this.backgroundColor = const Color(0xCCFFFFFF),
    this.borderColor = const Color(0x80FFFFFF),
    this.iconColor = const Color(0xFF17226B),
    this.badgeBackgroundColor = const Color(0xFF2D7FF9),
    this.badgeBorderColor = Colors.white,
    this.badgeTextColor = Colors.white,
    this.shadowColor = const Color(0x26000000),
    this.splashColor = const Color(0x1417226B),
    this.highlightColor = const Color(0x0A17226B),
  });

  final Color backgroundColor;

  final Color borderColor;

  final Color iconColor;

  final Color badgeBackgroundColor;

  final Color badgeBorderColor;

  final Color badgeTextColor;

  final Color shadowColor;

  final Color splashColor;

  final Color highlightColor;
}
