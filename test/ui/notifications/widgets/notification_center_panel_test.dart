import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/app_notification.dart';
import 'package:jivaio/ui/notifications/widgets/notification_center_panel.dart';
import 'package:jivaio/ui/notifications/widgets/notification_item.dart';

void main() {
  AppNotification buildNotification({
    required String id,
    required String title,
    String message = 'Messaggio di test della notifica.',
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
    String? errorMessage,
    VoidCallback? onClose,
    VoidCallback? onMarkAllAsRead,
    ValueChanged<String>? onNotificationTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NotificationCenterPanel(
            notifications: notifications,
            unreadCount: unreadCount,
            isLoading: isLoading,
            errorMessage: errorMessage,
            onClose: onClose ?? () {},
            onMarkAllAsRead: onMarkAllAsRead ?? () {},
            onNotificationTap: onNotificationTap ?? (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('mostra titolo del centro notifiche',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('Notifiche'), findsOneWidget);
  });

  testWidgets('mostra messaggio quando non ci sono notifiche non lette',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 0,
      ),
    );

    expect(find.text('Nessuna notifica non letta'), findsOneWidget);
  });

  testWidgets('mostra conteggio singolare per una notifica non letta',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 1,
      ),
    );

    expect(find.text('1 notifica non letta'), findsOneWidget);
  });

  testWidgets('mostra conteggio plurale per più notifiche non lette',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 3,
      ),
    );

    expect(find.text('3 notifiche non lette'), findsOneWidget);
  });

  testWidgets('esegue onClose quando viene premuto Chiudi notifiche',
      (WidgetTester tester) async {
    var closed = false;

    await tester.pumpWidget(
      buildTestWidget(
        onClose: () {
          closed = true;
        },
      ),
    );

    await tester.tap(find.byTooltip('Chiudi notifiche'));
    await tester.pump();

    expect(closed, isTrue);
  });

  testWidgets('abilita Segna tutte come lette quando ci sono notifiche non lette',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 2,
      ),
    );

    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Segna tutte come lette'),
    );

    expect(button.onPressed, isNotNull);
  });

  testWidgets('disabilita Segna tutte come lette quando non ci sono notifiche non lette',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 0,
      ),
    );

    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Segna tutte come lette'),
    );

    expect(button.onPressed, isNull);
  });

  testWidgets('esegue onMarkAllAsRead quando si preme Segna tutte come lette',
      (WidgetTester tester) async {
    var markedAllAsRead = false;

    await tester.pumpWidget(
      buildTestWidget(
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

  testWidgets('mostra stato loading quando isLoading è true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isLoading: true,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Nessuna notifica'), findsNothing);
    expect(find.byType(NotificationItem), findsNothing);
  });

  testWidgets('mostra stato vuoto quando non ci sono notifiche',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        notifications: const [],
        isLoading: false,
        errorMessage: null,
      ),
    );

    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.text('Nessuna notifica'), findsOneWidget);
    expect(
      find.text('Gli aggiornamenti sul servizio compariranno qui.'),
      findsOneWidget,
    );
  });

  testWidgets('mostra stato errore quando errorMessage è presente',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        errorMessage: 'Impossibile caricare le notifiche.',
      ),
    );

    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(find.text('Impossibile caricare le notifiche.'), findsOneWidget);
    expect(find.byType(NotificationItem), findsNothing);
  });

  testWidgets('mostra una NotificationItem per ogni notifica',
      (WidgetTester tester) async {
    final notifications = [
      buildNotification(
        id: 'notification-1',
        title: 'Ritardo linea 1',
      ),
      buildNotification(
        id: 'notification-2',
        title: 'Cambio fermata',
      ),
    ];

    await tester.pumpWidget(
      buildTestWidget(
        notifications: notifications,
      ),
    );

    expect(find.byType(NotificationItem), findsNWidgets(2));
    expect(find.text('Ritardo linea 1'), findsOneWidget);
    expect(find.text('Cambio fermata'), findsOneWidget);
  });

  testWidgets('assegna una ValueKey a ogni notifica',
      (WidgetTester tester) async {
    final notifications = [
      buildNotification(
        id: 'notification-1',
        title: 'Ritardo linea 1',
      ),
      buildNotification(
        id: 'notification-2',
        title: 'Cambio fermata',
      ),
    ];

    await tester.pumpWidget(
      buildTestWidget(
        notifications: notifications,
      ),
    );

    expect(find.byKey(const ValueKey('notification-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('notification-2')), findsOneWidget);
  });

  testWidgets('esegue onNotificationTap con id corretto',
      (WidgetTester tester) async {
    String? selectedNotificationId;

    final notifications = [
      buildNotification(
        id: 'notification-1',
        title: 'Ritardo linea 1',
      ),
      buildNotification(
        id: 'notification-2',
        title: 'Cambio fermata',
      ),
    ];

    await tester.pumpWidget(
      buildTestWidget(
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
}