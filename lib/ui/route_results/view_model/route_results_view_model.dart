import 'package:flutter/foundation.dart';

import '../../../data/repositories/route_planning_repository.dart';
import '../../../domain/models/route_result.dart';

/// Gestisce lo stato della schermata dei risultati.
///
/// Non contiene widget e non decide come renderizzare i dati.
/// Espone esclusivamente stato e azioni utilizzabili dalla View.
class RouteResultsViewModel extends ChangeNotifier {
  RouteResultsViewModel({
    required RoutePlanningRepository repository,
    required String origin,
    required String destination,
  }) : assert(origin.trim().isNotEmpty),
       assert(destination.trim().isNotEmpty),
       _repository = repository,
       _origin = origin.trim(),
       _destination = destination.trim();

  final RoutePlanningRepository _repository;
  final String _origin;
  final String _destination;

  RouteResult? _result;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  RouteResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRoute() async {
    if (_isDisposed || _isLoading) {
      return;
    }

    _isLoading = true;
    _result = null;
    _errorMessage = null;
    _notifyListenersSafely();

    try {
      _result = await _repository.planRoute(
        origin: _origin,
        destination: _destination,
      );
    } catch (_) {
      _errorMessage =
          'Impossibile caricare il percorso. Riprova tra qualche secondo.';
    } finally {
      _isLoading = false;
      _notifyListenersSafely();
    }
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
