import 'package:flutter/foundation.dart';

enum LinesScope {
  all,
  saved,
}

class LinesViewModel extends ChangeNotifier {
  LinesScope _scope = LinesScope.all;

  LinesScope get scope => _scope;

  String get subtitle {
    if (_scope == LinesScope.saved) {
      return 'Salva le linee che usi di più per ritrovarle qui.';
    }

    return 'Consulta tutte le linee disponibili e apri dettaglio completo';
  }

  void setScope(LinesScope scope) {
    if (_scope == scope) {
      return;
    }

    _scope = scope;
    notifyListeners();
  }
}