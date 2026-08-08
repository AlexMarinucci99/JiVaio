import 'package:flutter/foundation.dart';

import '../../../data/repositories/route_planning_repository.dart';
import '../../../domain/models/route_result.dart';

/// Gestisce caricamento e stato già pronto per la schermata risultati.
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

  RouteResult get _loadedResult => _result!;

  String get departureDescription {
    final time = _loadedResult.departureTime;
    return time == null || time.isEmpty
        ? _loadedResult.origin
        : '${_loadedResult.origin}\nPartenza prevista: $time';
  }

  String get boardingStopDescription => _loadedResult.boardingStopName;

  String get recommendedLineDescription {
    final times = _loadedResult.nextBusTimes;
    final nextTime = times.isEmpty ? null : times.first;
    return nextTime == null || nextTime.isEmpty
        ? 'Linea ${_loadedResult.lineCode}'
        : 'Linea ${_loadedResult.lineCode}\nProssima corsa: $nextTime';
  }

  String get durationDescription {
    final duration = _loadedResult.totalDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) return '$hours h $minutes min';
    if (hours > 0) return '$hours h';
    return '$minutes min';
  }

  String get arrivalDescription {
    final time = _loadedResult.arrivalTime;
    return time == null || time.isEmpty
        ? _loadedResult.destination
        : '${_loadedResult.destination}\nArrivo previsto: $time';
  }

  Future<void> loadRoute() async {
    if (_isDisposed || _isLoading) return;

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
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
