import 'package:todo_app/exports.dart';
import 'package:todo_app/models/todo_model.dart';

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
}
