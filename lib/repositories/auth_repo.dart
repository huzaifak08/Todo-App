import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/exports.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool checkLoggedInStatus() {
    try {
      if (_firebaseAuth.currentUser != null &&
          _firebaseAuth.currentUser!.uid.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> signUpUser({required UserModel user}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return 'Welcome to Todo';
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Welcome to Todo';
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return 'See you soon Buddy';
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "We've send you an email, Please open your email and click the link";
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> changePassword({required String password}) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updatePassword(password);
        return "Password Changes Successfully";
      } else {
        return "Please Login First";
      }
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> saveUserData(
      {required UserModel user, required File picFile}) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;

      String url = await storeFile('profilePics/$uid', picFile);

      if (picFile.path.isNotEmpty) {
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': user.name,
          'phone': user.phone,
          'email': user.email,
          'password': user.password,
          'profilePic': url,
        });

        return 'Account created Successfully';
      } else {
        throw Exception('Profile Picture is compulsory');
      }
    } on FirebaseException catch (exception) {
      throw Exception(exception.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // Store File:
  Future<String> storeFile(String path, File file) async {
    UploadTask uploadTask = _storage.ref().child(path).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  // Google Auth:
  Future<String> logInWithGoogle() async {
    final googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return 'Google Account Not Found';
      } else {
        final googleSignInAuth = await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuth.accessToken,
            idToken: googleSignInAuth.idToken);

        await FirebaseAuth.instance.signInWithCredential(credential);

        final userDoc = await _firestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.uid)
            .get();

        if (userDoc.exists) {
          return 'User Already Exists';
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_firebaseAuth.currentUser!.uid)
              .set({
            'email': googleSignInAccount.email,
            'profilePic': googleSignInAccount.photoUrl,
            'name': googleSignInAccount.displayName,
            'uid': googleSignInAccount.id,
            'phone': 00000000000,
            'password': '123456'
          });
        }

        return 'Welcome using Google';
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } on PlatformException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
