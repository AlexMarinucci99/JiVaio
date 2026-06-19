/// Definisce il contratto per le sorgenti dati delle linee salvate.
///
/// Il repository dipende da questa astrazione invece che da Firestore,
/// così la sorgente dati resta sostituibile nei test o in implementazioni future.
abstract class SavedLinesService {
  Stream<Set<String>> watchSavedLineIds({required String userId});

  Future<void> saveLine({required String userId, required String routeId});

  Future<void> removeLine({required String userId, required String routeId});
}
