import 'package:firebase_auth/firebase_auth.dart';
import 'package:route_nxt/features/common/domain/entity/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Future<UserModel?> signUpUser(
      String email,
      String password,
      ) async {
    try {
      final UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      } else {
        return UserModel.empty;
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> getUserStream() {
    return _firebaseAuth.authStateChanges();
  }

}