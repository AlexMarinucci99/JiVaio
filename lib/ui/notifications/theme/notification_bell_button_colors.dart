import 'package:flutter/material.dart';

/// Palette grafica del pulsante che apre il centro notifiche.
///
/// Il widget riceve questa configurazione dall'esterno:
/// in questo modo i colori possono essere modificati
/// senza intervenire sulla struttura o sulla logica del componente.
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

  // Sfondo del pulsante circolare.
  final Color backgroundColor;

  // Bordo esterno del pulsante.
  final Color borderColor;

  // Colore dell'icona della campanella.
  final Color iconColor;

  // Sfondo del badge numerico.
  final Color badgeBackgroundColor;

  // Bordo del badge numerico.
  final Color badgeBorderColor;

  // Colore del numero nel badge.
  final Color badgeTextColor;

  // Ombra esterna del pulsante.
  final Color shadowColor;

  // Effetto visivo durante il tap.
  final Color splashColor;

  // Effetto visivo durante la pressione prolungata.
  final Color highlightColor;
}
