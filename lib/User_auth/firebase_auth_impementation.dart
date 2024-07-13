import 'package:firebase_auth/firebase_auth.dart';
import 'package:onroadvehiclebreakdowwn/Common/toast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast(message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showToast(message: "The email already in use.");
      } else {
        showToast(message: "An error occurred: ${e.code}");
      }
      rethrow; // rethrow the exception to propagate the error
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == "wrong-password") {
        showProgress(message: "Invalid email or password");
      } else {
        showProgress(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  signUpWithEmailAndPassword(String email, String password) {}
}
