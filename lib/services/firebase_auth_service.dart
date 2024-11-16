import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registration function
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Error in registration: $e");
      return null;
    }
  }

  // Login function
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Error in login: $e");
      return null;
    }
  }

  // Logout function
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Authentication state change listener
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
