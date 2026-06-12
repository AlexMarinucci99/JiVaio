import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/app_notification.dart';
import 'package:jivaio/ui/notifications/widgets/notification_bell_button.dart';
import 'package:jivaio/ui/notifications/widgets/notification_center_overlay.dart';
import 'package:jivaio/ui/notifications/widgets/notification_center_panel.dart';

void main() {
  AppNotification buildNotification({
    required String id,
    required String title,
    String message = 'Messaggio di test.',
    AppNotificationType type = AppNotificationType.serviceUpdate,
    bool isRead = false,
  }) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: isRead,
    );
  }

  Widget buildTestWidget({
    List<AppNotification> notifications = const [],
    int unreadCount = 0,
    bool isLoading = false,
    bool isPanelOpen = false,
    String? errorMessage,
    VoidCallback? onTogglePanel,
    VoidCallback? onClosePanel,
    VoidCallback? onMarkAllAsRead,
    ValueChanged<String>? onNotificationTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 420,
          height: 700,
          child: NotificationCenterOverlay(
            notifications: notifications,
            unreadCount: unreadCount,
            isLoading: isLoading,
            isPanelOpen: isPanelOpen,
            errorMessage: errorMessage,
            onTogglePanel: onTogglePanel ?? () {},
            onClosePanel: onClosePanel ?? () {},
            onMarkAllAsRead: onMarkAllAsRead ?? () {},
            onNotificationTap: onNotificationTap ?? (_) {},
          ),
        ),
      ),
    );
  }

  Finder findBellInkWell() {
    return find.descendant(
      of: find.byType(NotificationBellButton),
      matching: find.byType(InkWell),
    );
  }

  testWidgets('mostra sempre la campanella notifiche', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(NotificationBellButton), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
  });

  testWidgets('mostra il badge con il numero di notifiche non lette', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(unreadCount: 3));

    expect(find.byType(NotificationBellButton), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('non mostra il pannello quando isPanelOpen è false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(isPanelOpen: false));

    expect(find.byType(NotificationCenterPanel), findsNothing);
    expect(find.text('Notifiche'), findsNothing);
  });

  testWidgets('mostra il pannello quando isPanelOpen è true', (
    WidgetTester tester,
  ) async {
    final notifications = [
      buildNotification(id: 'notification-1', title: 'Ritardo linea 1'),
    ];

    await tester.pumpWidget(
      buildTestWidget(
        isPanelOpen: true,
        unreadCount: 1,
        notifications: notifications,
      ),
    );

    expect(find.byType(NotificationCenterPanel), findsOneWidget);
    expect(find.text('Notifiche'), findsOneWidget);
    expect(find.text('Ritardo linea 1'), findsOneWidget);
  });

  testWidgets('esegue onTogglePanel quando si preme la campanella', (
    WidgetTester tester,
  ) async {
    var toggled = false;

    await tester.pumpWidget(
      buildTestWidget(
        onTogglePanel: () {
          toggled = true;
        },
      ),
    );

    await tester.tap(findBellInkWell());
    await tester.pump();

    expect(toggled, isTrue);
  });

  testWidgets('esegue onClosePanel quando si preme Chiudi notifiche', (
    WidgetTester tester,
  ) async {
    var closed = false;

    await tester.pumpWidget(
      buildTestWidget(
        isPanelOpen: true,
        onClosePanel: () {
          closed = true;
        },
      ),
    );

    await tester.tap(find.byTooltip('Chiudi notifiche'));
    await tester.pump();

    expect(closed, isTrue);
  });

  testWidgets('esegue onClosePanel quando si tocca fuori dal pannello', (
    WidgetTester tester,
  ) async {
    var closed = false;

    await tester.pumpWidget(
      buildTestWidget(
        isPanelOpen: true,
        onClosePanel: () {
          closed = true;
        },
      ),
    );

    await tester.tapAt(const Offset(24, 360));
    await tester.pump();

    expect(closed, isTrue);
  });

  testWidgets('inoltra onMarkAllAsRead al pannello', (
    WidgetTester tester,
  ) async {
    var markedAllAsRead = false;

    await tester.pumpWidget(
      buildTestWidget(
        isPanelOpen: true,
        unreadCount: 2,
        onMarkAllAsRead: () {
          markedAllAsRead = true;
        },
      ),
    );

    await tester.tap(find.text('Segna tutte come lette'));
    await tester.pump();

    expect(markedAllAsRead, isTrue);
  });

  testWidgets('inoltra onNotificationTap con id corretto', (
    WidgetTester tester,
  ) async {
    String? selectedNotificationId;

    final notifications = [
      buildNotification(id: 'notification-1', title: 'Ritardo linea 1'),
      buildNotification(id: 'notification-2', title: 'Cambio fermata'),
    ];

    await tester.pumpWidget(
      buildTestWidget(
        isPanelOpen: true,
        notifications: notifications,
        onNotificationTap: (notificationId) {
          selectedNotificationId = notificationId;
        },
      ),
    );

    await tester.tap(find.text('Cambio fermata'));
    await tester.pump();

    expect(selectedNotificationId, 'notification-2');
  });

  testWidgets('mostra stato loading del pannello quando isLoading è true', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(isPanelOpen: true, isLoading: true),
    );

    expect(find.byType(NotificationCenterPanel), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'mostra stato errore del pannello quando errorMessage è presente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          isPanelOpen: true,
          errorMessage: 'Errore caricamento notifiche.',
        ),
      );

      expect(find.byType(NotificationCenterPanel), findsOneWidget);
      expect(find.text('Errore caricamento notifiche.'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    },
  );
}
