import 'package:flutter/foundation.dart';

import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_line.dart';

enum LinesScope { all, saved }

class LinesViewModel extends ChangeNotifier {
  LinesViewModel({
    TransitRepository? repository,
  }) : _repository = repository ?? TransitRepository();

  final TransitRepository _repository;

  LinesScope _scope = LinesScope.all;

  final Set<String> _savedLineIds = <String>{};

  List<TransitLine> _lines = const [];

  bool _isLoading = false;
  String? _errorMessage;

  LinesScope get scope => _scope;

  List<TransitLine> get allLines => _lines;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get savedLinesCount => _savedLineIds.length;

  List<TransitLine> get visibleLines {
    if (_scope == LinesScope.all) {
      return _lines;
    }

    return _lines
        .where((line) => _savedLineIds.contains(line.routeId))
        .toList(growable: false);
  }

  String get subtitle {
    if (_isLoading && _lines.isEmpty) {
      return 'Caricamento delle linee disponibili...';
    }

    if (_errorMessage != null && _lines.isEmpty) {
      return 'Non è stato possibile caricare le linee.';
    }

    if (_scope == LinesScope.saved) {
      if (savedLinesCount == 0) {
        return 'Salva le linee che usi di più per ritrovarle qui.';
      }

      return savedLinesCount == 1
          ? '1 linea salvata'
          : '$savedLinesCount linee salvate';
    }

    return 'Consulta tutte le linee disponibili e apri dettaglio completo';
  }

  bool isLineSaved(String routeId) {
    return _savedLineIds.contains(routeId);
  }

  Future<void> loadLines() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lines = await _repository.getLines();
    } catch (_) {
      _errorMessage = 'Impossibile caricare i dati delle linee.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setScope(LinesScope scope) {
    if (_scope == scope) {
      return;
    }

    _scope = scope;
    notifyListeners();
  }

  void toggleSavedLine(String routeId) {
    if (_savedLineIds.contains(routeId)) {
      _savedLineIds.remove(routeId);
    } else {
      _savedLineIds.add(routeId);
    }

    notifyListeners();
  }
}