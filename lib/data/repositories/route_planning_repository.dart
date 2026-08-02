import '../../domain/models/route_result.dart';
import '../services/route_planning_service.dart';

/// Gestisce l'accesso alla pianificazione dei percorsi.
///
/// Espone ai ViewModel un'API stabile e nasconde se il percorso
/// viene prodotto da un mock, un algoritmo locale o un'API esterna.
class RoutePlanningRepository {
  const RoutePlanningRepository(this._service);

  final RoutePlanningService _service;

  /// Pianifica un percorso tra [origin] e [destination].
  ///
  /// Normalizza gli input e impedisce richieste prive
  /// di partenza o destinazione.
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
