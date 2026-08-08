import '../../domain/models/route_result.dart';
import 'route_planning_service.dart';

/// Restituisce un percorso dimostrativo finché non è collegato il motore reale.
class MockRoutePlanningService implements RoutePlanningService {
  const MockRoutePlanningService();

  @override
  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return RouteResult(
      origin: origin,
      destination: destination,
      boardingStopName: 'OSPEDALE Via Vetoio',
      lineCode: '4',
      totalDuration: const Duration(minutes: 32),
      nextBusTimes: const ['11:35'],
      departureTime: '11:33',
      arrivalTime: '12:05',
    );
  }
}
