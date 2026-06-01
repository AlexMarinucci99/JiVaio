import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jivaio/ui/onboarding/widgets/onboarding_screen.dart';

void main() {
  testWidgets('JiVaio app starts with onboarding', (WidgetTester tester) async {
    // Test isolato della feature onboarding:
    // non servono repository, service o dipendenze Firebase.
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

    // Lascia completare il primo rendering della UI.
    await tester.pump();

    // Verifica che la schermata onboarding sia stata caricata.
    expect(find.text('Salta'), findsOneWidget);
  });
}
