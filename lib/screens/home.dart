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

    // Token  :
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
        title: Text(
          'Home Screen',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
              onPressed: () {
                showSecurityCodeDialogue();
              },
              icon: const Icon(
                Icons.feedback,
                color: AppColors.whiteColor,
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.todoList.isEmpty) {
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getWidth(context) * 0.027),
              child: Column(
                children: [
                  Image.asset('assets/notodo.png'),
                  Text(
                    "No Todo's Found",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    "Please add some Todo's by clicking on \"+\" Button at bottom-left corner.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.ternaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
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
        child: const Icon(Icons.add, color: AppColors.secondaryColor),
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamed(RouteName.addTodoScreen);
        },
      ),
    );
  }

  showSecurityCodeDialogue() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Feedback',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.black),
        ),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Give us your Valuable Feedback.'),
            TextField(
              decoration: InputDecoration(labelText: 'Feedback'),
            ),
          ],
        ),
        actions: [
          CustomButton(
            title: 'Submit',
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
