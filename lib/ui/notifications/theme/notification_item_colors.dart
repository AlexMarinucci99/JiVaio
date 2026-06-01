import 'package:flutter/material.dart';

/// Palette specifica associata a una categoria di notifica.
class NotificationTypeColors {
  const NotificationTypeColors({
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.iconBorderColor,
  });

  // Colore dell'icona.
  final Color iconColor;

  // Sfondo del box che contiene l'icona.
  final Color iconBackgroundColor;

  // Bordo del box che contiene l'icona.
  final Color iconBorderColor;
}

/// Palette completa della singola riga del centro notifiche.
///
/// Nessun colore viene definito direttamente nel widget:
/// tutte le variazioni grafiche sono modificabili da questo file.
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

  // Colore trasparente usato dal Material della riga.
  final Color transparentColor;

  // Titolo di una notifica non letta.
  final Color titleColor;

  // Titolo leggermente attenuato di una notifica già letta.
  final Color readTitleColor;

  // Testo descrittivo.
  final Color messageColor;

  // Etichetta temporale.
  final Color timeColor;

  // Pallino che identifica una notifica non letta.
  final Color unreadDotColor;

  // Effetto visivo durante il tap.
  final Color splashColor;

  // Effetto visivo durante la pressione.
  final Color highlightColor;

  // Colori delle notifiche relative ai ritardi.
  final NotificationTypeColors delayColors;

  // Colori delle notifiche mostrate durante il viaggio.
  final NotificationTypeColors tripColors;

  // Colori degli aggiornamenti di orario o viabilità.
  final NotificationTypeColors serviceUpdateColors;
}
