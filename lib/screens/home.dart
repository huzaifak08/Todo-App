import 'package:todo_app/exports.dart';
import 'package:todo_app/screens/add_todo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          nextScreen(context: context, page: const AddTodoScreen());
        },
      ),
    );
  }
}
