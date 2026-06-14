import '../../domain/models/route_result.dart';
import 'route_planning_service.dart';

/// Restituisce un percorso dimostrativo statico.
///
/// Serve esclusivamente per costruire e verificare la UI.
/// Verrà sostituito quando sarà disponibile l'algoritmo reale.
class MockRoutePlanningService implements RoutePlanningService {
  const MockRoutePlanningService();

  @override
  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  }) async {
    // Simula una breve operazione asincrona.
    // Permetterà di verificare anche lo stato di caricamento della schermata.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return RouteResult(
      origin: origin,
      destination: destination,
      totalDuration: const Duration(minutes: 32),
      nextBusTimes: const ['11:35'],
      recommendedSteps: [
        RouteStep(
          type: RouteStepType.departure,
          title: 'Partenza',
          subtitle: origin,
          scheduledTime: '11:33',
        ),
        const RouteStep(
          type: RouteStepType.walk,
          title: 'Cammina verso la fermata',
          subtitle: 'Fermata: OSPEDALE Via Vetoio',
          duration: Duration(minutes: 2),
          scheduledTime: '11:34',
        ),
        const RouteStep(
          type: RouteStepType.wait,
          title: 'Attesa navetta',
          duration: Duration.zero,
          scheduledTime: '11:35',
          lineCode: '4',
        ),
        const RouteStep(
          type: RouteStepType.bus,
          title: 'Tragitto navetta',
          duration: Duration(minutes: 30),
          scheduledTime: '12:05',
          lineCode: '4',
        ),
        RouteStep(
          type: RouteStepType.destination,
          title: 'Destinazione',
          subtitle: destination,
          scheduledTime: '12:05',
        ),
      ],
      alternativeRoutes: const [
        AlternativeRoute(
          lineCode: '1',
          description: 'LINEA 1 TERMINALBUS DA VINCI AQUILONE',
          duration: Duration(minutes: 34),
          departureTime: '11:48',
          arrivalTime: '12:20',
        ),
        AlternativeRoute(
          lineCode: '6D',
          description: 'LINEA 6D L’AQUILONE TERMINALBUS COLLEMAGGIO PAGANICA',
          duration: Duration(minutes: 22),
          departureTime: '12:14',
          arrivalTime: '12:33',
        ),
      ],
    );
  }
}
