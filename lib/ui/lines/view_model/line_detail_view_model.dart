import 'package:flutter/material.dart';

import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_line.dart';
import '../widgets/line_card/line_card_colors.dart';

enum LineDetailReportLocation { onBus, atStop }

enum LineDetailReportType { delay, crowding }

class LineDetailViewModel extends ChangeNotifier {
  LineDetailViewModel({
    required TransitLine line,
    TransitRepository? repository,
    this.colors = LineCardColors.defaultPalette,
  }) : _line = line,
       _repository = repository ?? TransitRepository();

  final TransitLine _line;
  final TransitRepository _repository;

  // Palette condivisa con la feature linee.
  final LineCardPalette colors;

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

  List<int> get manualHours {
    return List<int>.generate(18, (index) => index + 5, growable: false);
  }

  Color get lineColor {
    return LineCardColors.parseLineColor(_line.routeColor, colors: colors);
  }

  bool get hasDirections {
    return _line.directions.isNotEmpty;
  }

  bool get canSwapDirection {
    return _line.directions.length > 1;
  }

  bool get canToggleDirection {
    return canSwapDirection && !_line.isUnidirectional;
  }

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

  String get timeRangeLabel {
    final schedule = _schedule;

    if (schedule != null) {
      return schedule.timeRangeLabel;
    }

    return _formatHourRange(_selectedMoment());
  }

  String get emptyDeparturesMessage {
    final schedule = _schedule;

    if (schedule == null) {
      return 'Partenze non ancora caricate.';
    }

    return schedule.emptyDeparturesMessage;
  }

  bool get requiresStopSelection {
    return _reportLocation == LineDetailReportLocation.atStop;
  }

  bool get canSendReport {
    if (_reportLocation == LineDetailReportLocation.onBus) {
      return true;
    }

    if (_reportLocation == LineDetailReportLocation.atStop) {
      return _selectedReportStopId != null;
    }

    return false;
  }

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

  Future<void> selectAutomaticTime() async {
    _isAutomaticTime = true;
    _selectedManualHour = null;
    _lastReportMessage = null;

    await loadSchedule();
  }

  Future<void> selectManualHour(int hour) async {
    _isAutomaticTime = false;
    _selectedManualHour = hour;
    _lastReportMessage = null;

    await loadSchedule();
  }

  void selectReportLocation(LineDetailReportLocation location) {
    if (_reportLocation == location) {
      return;
    }

    _reportLocation = location;
    _lastReportMessage = null;

    if (location == LineDetailReportLocation.onBus) {
      _selectedReportStopId = null;
    }

    notifyListeners();
  }

  void selectReportStop(String stopId) {
    if (!requiresStopSelection) {
      return;
    }

    _selectedReportStopId = stopId;
    _lastReportMessage = null;

    notifyListeners();
  }

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
