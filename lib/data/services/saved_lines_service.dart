/// Definisce il contratto per le sorgenti dati delle linee salvate.
///
/// Il repository dipende da questa astrazione.
abstract class SavedLinesService {
  Stream<Set<String>> watchSavedLineIds({required String userId});

  Future<void> saveLine({required String userId, required String routeId});

  Future<void> removeLine({required String userId, required String routeId});
}
