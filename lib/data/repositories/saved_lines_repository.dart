import '../services/saved_lines_service.dart';

/// Gestisce l'accesso ai dati delle linee preferite.
///
/// Espone ai ViewModel un'API stabile e nasconde la sorgente dati concreta
/// usata per salvare o rimuovere le linee preferite.
class SavedLinesRepository {
  const SavedLinesRepository(this._service);

  final SavedLinesService _service;

  Stream<Set<String>> watchSavedLineIds({required String userId}) {
    return _service.watchSavedLineIds(userId: userId);
  }

  /// Aggiorna lo stato di salvataggio della linea [routeId].
  ///
  /// Converte il valore booleano [isSaved] nell'operazione corretta
  /// verso il service: salvataggio oppure rimozione.
  Future<void> setLineSaved({
    required String userId,
    required String routeId,
    required bool isSaved,
  }) async {
    if (isSaved) {
      await _service.saveLine(userId: userId, routeId: routeId);
      return;
    }

    await _service.removeLine(userId: userId, routeId: routeId);
  }
}
