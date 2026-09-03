import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/notification_center_view_model.dart';
import 'notification_bell_button.dart';
import 'notification_center_panel.dart';

/// Collega il centro notifiche al proprio ViewModel e lo mostra sulla Home.
class NotificationCenterOverlay extends StatelessWidget {
  const NotificationCenterOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationCenterViewModel>(
      builder: (context, viewModel, child) {
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
                if (viewModel.isPanelOpen)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: viewModel.closePanel,
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
                            unreadCount: viewModel.unreadCount,
                            isPanelOpen: viewModel.isPanelOpen,
                            onPressed: viewModel.togglePanel,
                          ),
                          if (viewModel.isPanelOpen) ...[
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: panelWidth,
                                maxHeight: panelMaxHeight,
                              ),
                              child: NotificationCenterPanel(
                                notifications: viewModel.notifications,
                                unreadCount: viewModel.unreadCount,
                                onClose: viewModel.closePanel,
                                onMarkAllAsRead: viewModel.markAllAsRead,
                                onNotificationTap: viewModel.markAsRead,
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
      },
    );
  }
}
