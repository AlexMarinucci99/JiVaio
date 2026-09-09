import 'package:cloud_firestore/cloud_firestore.dart';

import '../saved_lines_service.dart';

/// Implementa [SavedLinesService] usando Cloud Firestore.
///
/// Questo service è l'unico punto dell'app che conosce la struttura
/// della collection usata per salvare le linee preferite dell'utente.
class FirestoreSavedLinesService implements SavedLinesService {
  FirestoreSavedLinesService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _savedLinesCollection(
    String userId,
  ) => _firestore.collection('users').doc(userId).collection('saved_lines');

  DocumentReference<Map<String, dynamic>> _savedLineDocument({
    required String userId,
    required String routeId,
  }) => _savedLinesCollection(userId).doc(Uri.encodeComponent(routeId));

  @override
  Stream<Set<String>> watchSavedLineIds({required String userId}) =>
      _savedLinesCollection(userId).snapshots().map(
        (snapshot) => snapshot.docs
            .map((document) => document.data()['routeId'])
            .whereType<String>()
            .toSet(),
      );

  @override
  Future<void> saveLine({required String userId, required String routeId}) =>
      _savedLineDocument(
        userId: userId,
        routeId: routeId,
      ).set({'routeId': routeId, 'savedAt': FieldValue.serverTimestamp()});

  @override
  Future<void> removeLine({required String userId, required String routeId}) =>
      _savedLineDocument(userId: userId, routeId: routeId).delete();
}
