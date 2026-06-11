import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/notifications/widgets/notification_bell_button.dart';

void main() {
  Widget buildTestWidget({
    required int unreadCount,
    required bool isPanelOpen,
    required VoidCallback onPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NotificationBellButton(
            unreadCount: unreadCount,
            isPanelOpen: isPanelOpen,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra la campanella senza badge quando non ci sono notifiche non lette',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 0,
        isPanelOpen: false,
        onPressed: () {},
      ),
    );

    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('mostra il badge con il numero di notifiche non lette',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 3,
        isPanelOpen: false,
        onPressed: () {},
      ),
    );

    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('mostra 9+ quando le notifiche non lette superano 9',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 12,
        isPanelOpen: false,
        onPressed: () {},
      ),
    );

    expect(find.text('9+'), findsOneWidget);
    expect(find.text('12'), findsNothing);
  });

  testWidgets('esegue la callback quando viene premuta la campanella',
      (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        unreadCount: 1,
        isPanelOpen: false,
        onPressed: () {
          pressed = true;
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}