import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/saved_lines_repository.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/transit_line.dart';

/// Ambito di visualizzazione dell'elenco linee.
enum LinesScope { all, saved }

/// Gestisce stato e azioni della schermata elenco linee.
///
/// Coordina il caricamento delle linee dal repository GTFS,
/// l'ascolto delle linee salvate e il filtro tra tutte le linee
/// e quelle preferite dall'utente.
class LinesViewModel extends ChangeNotifier {
  LinesViewModel({
    required TransitRepository transitRepository,
    required SavedLinesRepository savedLinesRepository,
    required this.userId,
  }) : _transitRepository = transitRepository,
       _savedLinesRepository = savedLinesRepository {
    _listenToSavedLines();
  }

  final TransitRepository _transitRepository;
  final SavedLinesRepository _savedLinesRepository;

  /// Null soltanto in modalità guest.
  final String? userId;

  LinesScope _scope = LinesScope.all;

  Set<String> _savedLineIds = <String>{};

  /// Impedisce pressioni multiple sul cuore mentre Firestore
  /// elabora la richiesta relativa alla stessa linea.
  final Set<String> _pendingSavedLineIds = <String>{};

  List<TransitLine> _lines = const [];

  StreamSubscription<Set<String>>? _savedLinesSubscription;

  bool _isLoading = false;
  String? _errorMessage;

  LinesScope get scope => _scope;

  List<TransitLine> get allLines => _lines;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get savedLinesCount => _savedLineIds.length;

  /// Linee da mostrare in base all'ambito selezionato.
  List<TransitLine> get visibleLines {
    if (_scope == LinesScope.all) {
      return _lines;
    }

    return _lines
        .where((line) => _savedLineIds.contains(line.routeId))
        .toList(growable: false);
  }

  /// Sottotitolo descrittivo mostrato nella schermata.
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

  /// Indica se la linea [routeId] è salvata dall'utente.
  bool isLineSaved(String routeId) {
    return _savedLineIds.contains(routeId);
  }

  /// Carica l'elenco delle linee disponibili.
  Future<void> loadLines() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lines = await _transitRepository.getLines();
    } catch (_) {
      _errorMessage = 'Impossibile caricare i dati delle linee.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cambia l'ambito di visualizzazione dell'elenco linee.
  void setScope(LinesScope scope) {
    if (_scope == scope) {
      return;
    }

    _scope = scope;
    notifyListeners();
  }

  /// Aggiorna lo stato di salvataggio della linea [routeId].
  ///
  /// Usa un aggiornamento ottimistico: il cuore cambia subito e, se Firestore
  /// restituisce un errore, lo stato precedente viene ripristinato.
  Future<bool> toggleSavedLine(String routeId) async {
    final currentUserId = userId;

    if (currentUserId == null) {
      return false;
    }

    if (_pendingSavedLineIds.contains(routeId)) {
      return true;
    }

    final wasSaved = _savedLineIds.contains(routeId);
    final shouldSave = !wasSaved;

    _pendingSavedLineIds.add(routeId);
    _setSavedLocally(routeId: routeId, isSaved: shouldSave);
    notifyListeners();

    try {
      await _savedLinesRepository.setLineSaved(
        userId: currentUserId,
        routeId: routeId,
        isSaved: shouldSave,
      );

      return true;
    } catch (_) {
      _setSavedLocally(routeId: routeId, isSaved: wasSaved);
      return false;
    } finally {
      _pendingSavedLineIds.remove(routeId);
      notifyListeners();
    }
  }

  void _listenToSavedLines() {
    final currentUserId = userId;

    if (currentUserId == null) {
      return;
    }

    _savedLinesSubscription = _savedLinesRepository
        .watchSavedLineIds(userId: currentUserId)
        .listen(
          (savedLineIds) {
            _savedLineIds = savedLineIds;
            notifyListeners();
          },
          onError: (_) {
            // Le linee restano consultabili anche se Firestore
            // non è temporaneamente raggiungibile.
          },
        );
  }

  void _setSavedLocally({required String routeId, required bool isSaved}) {
    if (isSaved) {
      _savedLineIds.add(routeId);
      return;
    }

    _savedLineIds.remove(routeId);
  }

  @override
  void dispose() {
    _savedLinesSubscription?.cancel();
    super.dispose();
  }
}
