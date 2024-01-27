import 'package:todo_app/exports.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signUpUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Welcome to Todo';
    } on FirebaseAuthException catch (err) {
      return (err.message.toString());
    } catch (err) {
      return (err.toString());
    }
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Welcome to Todo';
    } on FirebaseAuthException catch (err) {
      return (err.message.toString());
    } catch (err) {
      return (err.toString());
    }
  }

  Future<String> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return 'See you soon Buddy';
    } on FirebaseAuthException catch (err) {
      return (err.message.toString());
    } catch (err) {
      return (err.toString());
    }
  }
}
