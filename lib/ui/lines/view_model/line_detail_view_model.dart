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
    required this.line,
    required TransitRepository repository,
  }) : _repository = repository;

  final TransitLine line;
  final TransitRepository _repository;

  int _selectedDirectionIndex = 0;

  TransitLineDirectionSchedule? _schedule;

  bool _isLoadingSchedule = false;
  String? _errorMessage;

  int? _selectedManualHour;

  LineDetailReportLocation? _reportLocation;
  String? _selectedReportStopId;
  String? _lastReportMessage;

  bool get isLoadingSchedule => _isLoadingSchedule;

  String? get errorMessage => _errorMessage;

  int? get selectedManualHour => _selectedManualHour;

  LineDetailReportLocation? get reportLocation => _reportLocation;

  String? get selectedReportStopId => _selectedReportStopId;

  String? get lastReportMessage => _lastReportMessage;

  /// Ore selezionabili manualmente.
  List<int> get manualHours =>
      List<int>.generate(18, (index) => index + 5, growable: false);

  /// Indica se l'utente può invertire la direzione dalla UI.
  ///
  /// Le linee monodirezionali possono avere più direzioni nei dati,
  /// ma nel prototipo non devono mostrare il cambio direzione.
  bool get canSwapDirection =>
      line.directions.length > 1 && !line.isUnidirectional;

  /// Direzione attualmente selezionata.
  ///
  /// Usa la prima direzione come fallback se l'indice salvato non è più valido.
  TransitLineDirection? get selectedDirection {
    final directions = line.directions;

    if (directions.isEmpty) {
      return null;
    }

    if (_selectedDirectionIndex >= directions.length) {
      return directions.first;
    }

    return directions[_selectedDirectionIndex];
  }

  List<TransitLineDeparture> get departures =>
      _schedule?.departures ?? const <TransitLineDeparture>[];

  List<TransitLineStop> get stops =>
      _schedule?.stops ?? const <TransitLineStop>[];

  String? get selectedTripId => _schedule?.selectedTripId;

  /// Etichetta della fascia oraria mostrata.
  String get timeRangeLabel =>
      _schedule?.timeRangeLabel ?? _formatHourRange(_selectedMoment());

  /// Messaggio mostrato quando non sono disponibili partenze.
  String get emptyDeparturesMessage =>
      _schedule?.emptyDeparturesMessage ?? 'Partenze non ancora caricate.';

  bool get requiresStopSelection => _reportLocation != null;

  bool get canSendReport =>
      _reportLocation != null && _selectedReportStopId != null;

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
        line: line,
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
    if (!canSwapDirection) {
      return;
    }

    _selectedDirectionIndex =
        (_selectedDirectionIndex + 1) % line.directions.length;

    _selectedReportStopId = null;
    _lastReportMessage = null;

    await loadSchedule();
  }

  /// Ripristina la fascia oraria automatica e ricarica gli orari.
  Future<void> selectAutomaticTime() => _selectTime();

  /// Seleziona manualmente [hour] e ricarica gli orari.
  Future<void> selectManualHour(int hour) => _selectTime(hour);

  Future<void> _selectTime([int? hour]) async {
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
    final selectedHour = _selectedManualHour;

    if (selectedHour == null) {
      return now;
    }

    return DateTime(now.year, now.month, now.day, selectedHour);
  }

  static String _formatHourRange(DateTime hourStart) {
    final startHour = hourStart.hour;
    final endHour = startHour + 1;

    return '${startHour.toString().padLeft(2, '0')}:00 - '
        '${endHour.toString().padLeft(2, '0')}:00';
  }
}