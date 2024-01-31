import 'package:todo_app/bloc/todo/todo_bloc.dart';
import 'package:todo_app/exports.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:todo_app/screens/update_todo.dart';

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
                onTap: () {
                  TodoModel todo = TodoModel(
                      docId: state.todoList[index].docId,
                      title: state.todoList[index].title,
                      description: state.todoList[index].description,
                      createdAt: state.todoList[index].createdAt);

                  nextScreen(
                    context: context,
                    page: UpdateTodoScreen(
                      todoModel: todo,
                    ),
                  );
                },
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context
                        .read<TodoBloc>()
                        .add(DeleteTodo(docId: todo.docId!));
                  },
                ),
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
