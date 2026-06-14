import '../../domain/models/route_result.dart';

/// Contratto per una sorgente capace di pianificare un percorso.
///
/// Oggi verrà utilizzata un'implementazione mock.
/// In futuro potrà essere sostituita dall'algoritmo reale senza modificare
/// repository, ViewModel o widget.
abstract interface class RoutePlanningService {
  Future<RouteResult> planRoute({
    required String origin,
    required String destination,
  });
}
