import 'package:flutter/foundation.dart';

import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_line.dart';
import '../line_time_range_formatter.dart';

/// Posizione dichiarata dall'utente durante una segnalazione.
enum LineDetailReportLocation { onBus, atStop }

/// Tipo di segnalazione.//affollamento.
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

  int? _selectedManualHour;

  LineDetailReportLocation? _reportLocation;
  String? _selectedReportStopId;
  String? _lastReportMessage;

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

    if (directions.isEmpty) return null;
    final index = _selectedDirectionIndex < directions.length
        ? _selectedDirectionIndex
        : 0;
    return directions[index];
  }

  List<TransitLineDeparture> get departures =>
      _schedule?.departures ?? const <TransitLineDeparture>[];

  List<TransitLineStop> get stops =>
      _schedule?.stops ?? const <TransitLineStop>[];

  /// Etichetta della fascia oraria mostrata.
  String get timeRangeLabel => formatLineTimeRange(_selectedMoment().hour);

  bool get requiresStopSelection => _reportLocation != null;

  bool get canSendReport =>
      requiresStopSelection && _selectedReportStopId != null;

  /// Nome della fermata selezionata per la segnalazione.
  String? get selectedReportStopName {
    final selectedStopId = _selectedReportStopId;

    if (selectedStopId == null) return null;

    for (final stop in stops) {
      if (stop.stopId == selectedStopId) return stop.name;
    }

    return null;
  }

  /// Carica partenze e fermate della direzione selezionata.
  Future<void> loadSchedule() async {
    final direction = selectedDirection;

    if (direction == null) {
      _schedule = null;
      notifyListeners();
      return;
    }

    try {
      _schedule = await _repository.getLineDirectionSchedule(
        line: line,
        direction: direction,
        moment: _selectedMoment(),
      );
    } catch (_) {
      _schedule = null;
    } finally {
      if (hasListeners) notifyListeners();
    }
  }

  /// Cambia direzione e ricarica gli orari disponibili.
  Future<void> toggleDirection() async {
    if (!canSwapDirection) return;

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

  Future<void> _selectTime([int? hour]) {
    _selectedManualHour = hour;
    _lastReportMessage = null;

    return loadSchedule();
  }

  /// Seleziona la posizione da cui l'utente sta segnalando un problema.
  void selectReportLocation(LineDetailReportLocation location) {
    if (_reportLocation == location) return;

    _reportLocation = location;
    _lastReportMessage = null;

    notifyListeners();
  }

  /// Seleziona la fermata associata alla segnalazione.
  void selectReportStop(String stopId) {
    if (!requiresStopSelection) return;

    _selectedReportStopId = stopId;
    _lastReportMessage = null;

    notifyListeners();
  }

  /// Registra una segnalazione dimostrativa di tipo [type].
  ///
  /// In questa fase non invia dati a una sorgente esterna: aggiorna soltanto
  /// il messaggio mostrato dalla UI.
  void sendFakeReport(LineDetailReportType type) {
    if (!canSendReport) return;

    final reportLabel = type == LineDetailReportType.delay
        ? 'Ritardo'
        : 'Bus pieno';

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

    if (selectedHour == null) return now;
    return DateTime(now.year, now.month, now.day, selectedHour);
  }
}
