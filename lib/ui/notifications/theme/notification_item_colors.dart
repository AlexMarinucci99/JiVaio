import 'package:flutter/material.dart';

/// Palette specifica associata a una categoria di notifica.
class NotificationTypeColors {
  const NotificationTypeColors({
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.iconBorderColor,
  });

  final Color iconColor;

  final Color iconBackgroundColor;

  final Color iconBorderColor;
}

/// Palette completa della singola riga del centro notifiche.
///
/// Centralizza le variazioni grafiche della riga, comprese
/// le differenze cromatiche tra categorie di notifica.
class NotificationItemColors {
  const NotificationItemColors({
    this.transparentColor = Colors.transparent,
    this.titleColor = Colors.white,
    this.readTitleColor = const Color(0xFFD7E0EF),
    this.messageColor = const Color(0xFF90A4C2),
    this.timeColor = const Color(0xFF7084A2),
    this.unreadDotColor = const Color(0xFF2D7FF9),
    this.splashColor = const Color(0x141D6FF2),
    this.highlightColor = const Color(0x0A1D6FF2),
    this.delayColors = const NotificationTypeColors(
      iconColor: Color(0xFFFFD37B),
      iconBackgroundColor: Color(0x24F59E0B),
      iconBorderColor: Color(0x3DF59E0B),
    ),
    this.tripColors = const NotificationTypeColors(
      iconColor: Color(0xFF8CB7FF),
      iconBackgroundColor: Color(0x292D7FF9),
      iconBorderColor: Color(0x3D2D7FF9),
    ),
    this.serviceUpdateColors = const NotificationTypeColors(
      iconColor: Color(0xFFFFB4A6),
      iconBackgroundColor: Color(0x29D32F2F),
      iconBorderColor: Color(0x3DD32F2F),
    ),
  });

  final Color transparentColor;

  final Color titleColor;

  final Color readTitleColor;

  final Color messageColor;

  final Color timeColor;

  final Color unreadDotColor;

  final Color splashColor;

  final Color highlightColor;

  final NotificationTypeColors delayColors;

  final NotificationTypeColors tripColors;

  final NotificationTypeColors serviceUpdateColors;
}
