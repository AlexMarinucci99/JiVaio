import 'package:flutter/material.dart';

/// Palette utilizzata dalla mappa della Home.
///
/// Contiene esclusivamente colori legati al rendering della mappa:
/// sfondo di fallback, fermate e posizione dell'utente.
class HomeMapColors {
  const HomeMapColors({
    this.fallbackBackgroundColor = const Color(0xFFF7F9FC),
    this.stopMarkerColor = const Color(0xFF0B7A55),
    this.stopMarkerBorderColor = Colors.white,
    this.userLocationHaloColor = const Color(0x332D7FF9),
    this.userLocationMarkerColor = const Color(0xFF2D7FF9),
    this.userLocationMarkerBorderColor = Colors.white,
  });

  final Color fallbackBackgroundColor;

  /// Colore interno dei marker delle fermate.
  final Color stopMarkerColor;

  /// Colore del bordo dei marker delle fermate.
  final Color stopMarkerBorderColor;

  /// Colore dell'alone mostrato attorno alla posizione dell'utente.
  final Color userLocationHaloColor;

  /// Colore interno del marker della posizione dell'utente.
  final Color userLocationMarkerColor;

  /// Colore del bordo del marker della posizione dell'utente.
  final Color userLocationMarkerBorderColor;
}

/// Palette del pulsante che centra la mappa sulla posizione dell'utente.
class LocateUserButtonColors {
  const LocateUserButtonColors({
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF17226B),
    this.progressColor = const Color(0xFF17226B),
    this.shadowColor = const Color(0x26000000),
  });

  final Color backgroundColor;
  final Color iconColor;
  final Color progressColor;
  final Color shadowColor;
}

/// Palette della card utilizzata per inserire partenza e destinazione.
class RouteSearchCardColors {
  const RouteSearchCardColors({
    this.cardColor = const Color.fromARGB(255, 209, 208, 208),
    this.textColor = const Color(0xFF20232D),
    this.labelColor = const Color(0xFF5C5F6D),
    this.dividerColor = const Color(0xFFE7E8EE),
    this.activeButtonColor = const Color(0xFF17226B),
    this.activeButtonTextColor = Colors.white,
    this.inactiveButtonColor = const Color(0xFFE9E7F0),
    this.inactiveTextColor = const Color(0xFF4F4D59),
    this.iconBackgroundColor = const Color.fromARGB(255, 245, 245, 245),
    this.iconColor = const Color(0xFF59609A),
    this.swapIconColor = const Color(0xFF59609A),
    this.hintColor = const Color(0xFF777986),
  });

  final Color cardColor;
  final Color textColor;
  final Color labelColor;
  final Color dividerColor;

  final Color activeButtonColor;
  final Color activeButtonTextColor;

  final Color inactiveButtonColor;
  final Color inactiveTextColor;

  final Color iconBackgroundColor;
  final Color iconColor;
  final Color swapIconColor;
  final Color hintColor;
}

/// Palette dei dialog mostrati dalla Home.
class HomeAlertDialogColors {
  const HomeAlertDialogColors({
    this.backgroundColor = Colors.white,
    this.primaryTextColor = const Color(0xFF20232D),
    this.secondaryTextColor = const Color(0xFF5C5F6D),
    this.accentColor = const Color(0xFF17226B),
    this.barrierColor = const Color(0x52000000),
  });

  final Color backgroundColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final Color barrierColor;
}

/// Palette complessiva della schermata Home.
///
/// Aggrega le palette dei componenti interni, mantenendo la configurazione
/// grafica della feature in un unico file.
class HomeColors {
  const HomeColors({
    this.overlayColorStrong = const Color(0x8F0B0F3A),
    this.overlayColorSoft = const Color(0x330B0F3A),
    this.overlayColorTransparent = Colors.transparent,
    this.snackBarBackgroundColor = const Color(0xFF061A3A),
    this.snackBarTextColor = Colors.white,
    this.mapColors = const HomeMapColors(),
    this.locateUserButtonColors = const LocateUserButtonColors(),
    this.routeSearchCardColors = const RouteSearchCardColors(),
    this.alertDialogColors = const HomeAlertDialogColors(),
  });

  final Color overlayColorStrong;
  final Color overlayColorSoft;
  final Color overlayColorTransparent;

  final Color snackBarBackgroundColor;
  final Color snackBarTextColor;

  final HomeMapColors mapColors;
  final LocateUserButtonColors locateUserButtonColors;
  final RouteSearchCardColors routeSearchCardColors;
  final HomeAlertDialogColors alertDialogColors;
}
