import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/location_repository.dart';
import 'package:jivaio/data/repositories/transit_repository.dart';
import 'package:jivaio/domain/models/location_access_result.dart';
import 'package:jivaio/domain/models/transit_stop.dart';
import 'package:jivaio/domain/models/user_location.dart';
import 'package:jivaio/ui/home/view_model/home_map_view_model.dart';

class FakeTransitRepository implements TransitRepository {
  bool getMapStopsCalled = false;
  bool shouldThrowOnGetMapStops = false;

  List<TransitStop> stops = const <TransitStop>[];

  @override
  Future<List<TransitStop>> getMapStops() async {
    getMapStopsCalled = true;

    if (shouldThrowOnGetMapStops) {
      throw Exception('Errore caricamento fermate');
    }

    return stops;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class FakeLocationRepository implements LocationRepository {
  LocationAccessResult accessResult = LocationAccessResult.granted;

  bool ensureLocationAccessCalled = false;
  bool getCurrentLocationCalled = false;
  bool openLocationSettingsCalled = false;
  bool openAppSettingsCalled = false;

  bool shouldThrowOnCurrentLocation = false;

  UserLocation? currentLocation;

  @override
  Future<LocationAccessResult> ensureLocationAccess() async {
    ensureLocationAccessCalled = true;
    return accessResult;
  }

  @override
  Future<UserLocation> getCurrentLocation() async {
    getCurrentLocationCalled = true;

    if (shouldThrowOnCurrentLocation) {
      throw Exception('Errore posizione');
    }

    final location = currentLocation;

    if (location == null) {
      throw Exception('Posizione mancante nel fake');
    }

    return location;
  }

  @override
  Future<bool> openLocationSettings() async {
    openLocationSettingsCalled = true;
    return true;
  }

  @override
  Future<bool> openAppSettings() async {
    openAppSettingsCalled = true;
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  late FakeTransitRepository transitRepository;
  late FakeLocationRepository locationRepository;
  late HomeMapViewModel viewModel;

  setUp(() {
    transitRepository = FakeTransitRepository();
    locationRepository = FakeLocationRepository();

    viewModel = HomeMapViewModel(
      repository: transitRepository,
      locationRepository: locationRepository,
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('inizializza lo stato correttamente', () {
    expect(viewModel.stops, isEmpty);
    expect(viewModel.userLocation, isNull);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.isLocating, isFalse);
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.locationErrorMessage, isNull);
  });

  test('carica le fermate della mappa dal repository', () async {
    await viewModel.loadStops();

    expect(transitRepository.getMapStopsCalled, isTrue);
    expect(viewModel.stops, isEmpty);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, isNull);
  });

  test('notifica i listener durante il caricamento delle fermate', () async {
    var notificationCount = 0;

    viewModel.addListener(() {
      notificationCount++;
    });

    await viewModel.loadStops();

    expect(notificationCount, greaterThanOrEqualTo(2));
  });

  test('gestisce errore durante il caricamento delle fermate', () async {
    transitRepository.shouldThrowOnGetMapStops = true;

    await viewModel.loadStops();

    expect(transitRepository.getMapStopsCalled, isTrue);
    expect(viewModel.stops, isEmpty);
    expect(viewModel.isLoading, isFalse);
    expect(
      viewModel.errorMessage,
      'Impossibile caricare le fermate sulla mappa.',
    );
  });

  test(
    'locateUser restituisce permissionDenied senza leggere la posizione',
    () async {
      locationRepository.accessResult = LocationAccessResult.permissionDenied;

      final result = await viewModel.locateUser();

      expect(result, LocationAccessResult.permissionDenied);
      expect(locationRepository.ensureLocationAccessCalled, isTrue);
      expect(locationRepository.getCurrentLocationCalled, isFalse);
      expect(viewModel.isLocating, isFalse);
      expect(viewModel.userLocation, isNull);
    },
  );

  test(
    'locateUser restituisce serviceDisabled senza leggere la posizione',
    () async {
      locationRepository.accessResult = LocationAccessResult.serviceDisabled;

      final result = await viewModel.locateUser();

      expect(result, LocationAccessResult.serviceDisabled);
      expect(locationRepository.ensureLocationAccessCalled, isTrue);
      expect(locationRepository.getCurrentLocationCalled, isFalse);
      expect(viewModel.isLocating, isFalse);
      expect(viewModel.userLocation, isNull);
    },
  );

  test(
    'locateUser restituisce permissionDeniedForever senza leggere la posizione',
    () async {
      locationRepository.accessResult =
          LocationAccessResult.permissionDeniedForever;

      final result = await viewModel.locateUser();

      expect(result, LocationAccessResult.permissionDeniedForever);
      expect(locationRepository.ensureLocationAccessCalled, isTrue);
      expect(locationRepository.getCurrentLocationCalled, isFalse);
      expect(viewModel.isLocating, isFalse);
      expect(viewModel.userLocation, isNull);
    },
  );

  test('locateUser gestisce errore durante il recupero posizione', () async {
    locationRepository.accessResult = LocationAccessResult.granted;
    locationRepository.shouldThrowOnCurrentLocation = true;

    final result = await viewModel.locateUser();

    expect(result, LocationAccessResult.unavailable);
    expect(locationRepository.ensureLocationAccessCalled, isTrue);
    expect(locationRepository.getCurrentLocationCalled, isTrue);
    expect(viewModel.isLocating, isFalse);
    expect(viewModel.userLocation, isNull);
    expect(
      viewModel.locationErrorMessage,
      'Impossibile rilevare la posizione attuale. Riprova tra qualche secondo.',
    );
  });

  test('openLocationSettings delega al repository', () async {
    final result = await viewModel.openLocationSettings();

    expect(result, isTrue);
    expect(locationRepository.openLocationSettingsCalled, isTrue);
  });

  test('openAppSettings delega al repository', () async {
    final result = await viewModel.openAppSettings();

    expect(result, isTrue);
    expect(locationRepository.openAppSettingsCalled, isTrue);
  });
}
