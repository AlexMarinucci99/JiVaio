import 'package:flutter/material.dart';

import '../../../domain/models/app_notification.dart';
import '../theme/notification_colors.dart';

/// Riga riutilizzabile che visualizza una singola notifica.
///
/// Riceve il modello da rappresentare e inoltra il tap
/// al componente padre tramite [onTap].
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    this.colors = const NotificationItemColors(),
  });

  final AppNotification notification;
  final VoidCallback onTap;
  final NotificationItemColors colors;

  @override
  Widget build(BuildContext context) {
    final (icon, iconColors) = switch (notification.type) {
      AppNotificationType.delay => (Icons.schedule_rounded, colors.delayColors),
      AppNotificationType.trip => (
        Icons.notifications_active_rounded,
        colors.tripColors,
      ),
      AppNotificationType.serviceUpdate => (
        Icons.alt_route_rounded,
        colors.serviceUpdateColors,
      ),
    };

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
              _buildIcon(icon, iconColors),
              const SizedBox(width: 12),
              Expanded(child: _buildContent(context)),
              const SizedBox(width: 19),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, NotificationTypeColors iconColors) =>
      Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: iconColors.iconBackgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: iconColors.iconBorderColor),
        ),
        child: Icon(icon, color: iconColors.iconColor, size: 19),
      );

  Widget _buildContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: textTheme.bodyLarge?.copyWith(
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
              style: textTheme.bodySmall?.copyWith(
                color: colors.timeColor,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          notification.message,
          style: textTheme.bodySmall?.copyWith(
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
