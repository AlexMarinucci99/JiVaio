import 'package:flutter_test/flutter_test.dart';
import 'package:jivaio/app.dart';

void main() {
  testWidgets('JiVaio app starts with onboarding', (
    WidgetTester tester,
  ) async {
    // Avvio dell'app forzando la visualizzazione dell'onboarding.
    await tester.pumpWidget(JiVaioApp(showOnboarding: true));

    // Lascia completare il primo rendering della UI.
    await tester.pump();

    // Verifica che la schermata onboarding sia stata caricata.
    expect(find.text('Salta'), findsOneWidget);
  });
}
