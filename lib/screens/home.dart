import 'package:todo_app/exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationRepository notificationServices = NotificationRepository();

  @override
  void initState() {
    context.read<TodoBloc>().add(FetchTodo());

    notificationServices.requestNotificationPermission();

    // Token:
    notificationServices.getDeviceToken().then((value) {
      debugPrint('Device Token: $value');
      context.read<TodoBloc>().add(SaveToken(token: value));
    });

    // Refresh:
    notificationServices.isTokenRefresh();

    notificationServices.firebaseInit(context);

    notificationServices.setupInteractMessage(context);

    notificationServices.triggerInAppEvent();

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

                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(RouteName.updateTodoScreen, arguments: {
                    'docId': todo.docId,
                    'title': todo.title,
                    'description': todo.description,
                  });
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
          Navigator.of(context, rootNavigator: true)
              .pushNamed(RouteName.addTodoScreen);
        },
      ),
    );
  }
}
