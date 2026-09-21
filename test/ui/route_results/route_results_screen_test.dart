import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/data/repositories/route_planning_repository.dart';
import 'package:jivaio/data/services/route_planning_service.dart';
import 'package:jivaio/domain/models/route_result.dart';
import 'package:jivaio/ui/route_results/view_model/route_results_view_model.dart';
import 'package:jivaio/ui/route_results/widgets/route_results_screen.dart';

import '../../helpers/widget_test_helpers.dart';

class _RouteService implements RoutePlanningService {
  final response = Completer<RouteResult>();
  final requests = <(String, String)>[];

  @override
  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  }) {
    requests.add((origin, destination));
    return response.future;
  }
}

void main() {
  testWidgets(
    'mostra i dati ricevuti e il messaggio della navigazione dimostrativa',
    (tester) async {
      await usePhoneSurface(tester);
      final service = _RouteService();
      final model = RouteResultsViewModel(
        repository: RoutePlanningRepository(service),
        origin: 'Terminal',
        destination: 'Ospedale',
      );
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => model,
          child: const MaterialApp(home: RouteResultsScreen()),
        ),
      );
      final loading = model.loadRoute();
      expect(find.text('Risultati percorso'), findsNothing);
      service.response.complete(
        RouteResult(
          origin: 'Terminal',
          destination: 'Ospedale',
          boardingStopName: 'Fermata Centro',
          lineCode: '1',
          totalDuration: const Duration(minutes: 32),
          nextBusTimes: ['08:10'],
          departureTime: '08:05',
          arrivalTime: '08:37',
        ),
      );
      await tester.pump();
      await loading;
      expect(service.requests, [('Terminal', 'Ospedale')]);
      expect(find.text('Risultati percorso'), findsOneWidget);
      expect(find.text('Terminal\nPartenza prevista: 08:05'), findsOneWidget);
      expect(find.text('Fermata Centro'), findsOneWidget);
      expect(find.text('Linea 1\nProssima corsa: 08:10'), findsOneWidget);
      await tester.ensureVisible(find.text('Ospedale\nArrivo previsto: 08:37'));
      expect(find.text('32 min'), findsOneWidget);
      expect(find.text('Ospedale\nArrivo previsto: 08:37'), findsOneWidget);
      await tapVisible(
        tester,
        find.text('Inizia navigazione percorso consigliato'),
      );
      expect(
        find.text('Navigazione percorso non ancora implementata.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('il pulsante indietro chiude la schermata risultati', (
    tester,
  ) async {
    await usePhoneSurface(tester);
    final service = _RouteService();
    service.response.complete(
      RouteResult(
        origin: 'A',
        destination: 'B',
        boardingStopName: 'Centro',
        lineCode: '1',
        totalDuration: const Duration(hours: 1),
        nextBusTimes: [],
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => RouteResultsViewModel(
                      repository: RoutePlanningRepository(service),
                      origin: 'A',
                      destination: 'B',
                    )..loadRoute(),
                    child: const RouteResultsScreen(),
                  ),
                ),
              ),
              child: const Text('Apri risultato'),
            ),
          ),
        ),
      ),
    );
    await tapVisible(tester, find.text('Apri risultato'));
    expect(find.text('Linea 1'), findsOneWidget);
    await tapVisible(tester, find.byIcon(Icons.arrow_back_rounded));
    expect(find.text('Apri risultato'), findsOneWidget);
    expect(find.byType(RouteResultsScreen), findsNothing);
  });
}
