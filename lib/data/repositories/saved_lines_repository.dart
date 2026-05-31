import '../services/saved_lines_service.dart';

/// Espone al ViewModel operazioni orientate al dominio dei preferiti.
/// Il ViewModel non deve conoscere Cloud Firestore.
class SavedLinesRepository {
  const SavedLinesRepository(this._service);

  final SavedLinesService _service;

  Stream<Set<String>> watchSavedLineIds({required String userId}) {
    return _service.watchSavedLineIds(userId: userId);
  }

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