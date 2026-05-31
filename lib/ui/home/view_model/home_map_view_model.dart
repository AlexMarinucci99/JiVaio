import 'package:flutter/foundation.dart';

import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_stop.dart';

class HomeMapViewModel extends ChangeNotifier {
  HomeMapViewModel({required TransitRepository repository})
    : _repository = repository;

  final TransitRepository _repository;

  List<TransitStop> _stops = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransitStop> get stops => _stops;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadStops() async {
    if (_isLoading || _stops.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stops = await _repository.getMapStops();
    } catch (_) {
      _errorMessage = 'Impossibile caricare le fermate sulla mappa.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}