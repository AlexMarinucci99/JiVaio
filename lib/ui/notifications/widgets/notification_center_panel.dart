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
    this.itemColors = const NotificationItemColors(),
  });

  /// Elenco delle notifiche già ordinato dal ViewModel.
  final List<AppNotification> notifications;

  /// Numero di notifiche non ancora lette.
  final int unreadCount;

  /// Indica se il caricamento iniziale è in corso.
  final bool isLoading;

  /// Messaggio di errore esposto dal ViewModel, se presente.
  final String? errorMessage;

  /// Callback invocata per chiudere il pannello.
  final VoidCallback onClose;

  /// Callback invocata per segnare tutte le notifiche come lette.
  final VoidCallback onMarkAllAsRead;

  /// Callback invocata quando l'utente seleziona una notifica.
  final ValueChanged<String> onNotificationTap;

  /// Palette del pannello.
  final NotificationCenterPanelColors colors;

  /// Palette delle righe interne.
  final NotificationItemColors itemColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      constraints: const BoxConstraints(maxHeight: 430),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NotificationPanelHeader(
              unreadCount: unreadCount,
              onClose: onClose,
              onMarkAllAsRead: onMarkAllAsRead,
              colors: colors,
            ),
            Divider(height: 1, thickness: 1, color: colors.dividerColor),
            Flexible(
              child: _NotificationPanelBody(
                notifications: notifications,
                isLoading: isLoading,
                errorMessage: errorMessage,
                onNotificationTap: onNotificationTap,
                colors: colors,
                itemColors: itemColors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationPanelHeader extends StatelessWidget {
  const _NotificationPanelHeader({
    required this.unreadCount,
    required this.onClose,
    required this.onMarkAllAsRead,
    required this.colors,
  });

  final int unreadCount;
  final VoidCallback onClose;
  final VoidCallback onMarkAllAsRead;
  final NotificationCenterPanelColors colors;

  @override
  Widget build(BuildContext context) {
    final hasUnreadNotifications = unreadCount > 0;

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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.titleColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _unreadLabel(unreadCount),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.subtitleColor,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Dati dimostrativi del prototipo',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  String _unreadLabel(int unreadCount) => switch (unreadCount) {
    0 => 'Nessuna notifica non letta',
    1 => '1 notifica non letta',
    _ => '$unreadCount notifiche non lette',
  };
}

class _NotificationPanelBody extends StatelessWidget {
  const _NotificationPanelBody({
    required this.notifications,
    required this.isLoading,
    required this.errorMessage,
    required this.onNotificationTap,
    required this.colors,
    required this.itemColors,
  });

  final List<AppNotification> notifications;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<String> onNotificationTap;
  final NotificationCenterPanelColors colors;
  final NotificationItemColors itemColors;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _NotificationLoadingState(colors: colors);
    }

    if (errorMessage != null) {
      return _NotificationErrorState(message: errorMessage!, colors: colors);
    }

    if (notifications.isEmpty) {
      return _NotificationEmptyState(colors: colors);
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
          key: ValueKey(notification.id),
          notification: notification,
          colors: itemColors,
          onTap: () => onNotificationTap(notification.id),
        );
      },
    );
  }
}

class _NotificationLoadingState extends StatelessWidget {
  const _NotificationLoadingState({required this.colors});

  final NotificationCenterPanelColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
  }
}

class _NotificationEmptyState extends StatelessWidget {
  const _NotificationEmptyState({required this.colors});

  final NotificationCenterPanelColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 34,
                color: colors.emptyIconColor,
              ),
              const SizedBox(height: 10),
              Text(
                'Nessuna notifica',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.emptyTitleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Gli aggiornamenti sul servizio compariranno qui.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.emptyMessageColor,
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

class _NotificationErrorState extends StatelessWidget {
  const _NotificationErrorState({required this.message, required this.colors});

  final String message;
  final NotificationCenterPanelColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: colors.errorIconColor,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.errorTextColor,
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
