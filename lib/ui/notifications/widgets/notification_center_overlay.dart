import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/models/app_notification.dart';
import 'notification_bell_button.dart';
import 'notification_center_panel.dart';

/// Overlay del centro notifiche mostrato sopra la Home.
///
/// Responsabilità:
/// - posizionare la campanella in alto a destra;
/// - mostrare il pannello sotto la campanella;
/// - chiudere il pannello quando l'utente tocca l'area esterna;
/// - adattare la larghezza e l'altezza del pannello allo schermo.
///
/// Il widget non conserva stato interno e non contiene colori hardcoded.
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

  // Notifiche già ordinate dal ViewModel.
  final List<AppNotification> notifications;

  // Numero mostrato nel badge.
  final int unreadCount;

  // Stato del caricamento iniziale.
  final bool isLoading;

  // true quando il pannello deve essere visibile.
  final bool isPanelOpen;

  // Eventuale messaggio restituito dal ViewModel.
  final String? errorMessage;

  // Apertura o chiusura tramite campanella.
  final VoidCallback onTogglePanel;

  // Chiusura tramite X oppure tap esterno.
  final VoidCallback onClosePanel;

  // Segna tutte le notifiche come lette.
  final VoidCallback onMarkAllAsRead;

  // Segna come letta una singola notifica.
  final ValueChanged<String> onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelWidth = math
            .min(360.0, math.max(0.0, constraints.maxWidth - 36))
            .toDouble();

        final panelMaxHeight = math
            .min(430.0, math.max(140.0, constraints.maxHeight - 130))
            .toDouble();

        return Stack(
          children: [
            // Quando il pannello è aperto, un tap sulla mappa lo chiude.
            //
            // Questo livello si trova dietro alla campanella e al pannello:
            // i tap sui componenti interni continuano quindi a funzionare.
            if (isPanelOpen)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onClosePanel,
                  child: const SizedBox.expand(),
                ),
              ),

            // Campanella e pannello rimangono allineati a destra.
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
