import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTemporaryUserData(
      String userId, Map<String, dynamic> userData) async {
    await _db
        .collection('users')
        .doc('temporary')
        .collection('temporaryUsers')
        .doc(userId)
        .set(userData);
  }

  Future<void> completeKYC(
      String userId, Map<String, dynamic> verifiedUserData) async {
    // Move data from temporary to main users collection
    await _db.collection('users').doc(userId).set(verifiedUserData);

    // Delete the temporary data
    await _db
        .collection('users')
        .doc('temporary')
        .collection('temporaryUsers')
        .doc(userId)
        .delete();
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    DocumentSnapshot snapshot = await _db.collection('users').doc(userId).get();
    return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
  }
}
