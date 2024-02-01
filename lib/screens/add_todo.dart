import 'package:todo_app/exports.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Save New Todo')),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getHeight(context) * 0.01,
            horizontal: getWidth(context) * 0.02),
        child: Column(
          children: [
            CustomTextField(
              myController: _titleController,
              onValidator: (value) {
                if (_titleController.text.isEmpty) {
                  return "Title can't be empty";
                }
                return null;
              },
              keyboardType: TextInputType.name,
              hint: 'Enter Todo Title',
              obsecureText: false,
            ),
            CustomTextField(
              myController: _descriptionController,
              onValidator: (value) {
                if (_descriptionController.text.isEmpty) {
                  return "Description can't be empty";
                }
                return null;
              },
              keyboardType: TextInputType.name,
              hint: 'Enter Todo Title',
              obsecureText: false,
            ),
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                switch (state.status) {
                  case TodoStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  case TodoStatus.failure:
                    return showSnackBar(
                        context: context, message: 'Failed to Save');

                  default:
                    return CustomButton(
                      title: 'Save',
                      onPressed: () {
                        context.read<TodoBloc>().add(FetchToken());

                        TodoModel newTodo = TodoModel(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          createdAt: DateTime.now(),
                        );

                        context
                            .read<TodoBloc>()
                            .add(SaveTodo(todoModel: newTodo));

                        context
                            .read<TodoBloc>()
                            .add(SendNotification(token: state.deviceToken));

                        debugPrint("Token in Screen: ${state.deviceToken}");

                        Navigator.pop(context);
                      },
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
