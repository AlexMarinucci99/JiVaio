import '../../domain/models/route_result.dart';
import '../services/route_planning_service.dart';

/// Punto di accesso del ViewModel alla pianificazione dei percorsi.
///
/// Il repository nasconde il service concreto utilizzato.
/// Il ViewModel non deve sapere se i dati arrivano da un mock,
/// da un algoritmo locale, da un database oppure da una API.
class RoutePlanningRepository {
  const RoutePlanningRepository(this._service);

  final RoutePlanningService _service;

  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  }) {
    final normalizedOrigin = origin.trim();
    final normalizedDestination = destination.trim();

    if (normalizedOrigin.isEmpty || normalizedDestination.isEmpty) {
      throw ArgumentError('Partenza e destinazione non possono essere vuote.');
    }

    return _service.planRoute(
      origin: normalizedOrigin,
      destination: normalizedDestination,
    );
  }
}
