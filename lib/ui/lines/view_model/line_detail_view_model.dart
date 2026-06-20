import 'package:flutter/foundation.dart';

import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_line.dart';

/// Posizione dichiarata dall'utente durante una segnalazione.
enum LineDetailReportLocation { onBus, atStop }

/// Tipo di segnalazione.
enum LineDetailReportType { delay, crowding }

/// Gestisce stato e azioni della schermata di dettaglio linea.
///
/// Coordina la linea selezionata, la direzione attiva, il caricamento
/// di partenze e fermate, la scelta dell'orario e la segnalazione mock.
class LineDetailViewModel extends ChangeNotifier {
  LineDetailViewModel({
    required TransitLine line,
    required TransitRepository repository,
  }) : _line = line,
       _repository = repository;

  final TransitLine _line;
  final TransitRepository _repository;

  int _selectedDirectionIndex = 0;

  TransitLineDirectionSchedule? _schedule;

  bool _isLoadingSchedule = false;
  String? _errorMessage;

  bool _isAutomaticTime = true;
  int? _selectedManualHour;

  LineDetailReportLocation? _reportLocation;
  String? _selectedReportStopId;
  String? _lastReportMessage;

  TransitLine get line => _line;

  int get selectedDirectionIndex => _selectedDirectionIndex;

  TransitLineDirectionSchedule? get schedule => _schedule;

  bool get isLoadingSchedule => _isLoadingSchedule;

  String? get errorMessage => _errorMessage;

  bool get isAutomaticTime => _isAutomaticTime;

  int? get selectedManualHour => _selectedManualHour;

  LineDetailReportLocation? get reportLocation => _reportLocation;

  String? get selectedReportStopId => _selectedReportStopId;

  String? get lastReportMessage => _lastReportMessage;

  /// Ore selezionabili manualmente
  List<int> get manualHours {
    return List<int>.generate(18, (index) => index + 5, growable: false);
  }

  bool get hasDirections {
    return _line.directions.isNotEmpty;
  }

  bool get canSwapDirection {
    return _line.directions.length > 1;
  }

  /// Indica se la direzione può essere cambiata dalla UI.
  ///
  /// Le linee monodirezionali possono avere più dati interni, ma nel prototipo
  /// vengono trattate come direzione unica.
  bool get canToggleDirection {
    return canSwapDirection && !_line.isUnidirectional;
  }

  /// Direzione attualmente selezionata.
  ///
  /// Usa la prima direzione come fallback se l'indice salvato non è più valido.
  TransitLineDirection? get selectedDirection {
    if (_line.directions.isEmpty) {
      return null;
    }

    if (_selectedDirectionIndex >= _line.directions.length) {
      return _line.directions.first;
    }

    return _line.directions[_selectedDirectionIndex];
  }

  List<TransitLineDeparture> get departures {
    return _schedule?.departures ?? const <TransitLineDeparture>[];
  }

  List<TransitLineStop> get stops {
    return _schedule?.stops ?? const <TransitLineStop>[];
  }

  String? get selectedTripId {
    return _schedule?.selectedTripId;
  }

  /// Etichetta della fascia oraria mostrata.
  String get timeRangeLabel {
    final schedule = _schedule;

    if (schedule != null) {
      return schedule.timeRangeLabel;
    }

    return _formatHourRange(_selectedMoment());
  }

  /// Messaggio mostrato quando non sono diponibili partenze.
  String get emptyDeparturesMessage {
    final schedule = _schedule;

    if (schedule == null) {
      return 'Partenze non ancora caricate.';
    }

    return schedule.emptyDeparturesMessage;
  }

  bool get requiresStopSelection {
    return _reportLocation != null;
  }

  bool get canSendReport {
    return _reportLocation != null && _selectedReportStopId != null;
  }

  /// Nome della fermata selezionata per la segnalazione.
  String? get selectedReportStopName {
    final selectedStopId = _selectedReportStopId;

    if (selectedStopId == null) {
      return null;
    }

    for (final stop in stops) {
      if (stop.stopId == selectedStopId) {
        return stop.name;
      }
    }

    return null;
  }

  /// Carica partenze e fermate della direzione selezionata.
  Future<void> loadSchedule() async {
    final direction = selectedDirection;

    if (direction == null) {
      _schedule = null;
      _errorMessage = 'Direzione non disponibile.';
      notifyListeners();
      return;
    }

    _isLoadingSchedule = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schedule = await _repository.getLineDirectionSchedule(
        line: _line,
        direction: direction,
        moment: _selectedMoment(),
      );
    } catch (_) {
      _errorMessage = 'Impossibile caricare partenze e fermate.';
    } finally {
      _isLoadingSchedule = false;
      notifyListeners();
    }
  }

  /// Cambia direzione e ricarica gli orari disponibili.
  Future<void> toggleDirection() async {
    if (!canToggleDirection) {
      return;
    }

    _selectedDirectionIndex =
        (_selectedDirectionIndex + 1) % _line.directions.length;

    _selectedReportStopId = null;
    _lastReportMessage = null;

    await loadSchedule();
  }

  /// Ripristina la fascia oraria autmatica e ricarica gli orari.
  Future<void> selectAutomaticTime() async {
    _isAutomaticTime = true;
    _selectedManualHour = null;
    _lastReportMessage = null;

    await loadSchedule();
  }

  /// Seleziona manualmente [hour] e ricarica gli orari.
  Future<void> selectManualHour(int hour) async {
    _isAutomaticTime = false;
    _selectedManualHour = hour;
    _lastReportMessage = null;

    await loadSchedule();
  }

  /// Seleziona la posizione da cui l'utente sta segnalando un problema.
  void selectReportLocation(LineDetailReportLocation location) {
    if (_reportLocation == location) {
      return;
    }

    _reportLocation = location;
    _lastReportMessage = null;

    notifyListeners();
  }

  /// Seleziona la fermata associata alla segnalazione.
  void selectReportStop(String stopId) {
    if (!requiresStopSelection) {
      return;
    }

    _selectedReportStopId = stopId;
    _lastReportMessage = null;

    notifyListeners();
  }

  /// Registra una segnalazione dimostrativa di tipo [type].
  ///
  /// In questa fase non invia dati a una sorgente esterna: aggiorna soltanto
  /// il messaggio mostrato dalla UI.
  void sendFakeReport(LineDetailReportType type) {
    if (!canSendReport) {
      return;
    }

    final reportLabel = switch (type) {
      LineDetailReportType.delay => 'Ritardo',
      LineDetailReportType.crowding => 'Bus pieno',
    };

    if (_reportLocation == LineDetailReportLocation.onBus) {
      _lastReportMessage =
          '$reportLabel registrato per la linea ${line.shortName}.';
    } else {
      final stopName = selectedReportStopName ?? 'fermata selezionata';
      _lastReportMessage = '$reportLabel registrato dalla fermata "$stopName".';
    }

    notifyListeners();
  }

  DateTime _selectedMoment() {
    final now = DateTime.now();

    if (_isAutomaticTime) {
      return now;
    }

    final selectedHour = _selectedManualHour ?? now.hour;

    return DateTime(now.year, now.month, now.day, selectedHour);
  }

  String _formatHourRange(DateTime hourStart) {
    final startHour = hourStart.hour;
    final endHour = startHour + 1;

    return '${startHour.toString().padLeft(2, '0')}:00 - '
        '${endHour.toString().padLeft(2, '0')}:00';
  }
}
