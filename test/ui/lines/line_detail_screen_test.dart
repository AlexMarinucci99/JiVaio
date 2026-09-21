import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/ui/lines/view_model/line_detail_view_model.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_screen.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_stop_tile.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_time_filter.dart';

import '../../helpers/transit_fakes.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  late FakeTransitRepository repository;

  setUp(() => repository = FakeTransitRepository());

  Future<void> mount(WidgetTester tester) async {
    await usePhoneSurface(tester);
    final model = LineDetailViewModel(line: testLine, repository: repository);
    await model.selectManualHour(8);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => model,
        child: const MaterialApp(home: LineDetailScreen()),
      ),
    );
  }

  testWidgets('mostra fermate e orari e li aggiorna invertendo la direzione', (
    tester,
  ) async {
    await mount(tester);
    expect(find.text('Linea Centro'), findsOneWidget);
    expect(find.text('08:10'), findsOneWidget);
    await tester.ensureVisible(find.text('Fermata Centro'));
    expect(find.text('08:15'), findsOneWidget);
    expect(find.text('--:--'), findsOneWidget);
    final tiles = tester
        .widgetList<LineDetailStopTile>(find.byType(LineDetailStopTile))
        .toList();
    expect(tiles.map((tile) => tile.stop.name), [
      'Fermata Centro',
      'Fermata finale',
    ]);
    expect(tiles.first.onTap, isNull);
    await tapVisible(tester, find.byTooltip('Inverti direzione'));
    await tester.ensureVisible(find.text('Fermata Parco'));
    expect(find.text('Fermata Centro'), findsNothing);
    expect(find.text('09:25'), findsOneWidget);
    expect(repository.scheduleRequests.last.direction, 'inbound');
    await tester.scrollUntilVisible(find.text('09:20'), -300);
    expect(find.text('09:20'), findsOneWidget);
  });

  testWidgets(
    'annullare il filtro mantiene la fascia e non ricarica gli orari',
    (tester) async {
      await mount(tester);
      await tapVisible(tester, find.text('08:00 - 09:00'));
      expect(find.byType(LineDetailTimeFilterSheet), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('05:00 - 06:00'),
        200,
        scrollable: find.descendant(
          of: find.byType(LineDetailTimeFilterSheet),
          matching: find.byType(Scrollable),
        ),
      );
      await tapVisible(tester, find.text('05:00 - 06:00'));
      await tapVisible(tester, find.text('Annulla'));
      expect(find.byType(LineDetailTimeFilterSheet), findsNothing);
      expect(find.text('08:00 - 09:00'), findsOneWidget);
      expect(repository.scheduleRequests, hasLength(1));
    },
  );

  testWidgets(
    'conferma una fascia manuale e permette di tornare ad Automatico',
    (tester) async {
      await mount(tester);
      await tapVisible(tester, find.text('08:00 - 09:00'));
      await tester.scrollUntilVisible(
        find.text('05:00 - 06:00'),
        200,
        scrollable: find.descendant(
          of: find.byType(LineDetailTimeFilterSheet),
          matching: find.byType(Scrollable),
        ),
      );
      await tapVisible(tester, find.text('05:00 - 06:00'));
      await tapVisible(tester, find.text('Conferma'));
      expect(find.text('05:00 - 06:00'), findsOneWidget);
      expect(repository.scheduleRequests.last.hour, 5);
      await tapVisible(tester, find.text('05:00 - 06:00'));
      await tapVisible(tester, find.text('Automatico'));
      await tapVisible(tester, find.text('Conferma'));
      expect(repository.scheduleRequests, hasLength(3));
      await tapVisible(tester, find.byIcon(Icons.keyboard_arrow_down_rounded));
      expect(
        tester
            .widget<LineDetailTimeFilterSheet>(
              find.byType(LineDetailTimeFilterSheet),
            )
            .selectedManualHour,
        isNull,
      );
      await tapVisible(tester, find.text('Annulla'));
    },
  );

  for (final onBus in [true, false]) {
    testWidgets(
      'segnalazione ${onBus ? 'a bordo' : 'alla fermata'} richiede una fermata',
      (tester) async {
        await mount(tester);
        final delayButton = find.widgetWithText(
          FilledButton,
          'Segnala ritardo',
        );
        expect(tester.widget<FilledButton>(delayButton).onPressed, isNull);
        await tapVisible(tester, find.text(onBus ? 'Sì' : 'No'));
        expect(tester.widget<FilledButton>(delayButton).onPressed, isNull);
        await tapVisible(tester, find.text('Fermata Centro'));
        expect(find.text('Selezionata'), findsOneWidget);
        await tapVisible(
          tester,
          find.text(onBus ? 'Segnala ritardo' : 'Bus pieno'),
        );
        expect(
          find.text(
            onBus
                ? 'Ritardo registrato per la linea 1.'
                : 'Bus pieno registrato dalla fermata "Fermata Centro".',
          ),
          findsOneWidget,
        );
        await tapVisible(tester, find.byTooltip('Inverti direzione'));
        expect(find.text('Selezionata'), findsNothing);
        expect(find.textContaining('registrato'), findsNothing);
        expect(tester.widget<FilledButton>(delayButton).onPressed, isNull);
      },
    );
  }

  for (final failure in [false, true]) {
    testWidgets(
      'mostra assenza di corse con ${failure ? 'errore' : 'orari vuoti'}',
      (tester) async {
        repository.emptySchedule = !failure;
        repository.failSchedule = failure;
        await mount(tester);
        expect(find.text('Nessuna corsa disponibile.'), findsOneWidget);
        expect(find.byType(LineDetailStopTile), findsNothing);
      },
    );
  }
}
