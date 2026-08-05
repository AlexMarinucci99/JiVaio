import 'package:flutter/material.dart';

/// Palette grafica del pulsante che apre il centro notifiche.
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

/// Palette grafica del pannello flottante delle notifiche.
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