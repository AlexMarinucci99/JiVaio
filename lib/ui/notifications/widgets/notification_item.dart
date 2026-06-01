import 'package:flutter/material.dart';

import '../../../domain/models/app_notification.dart';
import '../theme/notification_item_colors.dart';

/// Riga riutilizzabile che visualizza una singola notifica.
///
/// Il widget gestisce esclusivamente il rendering.
/// Lo stato letto/non letto viene ricevuto dal modello.
/// Il tap viene inoltrato al componente padre tramite callback.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    this.colors = const NotificationItemColors(),
  });

  // Dato immutabile da rappresentare.
  final AppNotification notification;

  // Callback eseguita quando l'utente seleziona la notifica.
  final VoidCallback onTap;

  // Palette grafica separata dalla struttura del widget.
  final NotificationItemColors colors;

  @override
  Widget build(BuildContext context) {
    final visual = _visualForType(notification.type);

    return Material(
      color: colors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: colors.splashColor,
        highlightColor: colors.highlightColor,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(icon: visual.icon, colors: visual.colors),
              const SizedBox(width: 12),
              Expanded(
                child: _NotificationContent(
                  notification: notification,
                  colors: colors,
                ),
              ),
              const SizedBox(width: 10),
              _UnreadIndicator(
                isVisible: !notification.isRead,
                color: colors.unreadDotColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _NotificationVisual _visualForType(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.delay:
        return _NotificationVisual(
          icon: Icons.schedule_rounded,
          colors: colors.delayColors,
        );

      case AppNotificationType.trip:
        return _NotificationVisual(
          icon: Icons.notifications_active_rounded,
          colors: colors.tripColors,
        );

      case AppNotificationType.serviceUpdate:
        return _NotificationVisual(
          icon: Icons.alt_route_rounded,
          colors: colors.serviceUpdateColors,
        );
    }
  }
}

/// Box quadrato con icona associata alla categoria della notifica.
class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.icon, required this.colors});

  final IconData icon;
  final NotificationTypeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.iconBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.iconBorderColor),
      ),
      child: Icon(icon, color: colors.iconColor, size: 19),
    );
  }
}

/// Testi della notifica: titolo, orario relativo e descrizione.
class _NotificationContent extends StatelessWidget {
  const _NotificationContent({
    required this.notification,
    required this.colors,
  });

  final AppNotification notification;
  final NotificationItemColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: notification.isRead
                      ? colors.readTitleColor
                      : colors.titleColor,
                  fontSize: 13.5,
                  fontWeight: notification.isRead
                      ? FontWeight.w500
                      : FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _relativeTimeLabel(notification.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.timeColor,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          notification.message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.messageColor,
            fontSize: 11.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  String _relativeTimeLabel(DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inSeconds < 45) {
      return 'Adesso';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return minutes == 1 ? '1 min fa' : '$minutes min fa';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return hours == 1 ? '1 ora fa' : '$hours ore fa';
    }

    final days = difference.inDays;
    return days == 1 ? 'Ieri' : '$days gg fa';
  }
}

/// Pallino azzurro visualizzato soltanto per le notifiche non lette.
class _UnreadIndicator extends StatelessWidget {
  const _UnreadIndicator({required this.isVisible, required this.color});

  final bool isVisible;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isVisible ? 1 : 0,
      child: Container(
        width: 9,
        height: 9,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

/// Configurazione grafica derivata dalla categoria della notifica.
class _NotificationVisual {
  const _NotificationVisual({required this.icon, required this.colors});

  final IconData icon;
  final NotificationTypeColors colors;
}
