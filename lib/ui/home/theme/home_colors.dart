import 'package:flutter/material.dart';

/// Palette utilizzata dalla mappa della Home.

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

  final Color stopMarkerColor;

  final Color stopMarkerBorderColor;

  final Color userLocationHaloColor;

  final Color userLocationMarkerColor;

  final Color userLocationMarkerBorderColor;
}

/// Palette del pulsante che centra la mappa sulla posizione dell'utente.
class LocateUserButtonColors {
  const LocateUserButtonColors({
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF17226B),
  });

  final Color backgroundColor;
  final Color iconColor;
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

/// Palette complessiva della schermata Home.
class HomeColors {
  const HomeColors({
    this.snackBarBackgroundColor = const Color(0xFF061A3A),
    this.snackBarTextColor = Colors.white,
    this.mapColors = const HomeMapColors(),
    this.locateUserButtonColors = const LocateUserButtonColors(),
    this.routeSearchCardColors = const RouteSearchCardColors(),
  });

  final Color snackBarBackgroundColor;
  final Color snackBarTextColor;

  final HomeMapColors mapColors;
  final LocateUserButtonColors locateUserButtonColors;
  final RouteSearchCardColors routeSearchCardColors;
}
