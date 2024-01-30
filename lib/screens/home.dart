import 'package:todo_app/bloc/todo/todo_bloc.dart';
import 'package:todo_app/exports.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/add_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(FetchTodo());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: state.todoList.length,
            itemBuilder: (context, index) {
              TodoModel todo = state.todoList[index];

              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
              );
            },
          );
        },
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
