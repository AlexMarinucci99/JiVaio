import 'package:flutter/material.dart';

import '../theme/notification_colors.dart';

/// Pulsante circolare per aprire e chiudere il centro notifiche.
class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({
    super.key,
    required this.unreadCount,
    required this.isPanelOpen,
    required this.onPressed,
    this.colors = const NotificationBellButtonColors(),
  });

  final int unreadCount;
  final bool isPanelOpen;
  final VoidCallback onPressed;
  final NotificationBellButtonColors colors;

  @override
  Widget build(BuildContext context) {
    final hasUnreadNotifications = unreadCount > 0;
    final visibleUnreadCount = unreadCount > 9 ? '9+' : '$unreadCount';

    return Semantics(
      button: true,
      toggled: isPanelOpen,
      label: hasUnreadNotifications
          ? 'Notifiche, $unreadCount non lette'
          : 'Notifiche',
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

          if (hasUnreadNotifications)
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
