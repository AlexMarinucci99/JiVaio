import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jivaio/ui/home/theme/home_colors.dart';
import 'package:jivaio/ui/home/widgets/home_alert_dialog.dart';

void main() {
  const colors = HomeAlertDialogColors(
    backgroundColor: Color(0xFF101010),
    primaryTextColor: Color(0xFF303030),
    secondaryTextColor: Color(0xFF404040),
    accentColor: Color(0xFF606060),
  );

  Future<void> showHomeDialog(
    WidgetTester tester, {
    required VoidCallback onConfirm,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showHomeAlertDialog(
              context,
              title: 'Titolo',
              message: 'Messaggio',
              dismissLabel: 'Annulla',
              confirmLabel: 'Conferma',
              colors: colors,
              onConfirm: onConfirm,
            ),
            child: const Text('Apri'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Apri'));
    await tester.pumpAndSettle();
  }

  testWidgets('applica la palette ricevuta', (tester) async {
    await showHomeDialog(tester, onConfirm: () {});

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    final title = tester.widget<Text>(find.text('Titolo'));
    final content = tester.widget<Text>(find.text('Messaggio'));
    final dismissButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Annulla'),
    );
    final confirmButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Conferma'),
    );

    expect(dialog.backgroundColor, colors.backgroundColor);
    expect(dialog.surfaceTintColor, colors.backgroundColor);
    expect(dialog.elevation, 0);
    expect(title.style?.color, colors.primaryTextColor);
    expect(content.style?.color, colors.secondaryTextColor);
    expect(
      dismissButton.style?.foregroundColor?.resolve(<WidgetState>{}),
      colors.secondaryTextColor,
    );
    expect(
      confirmButton.style?.foregroundColor?.resolve(<WidgetState>{}),
      colors.accentColor,
    );
  });

  testWidgets('chiude il dialog e richiama la conferma', (tester) async {
    var confirmed = false;
    await showHomeDialog(tester, onConfirm: () => confirmed = true);

    await tester.tap(find.text('Conferma'));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('chiude il dialog senza confermare', (tester) async {
    var confirmed = false;
    await showHomeDialog(tester, onConfirm: () => confirmed = true);

    await tester.tap(find.text('Annulla'));
    await tester.pumpAndSettle();

    expect(confirmed, isFalse);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
