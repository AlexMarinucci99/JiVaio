import 'package:flutter/foundation.dart';

import '../../../domain/models/transit_line.dart';

enum LinesScope { all, saved }

class LinesViewModel extends ChangeNotifier {
  LinesScope _scope = LinesScope.all;

  // Salvataggi temporanei in memoria.
  // Per ora non sono persistenti: se riavvii l'app si azzerano.
  final Set<String> _savedLineIds = <String>{};

  // Dati mock iniziali.
  // Più avanti questa lista arriverà da repository/database.
  final List<TransitLine> _lines = const [
    TransitLine(
      routeId: 'line_1',
      shortName: '1',
      displayName: 'Terminal-C.C.L’Aquilone ',
      routeLongName: 'Terminal Bus - Università - Coppito',
      routeColor: '2F80ED',
      directions: [
        TransitLineDirection(
          key: 'outbound',
          originName: 'Terminal Bus',
          destinationName: 'Coppito',
          stopCount: 18,
          upcomingDepartures: ['08:10', '08:35', '09:05'],
        ),
        TransitLineDirection(
          key: 'return',
          originName: 'Coppito',
          destinationName: 'Terminal Bus',
          stopCount: 18,
          upcomingDepartures: ['08:22', '08:52', '09:20'],
        ),
      ],
    ),
    TransitLine(
      routeId: 'line_2',
      shortName: '2U',
      displayName: 'Terminal-C.C.L’Aquilone',
      routeLongName: 'Centro - Ospedale - Pettino',
      routeColor: '10B981',
      directions: [
        TransitLineDirection(
          key: 'outbound',
          originName: 'Centro',
          destinationName: 'Pettino',
          stopCount: 14,
          upcomingDepartures: ['08:18', '08:48', '09:18'],
        ),
        TransitLineDirection(
          key: 'return',
          originName: 'Pettino',
          destinationName: 'Centro',
          stopCount: 14,
          upcomingDepartures: ['08:30', '09:00', '09:30'],
        ),
      ],
    ),
    TransitLine(
      routeId: 'line_2u',
      shortName: '6D',
      displayName: 'Paganica-Terminal-L’Aquilone',
      routeLongName: 'Terminal - Polo Universitario',
      routeColor: 'F59E0B',
      directions: [
        TransitLineDirection(
          key: 'outbound',
          originName: 'Collemaggio',
          destinationName: 'Polo Universitario',
          stopCount: 11,
          upcomingDepartures: ['08:25', '09:05', '09:45'],
        ),
      ],
    ),
  ];

  LinesScope get scope => _scope;

  List<TransitLine> get allLines => _lines;

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
