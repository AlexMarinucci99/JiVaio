import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jivaio/domain/models/app_user.dart';
import 'package:jivaio/ui/settings/widgets/settings_screen.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('il guest può richiedere l’accesso dalle impostazioni', (
    tester,
  ) async {
    var exits = 0;
    await usePhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(
          user: null,
          onLogout: () async {
            exits++;
          },
        ),
      ),
    );
    expect(find.text('Modalità ospite'), findsOneWidget);
    expect(find.text("Esci dall'account"), findsNothing);
    await tapVisible(tester, find.text('Accedi o registrati'));
    expect(exits, 1);
  });

  testWidgets('mostra il profilo e inoltra la richiesta di logout', (
    tester,
  ) async {
    var logouts = 0;
    await usePhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(
          user: const AppUser(
            id: 'user-1',
            displayName: 'Anna',
            email: 'anna@example.com',
          ),
          onLogout: () async {
            logouts++;
          },
        ),
      ),
    );
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('anna@example.com'), findsOneWidget);
    expect(find.text('Accedi o registrati'), findsNothing);
    await tapVisible(tester, find.text("Esci dall'account"));
    expect(logouts, 1);
  });
}
