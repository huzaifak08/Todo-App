import 'package:todo_app/exports.dart';

class TodoRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future saveTodo(TodoModel todoModel) async {
    try {
      DocumentReference reference = await _firestore.collection('todos').add({
        'docId': '',
        'title': todoModel.title,
        'description': todoModel.description,
        'uid': _firebaseAuth.currentUser!.uid,
        'createdAt': todoModel.createdAt,
      });

      reference.update({
        'docId': reference.id,
      });
    } on FirebaseException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Stream<QuerySnapshot> getTodos() {
    return _firestore
        .collection('todos')
        .where('uid', isEqualTo: _firebaseAuth.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteTodo({required String docId}) async {
    await _firestore.collection('todos').doc(docId).delete();
  }

  Future<void> updateTodo(
      {required String docId,
      required String title,
      required String description}) async {
    await _firestore.collection('todos').doc(docId).update({
      'title': title,
      'description': description,
    });
  }
}
