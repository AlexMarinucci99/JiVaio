import '../../domain/models/route_result.dart';

/// Definisce il contratto per una sorgente capace di pianificare un percorso.
///
/// Il repository dipende da questa astrazione, così l'implementazione mock
/// può essere sostituita dall'algoritmo reale senza modificare ViewModel e UI.
abstract interface class RoutePlanningService {
  /// Calcola un percorso tra [origin] e [destination].
  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  });
}
