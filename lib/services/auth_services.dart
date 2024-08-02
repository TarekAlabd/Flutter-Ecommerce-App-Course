import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServices {
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> registerWithEmailAndPassword(String email, String password);
}

class AuthServicesImpl implements AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> registerWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
