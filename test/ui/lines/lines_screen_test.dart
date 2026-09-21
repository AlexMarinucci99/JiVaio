import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/data/repositories/saved_lines_repository.dart';
import 'package:jivaio/data/repositories/transit_repository.dart';
import 'package:jivaio/ui/lines/view_model/lines_view_model.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_card.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_screen.dart';
import 'package:jivaio/ui/lines/widgets/lines_screen.dart';

import '../../helpers/transit_fakes.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  late FakeTransitRepository transit;
  late FakeSavedLinesService saved;

  setUp(() {
    transit = FakeTransitRepository();
    saved = FakeSavedLinesService();
  });
  tearDown(() => saved.changes.close());

  Future<void> mount(WidgetTester tester, {String? userId = 'user-1'}) async {
    await usePhoneSurface(tester);
    final model = LinesViewModel(
      transitRepository: transit,
      savedLinesRepository: SavedLinesRepository(saved),
      userId: userId,
    );
    await model.loadLines();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<TransitRepository>.value(value: transit),
          ChangeNotifierProvider(create: (_) => model),
        ],
        child: const MaterialApp(home: LinesScreen()),
      ),
    );
  }

  testWidgets('mostra le linee e filtra i preferiti aggiornati dal servizio', (
    tester,
  ) async {
    await mount(tester);
    expect(find.text('Linea Centro'), findsOneWidget);
    expect(find.text('Linea Università'), findsOneWidget);
    saved.changes.add({'route-1'});
    await tester.pump();
    await tapVisible(tester, find.text('Salvate'));
    expect(find.text('1 linea salvata'), findsOneWidget);
    expect(find.byKey(const ValueKey('route-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('route-2')), findsNothing);
    saved.changes.add({});
    await tester.pumpAndSettle();
    expect(find.text('Nessuna linea salvata'), findsOneWidget);
    await tapVisible(tester, find.text('Tutte'));
    expect(find.byType(LineCard), findsNWidgets(2));
  });

  testWidgets('salva e rimuove la linea aggiornando cuore e filtro', (
    tester,
  ) async {
    await mount(tester);
    await tapVisible(tester, find.byTooltip('Salva linea').first);
    expect(saved.writes.single, (
      userId: 'user-1',
      routeId: 'route-1',
      saved: true,
    ));
    expect(find.byTooltip('Rimuovi dai salvati'), findsOneWidget);
    await tapVisible(tester, find.text('Salvate'));
    await tapVisible(tester, find.byTooltip('Rimuovi dai salvati'));
    expect(saved.writes.last, (
      userId: 'user-1',
      routeId: 'route-1',
      saved: false,
    ));
    expect(find.text('Nessuna linea salvata'), findsOneWidget);
  });

  testWidgets(
    'ripristina il cuore e mostra un errore se il salvataggio fallisce',
    (tester) async {
      saved.pendingWrite = Completer<void>();
      await mount(tester);
      await tapVisible(tester, find.byTooltip('Salva linea').first);
      expect(find.byTooltip('Rimuovi dai salvati'), findsOneWidget);
      await tapVisible(tester, find.byTooltip('Rimuovi dai salvati'));
      expect(saved.writes, hasLength(1));
      saved.pendingWrite!.completeError(StateError('Offline'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Rimuovi dai salvati'), findsNothing);
      expect(
        find.text('Impossibile aggiornare le linee salvate. Riprova.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'il guest riceve un invito ad accedere senza scrivere preferiti',
    (tester) async {
      await mount(tester, userId: null);
      await tapVisible(tester, find.byTooltip('Salva linea').first);
      expect(
        find.text('Accedi per salvare le linee preferite.'),
        findsOneWidget,
      );
      expect(saved.writes, isEmpty);
      await tapVisible(tester, find.text('Salvate'));
      expect(find.text('Preferiti disponibili dopo l’accesso'), findsOneWidget);
    },
  );

  testWidgets('riprova il caricamento dopo un errore', (tester) async {
    transit.failLines = true;
    await mount(tester);
    expect(find.text('Errore caricamento linee'), findsOneWidget);
    transit.failLines = false;
    await tapVisible(tester, find.text('Riprova'));
    expect(transit.lineRequests, 2);
    expect(find.text('Errore caricamento linee'), findsNothing);
    expect(find.text('Linea Centro'), findsOneWidget);
  });

  testWidgets('apre il dettaglio della linea scelta e ritorna all’elenco', (
    tester,
  ) async {
    await mount(tester);
    await tapVisible(tester, find.text('Apri linea completa').first);
    expect(find.byType(LineDetailScreen), findsOneWidget);
    expect(find.text('Linea Centro'), findsOneWidget);
    expect(find.text('08:10'), findsOneWidget);
    expect(transit.scheduleRequests.single.routeId, 'route-1');
    await tapVisible(tester, find.byIcon(Icons.arrow_back_rounded));
    expect(find.text('Elenco Linee'), findsOneWidget);
  });
}
