import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/data/repositories/notification_repository.dart';
import 'package:jivaio/data/services/notification_service.dart';
import 'package:jivaio/domain/models/app_notification.dart';
import 'package:jivaio/ui/notifications/view_model/notification_center_view_model.dart';
import 'package:jivaio/ui/notifications/widgets/notification_bell_button.dart';
import 'package:jivaio/ui/notifications/widgets/notification_center_overlay.dart';
import 'package:jivaio/ui/notifications/widgets/notification_center_panel.dart';

import '../../helpers/widget_test_helpers.dart';

class _NotificationService implements NotificationService {
  final response = Completer<List<AppNotification>>();

  @override
  Future<List<AppNotification>> fetchNotifications() => response.future;
}

void main() {
  late _NotificationService service;
  late NotificationCenterViewModel model;

  Future<void> mount(WidgetTester tester) async {
    service = _NotificationService();
    model = NotificationCenterViewModel(
      repository: NotificationRepository(service: service),
    );
    await usePhoneSurface(tester);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => model,
        child: const MaterialApp(
          home: Scaffold(body: NotificationCenterOverlay()),
        ),
      ),
    );
  }

  List<AppNotification> notifications() => [
    AppNotification(
      id: 'older',
      type: AppNotificationType.delay,
      title: 'Ritardo linea 1',
      message: 'Otto minuti di ritardo',
      createdAt: DateTime(2020, 1, 1),
    ),
    AppNotification(
      id: 'newer',
      type: AppNotificationType.serviceUpdate,
      title: 'Fermata sospesa',
      message: 'Usa la fermata successiva',
      createdAt: DateTime(2020, 1, 2),
    ),
  ];

  testWidgets(
    'apre il pannello vuoto e lo chiude con pulsante campanella e sfondo',
    (tester) async {
      await mount(tester);
      expect(find.byType(NotificationCenterPanel), findsNothing);
      await tapVisible(tester, find.byType(NotificationBellButton));
      expect(find.text('Nessuna notifica'), findsOneWidget);
      expect(
        tester
            .widget<TextButton>(
              find.widgetWithText(TextButton, 'Segna tutte come lette'),
            )
            .onPressed,
        isNull,
      );
      await tapVisible(tester, find.byTooltip('Chiudi notifiche'));
      expect(find.byType(NotificationCenterPanel), findsNothing);
      await tapVisible(tester, find.byType(NotificationBellButton));
      await tapVisible(tester, find.byType(NotificationBellButton));
      expect(find.byType(NotificationCenterPanel), findsNothing);
      await tapVisible(tester, find.byType(NotificationBellButton));
      await tester.tapAt(const Offset(10, 700));
      await tester.pump();
      expect(find.byType(NotificationCenterPanel), findsNothing);
    },
  );

  testWidgets(
    'aggiorna il pannello dopo il caricamento e ordina le notifiche',
    (tester) async {
      await mount(tester);
      final loading = model.loadNotifications();
      await tapVisible(tester, find.byType(NotificationBellButton));
      expect(find.text('Nessuna notifica'), findsOneWidget);
      service.response.complete(notifications());
      await tester.pump();
      await loading;
      await tester.pump();
      expect(find.text('Nessuna notifica'), findsNothing);
      expect(find.text('2 notifiche non lette'), findsOneWidget);
      expect(find.text('Usa la fermata successiva'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Fermata sospesa')).dy,
        lessThan(tester.getTopLeft(find.text('Ritardo linea 1')).dy),
      );
    },
  );

  testWidgets(
    'legge una notifica e poi tutte aggiornando contatore e pulsante',
    (tester) async {
      await mount(tester);
      service.response.complete(notifications());
      final loading = model.loadNotifications();
      await tester.pump();
      await loading;
      await tapVisible(tester, find.byType(NotificationBellButton));
      await tapVisible(tester, find.text('Fermata sospesa'));
      expect(find.text('1 notifica non letta'), findsOneWidget);
      expect(
        model.notifications.singleWhere((item) => item.id == 'newer').isRead,
        isTrue,
      );
      expect(
        model.notifications.singleWhere((item) => item.id == 'older').isRead,
        isFalse,
      );
      await tapVisible(tester, find.text('Segna tutte come lette'));
      expect(find.text('Nessuna notifica non letta'), findsOneWidget);
      expect(
        tester
            .widget<NotificationBellButton>(find.byType(NotificationBellButton))
            .unreadCount,
        0,
      );
      expect(
        tester
            .widget<TextButton>(
              find.widgetWithText(TextButton, 'Segna tutte come lette'),
            )
            .onPressed,
        isNull,
      );
    },
  );

  testWidgets('un errore di caricamento mantiene lo stato vuoto previsto', (
    tester,
  ) async {
    await mount(tester);
    final loading = model.loadNotifications();
    service.response.completeError(StateError('Non disponibile'));
    await tester.pump();
    await loading;
    await tapVisible(tester, find.byType(NotificationBellButton));
    expect(find.text('Nessuna notifica'), findsOneWidget);
    expect(find.text('Nessuna notifica non letta'), findsOneWidget);
  });

  testWidgets('limita il badge a 9+ mantenendo il conteggio accessibile', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationBellButton(
            unreadCount: 12,
            isPanelOpen: false,
            onPressed: () => presses++,
          ),
        ),
      ),
    );
    expect(find.text('9+'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Notifiche, 12 non lette')),
      findsOneWidget,
    );
    await tester.tap(find.byType(NotificationBellButton));
    expect(presses, 1);
  });
}
