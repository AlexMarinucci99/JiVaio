import 'package:flutter/material.dart';

import '../../../domain/models/app_notification.dart';
import 'notification_bell_button.dart';
import 'notification_center_panel.dart';

/// Overlay del centro notifiche mostrato sopra la Home.
///
/// Posiziona la campanella, mostra il pannello flottante
/// e chiude il pannello quando l'utente tocca l'area esterna.
class NotificationCenterOverlay extends StatelessWidget {
  const NotificationCenterOverlay({
    super.key,
    required this.notifications,
    required this.unreadCount,
    required this.isLoading,
    required this.isPanelOpen,
    required this.errorMessage,
    required this.onTogglePanel,
    required this.onClosePanel,
    required this.onMarkAllAsRead,
    required this.onNotificationTap,
  });

  /// Notifiche già ordinate dal ViewModel.
  final List<AppNotification> notifications;

  /// Numero mostrato nel badge.
  final int unreadCount;

  /// Stato del caricamento iniziale.
  final bool isLoading;

  /// Indica se il pannello notifiche è aperto.
  final bool isPanelOpen;

  /// Messaggio di errore esposto dal ViewModel, se presente.
  final String? errorMessage;

  /// Callback per aprire o chiudere il pannello dalla campanella.
  final VoidCallback onTogglePanel;

  /// Callback per chiudere il pannello.
  final VoidCallback onClosePanel;

  /// Callback per segnare tutte le notifiche come lette.
  final VoidCallback onMarkAllAsRead;

  /// Callback per segnare come letta una singola notifica.
  final ValueChanged<String> onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelWidth = (constraints.maxWidth - 36)
            .clamp(0.0, 360.0)
            .toDouble();

        final panelMaxHeight = (constraints.maxHeight - 130)
            .clamp(140.0, 430.0)
            .toDouble();

        return Stack(
          children: [
            if (isPanelOpen)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onClosePanel,
                ),
              ),

            Positioned(
              top: 0,
              right: 18,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NotificationBellButton(
                        unreadCount: unreadCount,
                        isPanelOpen: isPanelOpen,
                        onPressed: onTogglePanel,
                      ),

                      if (isPanelOpen) ...[
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: panelWidth,
                            maxHeight: panelMaxHeight,
                          ),
                          child: NotificationCenterPanel(
                            notifications: notifications,
                            unreadCount: unreadCount,
                            isLoading: isLoading,
                            errorMessage: errorMessage,
                            onClose: onClosePanel,
                            onMarkAllAsRead: onMarkAllAsRead,
                            onNotificationTap: onNotificationTap,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
