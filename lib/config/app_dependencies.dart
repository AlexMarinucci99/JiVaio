import '../data/repositories/auth_repository.dart';
import '../data/repositories/location_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/onboarding_repository.dart';
import '../data/repositories/route_planning_repository.dart';
import '../data/repositories/saved_lines_repository.dart';
import '../data/repositories/transit_repository.dart';
import '../data/services/firebase_auth_service.dart';
import '../data/services/firestore_saved_lines_service.dart';
import '../data/services/geolocator_location_service.dart';
import '../data/services/mock_notification_service.dart';
import '../data/services/mock_route_planning_service.dart';
import '../data/services/onboarding_preferences_service.dart';

/// Contenitore delle dipendenze principali dell'app.
///
/// Centralizza la creazione di repository e service, così le schermate
/// ricevono dipendenze già pronte senza conoscere i dettagli di costruzione.
class AppDependencies {
  const AppDependencies({
    required this.authRepository,
    required this.transitRepository,
    required this.locationRepository,
    required this.notificationRepository,
    required this.savedLinesRepository,
    required this.routePlanningRepository,
    required this.onboardingRepository,
  });

  /// Costruisce il grafo delle dipendenze predefinite dell'app.
  ///
  /// Mantiene in un solo punto l'associazione tra repository e service,
  /// compresi i mock usati per funzionalità non ancora collegate a dati reali.
factory AppDependencies.create() => AppDependencies(
  authRepository: AuthRepository(FirebaseAuthService()),
  transitRepository: TransitRepository(),
  locationRepository: const LocationRepository(
    service: GeolocatorLocationService(),
  ),
  notificationRepository: const NotificationRepository(
    service: MockNotificationService(),
  ),
  savedLinesRepository: SavedLinesRepository(
    FirestoreSavedLinesService(),
  ),
  routePlanningRepository: const RoutePlanningRepository(
    MockRoutePlanningService(),
  ),
  onboardingRepository: OnboardingRepository(
    OnboardingPreferencesService(),
  ),
);

  final AuthRepository authRepository;
  final TransitRepository transitRepository;
  final LocationRepository locationRepository;
  final NotificationRepository notificationRepository;
  final SavedLinesRepository savedLinesRepository;
  final RoutePlanningRepository routePlanningRepository;
  final OnboardingRepository onboardingRepository;
}
