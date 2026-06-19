import '../../domain/models/route_result.dart';
import 'route_planning_service.dart';

/// Restituisce un percorso dimostrativo per la schermata dei risultati.
///
/// Il service consente di sviluppare e testare la UI prima
/// dell'integrazione con l'algoritmo reale di pianificazione.
class MockRoutePlanningService implements RoutePlanningService {
  const MockRoutePlanningService();

  @override
  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  }) async {
    // Simula la latenza necessaria a verificare lo stato di caricamento.
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
