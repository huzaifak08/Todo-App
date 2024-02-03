import 'package:todo_app/exports.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _descrptionFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _descrptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Save New Todo')),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getHeight(context) * 0.01,
            horizontal: getWidth(context) * 0.02),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                hint: 'Enter Todo Title',
                onValidator: (value) {
                  if (_titleController.text.isEmpty) {
                    return "Title can't be empty";
                  }
                  return null;
                },
                onFiledSubmissionValue: (newValue) {
                  if (newValue != null) {
                    _descrptionFocusNode.requestFocus();
                  }
                },
              ),
              CustomTextField(
                controller: _descriptionController,
                focusNode: _descrptionFocusNode,
                hint: 'Enter Todo Description',
                maxLines: 3,
                maxLength: 90,
                onValidator: (value) {
                  if (_descriptionController.text.isEmpty) {
                    return "Description can't be empty";
                  }
                  return null;
                },
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

                          if (_formKey.currentState!.validate()) {
                            TodoModel newTodo = TodoModel(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              createdAt: DateTime.now(),
                            );

                            context
                                .read<TodoBloc>()
                                .add(SaveTodo(todoModel: newTodo));

                            context.read<TodoBloc>().add(
                                SendNotification(token: state.deviceToken));

                            debugPrint("Token in Screen: ${state.deviceToken}");

                            Navigator.pop(context);
                          }
                        },
                      );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
