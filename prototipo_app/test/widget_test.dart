import 'package:flutter_test/flutter_test.dart';
import 'package:wayline_app/app.dart';

void main() {
  testWidgets('WayLine app starts with onboarding', (
    WidgetTester tester,
  ) async {
    // Avvio dell'app forzando la visualizzazione dell'onboarding.
    await tester.pumpWidget(
      const WayLineApp(showOnboarding: true),
    );

    // Lascia completare il primo rendering della UI.
    await tester.pump();

    // Verifica che la schermata onboarding sia stata caricata.
    expect(find.text('Salta'), findsOneWidget);
  });
}