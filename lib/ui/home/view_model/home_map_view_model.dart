import 'package:flutter/foundation.dart';

import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/location_access_result.dart';
import '../../../domain/models/transit_stop.dart';
import '../../../domain/models/user_location.dart';

class HomeMapViewModel extends ChangeNotifier {
  HomeMapViewModel({
    required TransitRepository repository,
    required LocationRepository locationRepository,
  }) : _transitRepository = repository,
       _locationRepository = locationRepository;

  final TransitRepository _transitRepository;
  final LocationRepository _locationRepository;

  List<TransitStop> _stops = const [];
  UserLocation? _userLocation;

  bool _isLoading = false;
  bool _isLocating = false;
  bool _isDisposed = false;

  String? _errorMessage;
  String? _locationErrorMessage;

  List<TransitStop> get stops => _stops;

  UserLocation? get userLocation => _userLocation;

  bool get isLoading => _isLoading;

  bool get isLocating => _isLocating;

  String? get errorMessage => _errorMessage;

  String? get locationErrorMessage => _locationErrorMessage;

  Future<void> loadStops() async {
    if (_isLoading || _stops.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _notifyListenersSafely();

    try {
      _stops = await _transitRepository.getMapStops();
    } catch (_) {
      _errorMessage = 'Impossibile caricare le fermate sulla mappa.';
    } finally {
      _isLoading = false;
      _notifyListenersSafely();
    }
  }

  Future<LocationAccessResult> locateUser() async {
    if (_isLocating) {
      return _userLocation == null
          ? LocationAccessResult.unavailable
          : LocationAccessResult.granted;
    }

    _isLocating = true;
    _locationErrorMessage = null;
    _notifyListenersSafely();

    try {
      final accessResult = await _locationRepository.ensureLocationAccess();

      if (accessResult != LocationAccessResult.granted) {
        return accessResult;
      }

      _userLocation = await _locationRepository.getCurrentLocation();

      return LocationAccessResult.granted;
    } catch (_) {
      _locationErrorMessage =
          'Impossibile rilevare la posizione attuale. Riprova tra qualche secondo.';

      return LocationAccessResult.unavailable;
    } finally {
      _isLocating = false;
      _notifyListenersSafely();
    }
  }

  Future<bool> openLocationSettings() {
    return _locationRepository.openLocationSettings();
  }

  Future<bool> openAppSettings() {
    return _locationRepository.openAppSettings();
  }

  void _notifyListenersSafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
