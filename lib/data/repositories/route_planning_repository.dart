import '../../domain/models/route_result.dart';
import '../services/route_planning_service.dart';

/// Gestisce l'accesso alla pianificazione dei percorsi.
///
/// Espone ai ViewModel un'API stabile e nasconde se la pianificazione
/// viene prodotta da mock, (algoritmo locale, database o API esterna in futuro).
class RoutePlanningRepository {
  const RoutePlanningRepository(this._service);

  final RoutePlanningService _service;

  /// Pianifica un percorso tra [origin] e [destination].
  ///
  /// Normalizza gli input ricevuti dalla UI e blocca richieste prive
  /// di partenza o destinazione prima di delegare al service.
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
