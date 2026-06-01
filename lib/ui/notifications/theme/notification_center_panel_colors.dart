import 'package:flutter/material.dart';

/// Palette grafica del pannello flottante delle notifiche.
///
/// Nessun colore del pannello viene definito direttamente
/// nel relativo widget.
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

  // Sfondo del pannello.
  final Color backgroundColor;

  // Bordo esterno del pannello.
  final Color borderColor;

  // Ombra esterna.
  final Color shadowColor;

  // Titolo principale.
  final Color titleColor;

  // Testo secondario, ad esempio il numero di notifiche non lette.
  final Color subtitleColor;

  // Colore del comando attivo "Segna tutte come lette".
  final Color actionTextColor;

  // Colore dello stesso comando quando non è utilizzabile.
  final Color disabledActionTextColor;

  // Colore dell'icona di chiusura.
  final Color closeIconColor;

  // Effetto visivo durante il tap sulla chiusura.
  final Color closeSplashColor;

  // Separatore tra le notifiche.
  final Color dividerColor;

  // Indicatore di caricamento.
  final Color loadingIndicatorColor;

  // Stato vuoto.
  final Color emptyIconColor;
  final Color emptyTitleColor;
  final Color emptyMessageColor;

  // Stato di errore.
  final Color errorIconColor;
  final Color errorTextColor;
}
