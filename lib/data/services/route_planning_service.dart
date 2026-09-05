import '../../domain/models/route_result.dart';

/// Definisce il contratto per la sorgente capace di pianificare il percorso.
///
/// Il repository dipende da questa astrazione.
abstract interface class RoutePlanningService {
  /// Calcola un percorso tra [origin] e [destination].
  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  });
}
