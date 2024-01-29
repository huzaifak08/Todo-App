import 'package:todo_app/exports.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Users Profile Data:
  Future<UserModel> getUserData() async {
    UserModel userData = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      return UserModel(
          uid: snapshot['uid'],
          name: snapshot['name'],
          phone: snapshot['phone'],
          email: snapshot['email'],
          password: snapshot['password'],
          profilePic: snapshot['profilePic']);
    });

    return userData;
  }
}
