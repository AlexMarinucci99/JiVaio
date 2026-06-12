import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/app_notification.dart';
import 'package:jivaio/ui/notifications/widgets/notification_item.dart';

void main() {
  AppNotification buildNotification({
    String id = 'notification-1',
    String title = 'Ritardo sulla linea 1',
    String message =
        'La linea 1 potrebbe subire un ritardo di circa 10 minuti.',
    AppNotificationType type = AppNotificationType.delay,
    DateTime? createdAt,
    bool isRead = false,
  }) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      createdAt: createdAt ?? DateTime.now(),
      isRead: isRead,
    );
  }

  Widget buildTestWidget({
    required AppNotification notification,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NotificationItem(
            notification: notification,
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('mostra titolo e messaggio della notifica', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(
          title: 'Aggiornamento servizio',
          message: 'La fermata Fontana Luminosa è temporaneamente spostata.',
        ),
      ),
    );

    expect(find.text('Aggiornamento servizio'), findsOneWidget);
    expect(
      find.text('La fermata Fontana Luminosa è temporaneamente spostata.'),
      findsOneWidget,
    );
  });

  testWidgets('mostra icona schedule per notifica di ritardo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(type: AppNotificationType.delay),
      ),
    );

    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
  });

  testWidgets('mostra icona notifiche attive per notifica di viaggio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(type: AppNotificationType.trip),
      ),
    );

    expect(find.byIcon(Icons.notifications_active_rounded), findsOneWidget);
  });

  testWidgets('mostra icona percorso alternativo per aggiornamento servizio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(
          type: AppNotificationType.serviceUpdate,
        ),
      ),
    );

    expect(find.byIcon(Icons.alt_route_rounded), findsOneWidget);
  });

  testWidgets('esegue onTap quando viene premuta la notifica', (
    WidgetTester tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(),
        onTap: () {
          tapped = true;
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('mostra indicatore non letto quando isRead è false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(notification: buildNotification(isRead: false)),
    );

    final unreadIndicator = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );

    expect(unreadIndicator.opacity, 1);
  });

  testWidgets('nasconde indicatore non letto quando isRead è true', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(notification: buildNotification(isRead: true)),
    );

    final unreadIndicator = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );

    expect(unreadIndicator.opacity, 0);
  });

  testWidgets('mostra Adesso per notifiche appena create', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(createdAt: DateTime.now()),
      ),
    );

    expect(find.text('Adesso'), findsOneWidget);
  });

  testWidgets('mostra minuti fa per notifiche recenti', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ),
    );

    expect(find.text('5 min fa'), findsOneWidget);
  });

  testWidgets('mostra ore fa per notifiche della stessa giornata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ),
    );

    expect(find.text('2 ore fa'), findsOneWidget);
  });

  testWidgets('mostra Ieri per notifiche del giorno precedente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        notification: buildNotification(
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ),
    );

    expect(find.text('Ieri'), findsOneWidget);
  });
}
