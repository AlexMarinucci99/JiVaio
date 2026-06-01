import 'package:flutter/material.dart';

import '../../../domain/models/app_notification.dart';
import '../theme/notification_center_panel_colors.dart';
import '../theme/notification_item_colors.dart';
import 'notification_item.dart';

/// Pannello flottante che visualizza il centro notifiche.
///
/// Il widget riceve stato e callback dall'esterno.
/// Non contiene business logic e non modifica direttamente i dati.
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

  // Elenco già ordinato delle notifiche.
  final List<AppNotification> notifications;

  // Numero di notifiche non ancora lette.
  final int unreadCount;

  // Stato di caricamento iniziale.
  final bool isLoading;

  // Eventuale errore restituito dal ViewModel.
  final String? errorMessage;

  // Chiusura del pannello.
  final VoidCallback onClose;

  // Segna tutte le notifiche come lette.
  final VoidCallback onMarkAllAsRead;

  // Segna come letta la notifica selezionata.
  final ValueChanged<String> onNotificationTap;

  // Palette del pannello.
  final NotificationCenterPanelColors colors;

  // Palette delle righe interne.
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

/// Intestazione del pannello.
///
/// Separata dal contenitore principale per evitare un widget troppo annidato.
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

  String _unreadLabel(int unreadCount) {
    if (unreadCount == 0) {
      return 'Nessuna notifica non letta';
    }

    if (unreadCount == 1) {
      return '1 notifica non letta';
    }

    return '$unreadCount notifiche non lette';
  }
}

/// Corpo dinamico del pannello.
///
/// Mostra caricamento, errore, stato vuoto oppure elenco.
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
      separatorBuilder: (context, index) {
        return Divider(height: 1, thickness: 1, color: colors.dividerColor);
      },
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return NotificationItem(
          key: ValueKey(notification.id),
          notification: notification,
          colors: itemColors,
          onTap: () {
            onNotificationTap(notification.id);
          },
        );
      },
    );
  }
}

/// Stato mostrato durante il caricamento iniziale.
class _NotificationLoadingState extends StatelessWidget {
  const _NotificationLoadingState({required this.colors});

  final NotificationCenterPanelColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: colors.loadingIndicatorColor,
          ),
        ),
      ),
    );
  }
}

/// Stato mostrato quando non esistono notifiche.
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

/// Stato mostrato quando il caricamento non riesce.
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
