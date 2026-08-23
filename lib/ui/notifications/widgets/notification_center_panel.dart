import 'package:flutter/material.dart';

import '../../../domain/models/app_notification.dart';
import '../theme/notification_colors.dart';
import 'notification_item.dart';

/// Pannello flottante che visualizza il centro notifiche.
///
/// Riceve stato e callback dall'esterno, senza contenere business logic
/// o modificare direttamente i dati delle notifiche.
class NotificationCenterPanel extends StatelessWidget {
  const NotificationCenterPanel({
    super.key,
    required this.notifications,
    required this.unreadCount,
    required this.isLoading,
    required this.errorMessage,
    required this.onClose,
    required this.onMarkAllAsRead,
    required this.onNotificationTap,
    this.colors = const NotificationCenterPanelColors(),
  });

  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onClose;
  final VoidCallback onMarkAllAsRead;
  final ValueChanged<String> onNotificationTap;
  final NotificationCenterPanelColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      constraints: const BoxConstraints(maxHeight: 430),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Divider(height: 1, thickness: 1, color: colors.dividerColor),
            Flexible(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final hasUnreadNotifications = unreadCount > 0;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 15, 10, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifiche',
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.titleColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _unreadLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.subtitleColor,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Dati dimostrativi del prototipo',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.subtitleColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: hasUnreadNotifications ? onMarkAllAsRead : null,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.actionTextColor,
                    disabledForegroundColor: colors.disabledActionTextColor,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                  child: const Text(
                    'Segna tutte come lette',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: 'Chiudi notifiche',
            splashColor: colors.closeSplashColor,
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: colors.closeIconColor,
            ),
          ),
        ],
      ),
    );
  }

  String get _unreadLabel => switch (unreadCount) {
    0 => 'Nessuna notifica non letta',
    1 => '1 notifica non letta',
    _ => '$unreadCount notifiche non lette',
  };

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    final error = errorMessage;
    if (error != null) {
      return _buildMessageState(
        context,
        height: 160,
        icon: Icons.error_outline_rounded,
        iconSize: 32,
        iconColor: colors.errorIconColor,
        message: error,
        messageColor: colors.errorTextColor,
      );
    }

    if (notifications.isEmpty) {
      return _buildMessageState(
        context,
        height: 180,
        icon: Icons.notifications_none_rounded,
        iconSize: 34,
        iconColor: colors.emptyIconColor,
        title: 'Nessuna notifica',
        message: 'Gli aggiornamenti sul servizio compariranno qui.',
        messageColor: colors.emptyMessageColor,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: notifications.length,
      separatorBuilder: (_, _) =>
          Divider(height: 1, thickness: 1, color: colors.dividerColor),
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return NotificationItem(
          notification: notification,
          onTap: () => onNotificationTap(notification.id),
        );
      },
    );
  }

  Widget _buildLoadingState() => SizedBox(
    height: 150,
    child: Center(
      child: SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: colors.loadingIndicatorColor,
        ),
      ),
    ),
  );

  Widget _buildMessageState(
    BuildContext context, {
    required double height,
    required IconData icon,
    required double iconSize,
    required Color iconColor,
    required String message,
    required Color messageColor,
    String? title,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: iconColor),
              const SizedBox(height: 10),
              if (title != null) ...[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.emptyTitleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
              ],
              Text(
                message,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: messageColor,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
