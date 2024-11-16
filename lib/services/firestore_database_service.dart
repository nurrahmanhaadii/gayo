import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save temporary registration data
  Future<void> saveTemporaryRegistrationData(
      String userId, Map<String, dynamic> data) async {
    try {
      // Saving data in the 'users/temporary/temporaryUsers' collection
      await _firestore
          .collection('users')
          .doc('temporary')
          .collection('temporaryUsers')
          .doc(userId)
          .set(data);
    } catch (e) {
      print("Error saving temporary data: $e");
    }
  }

  // Complete registration by moving data to permanent profile
  Future<void> completeRegistration(
      String userId, Map<String, dynamic> data) async {
    try {
      // Saving data in the main 'users' collection
      await _firestore.collection('users').doc(userId).set(data);

      // Delete the temporary record in 'users/temporary/temporaryUsers'
      // await _firestore
      //     .collection('users')
      //     .doc('temporary')
      //     .collection('temporaryUsers')
      //     .doc(userId)
      //     .delete();
    } catch (e) {
      print("Error completing registration: $e");
    }
  }
}
