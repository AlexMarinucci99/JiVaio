import 'package:flutter/material.dart';

import '../theme/notification_colors.dart';

/// Pulsante circolare per aprire e chiudere il centro notifiche.
///
/// È uno StatelessWidget perché non conserva stato interno:
/// riceve il conteggio, lo stato di apertura e la callback dall'esterno.
class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({
    super.key,
    required this.unreadCount,
    required this.isPanelOpen,
    required this.onPressed,
    this.colors = const NotificationBellButtonColors(),
  });

  // Numero di notifiche non ancora lette.
  final int unreadCount;

  // Indica se il pannello notifiche è aperto.
  final bool isPanelOpen;

  // Callback invocata quando l'utente preme la campanella.
  final VoidCallback onPressed;

  // Palette grafica usata dal pulsante.
  final NotificationBellButtonColors colors;

  @override
  Widget build(BuildContext context) {
    final visibleUnreadCount = unreadCount > 9 ? '9+' : '$unreadCount';

    return Semantics(
      button: true,
      toggled: isPanelOpen,
      label: unreadCount == 0
          ? 'Notifiche'
          : 'Notifiche, $unreadCount non lette',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: colors.backgroundColor,
            elevation: 5,
            shadowColor: colors.shadowColor,
            shape: CircleBorder(side: BorderSide(color: colors.borderColor)),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: colors.splashColor,
              highlightColor: colors.highlightColor,
              onTap: onPressed,
              child: SizedBox.square(
                dimension: 52,
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 25,
                  color: colors.iconColor,
                ),
              ),
            ),
          ),

          // Il badge compare soltanto quando ci sono notifiche non lette.
          if (unreadCount > 0)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.badgeBackgroundColor,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: colors.badgeBorderColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  visibleUnreadCount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.badgeTextColor,
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
