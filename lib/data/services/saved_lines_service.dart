import 'package:cloud_firestore/cloud_firestore.dart';

/// Accesso diretto a Cloud Firestore per i preferiti delle linee.
///
/// Struttura dati:
class SavedLinesService {
  SavedLinesService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _savedLinesCollection(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId).collection('saved_lines');
  }

  DocumentReference<Map<String, dynamic>> _savedLineDocument({
    required String userId,
    required String routeId,
  }) {
    return _savedLinesCollection(userId).doc(Uri.encodeComponent(routeId));
  }

  Stream<Set<String>> watchSavedLineIds({required String userId}) {
    return _savedLinesCollection(userId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((document) => document.data()['routeId'])
          .whereType<String>()
          .toSet();
    });
  }

  Future<void> saveLine({
    required String userId,
    required String routeId,
  }) async {
    await _savedLineDocument(userId: userId, routeId: routeId).set({
      'routeId': routeId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeLine({
    required String userId,
    required String routeId,
  }) async {
    await _savedLineDocument(userId: userId, routeId: routeId).delete();
  }
}