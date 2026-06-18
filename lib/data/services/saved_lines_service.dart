/// Contratto per le sorgenti dati delle linee salvate.
///
/// Permette al repository di non dipendere direttamente da Firestore
/// e rende sostituibile la sorgente dati nei test o in future implementazioni.
abstract class SavedLinesService {
  Stream<Set<String>> watchSavedLineIds({required String userId});

  Future<void> saveLine({required String userId, required String routeId});

  Future<void> removeLine({required String userId, required String routeId});
}
