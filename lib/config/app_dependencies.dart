import '../data/repositories/auth_repository.dart';
import '../data/repositories/location_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/saved_lines_repository.dart';
import '../data/repositories/transit_repository.dart';
import '../data/services/auth_service.dart';
import '../data/services/saved_lines_service.dart';
import '../data/repositories/route_planning_repository.dart';
import '../data/services/mock_route_planning_service.dart';

/// Contenitore delle dipendenze principali dell'app.
///
/// Repository e service vengono creati una sola volta all'avvio
/// e successivamente passati alle schermate che ne hanno bisogno.
class AppDependencies {
  const AppDependencies({
    required this.authRepository,
    required this.transitRepository,
    required this.locationRepository,
    required this.notificationRepository,
    required this.savedLinesRepository,
    required this.routePlanningRepository,
  });

  /// Costruisce il grafo delle dipendenze reali dell'app.
  ///
  /// In futuro potremo affiancare factory dedicate a test,
  /// staging o sviluppo locale.
  factory AppDependencies.create() {
    return AppDependencies(
      authRepository: AuthRepository(AuthService()),
      transitRepository: TransitRepository(),
      locationRepository: const LocationRepository(),
      notificationRepository: const NotificationRepository(),
      savedLinesRepository: SavedLinesRepository(SavedLinesService()),
      routePlanningRepository: const RoutePlanningRepository(
        MockRoutePlanningService(),
      ),
    );
  }

  final AuthRepository authRepository;
  final TransitRepository transitRepository;
  final LocationRepository locationRepository;
  final NotificationRepository notificationRepository;
  final SavedLinesRepository savedLinesRepository;
  final RoutePlanningRepository routePlanningRepository;
}
