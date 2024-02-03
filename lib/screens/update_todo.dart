import 'package:todo_app/exports.dart';

class UpdateTodoScreen extends StatefulWidget {
  final TodoModel todoModel;
  const UpdateTodoScreen({
    super.key,
    required this.todoModel,
  });

  @override
  State<UpdateTodoScreen> createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.todoModel.title;
    _descriptionController.text = widget.todoModel.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Todo')),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getHeight(context) * 0.01,
            horizontal: getWidth(context) * 0.02),
        child: Column(
          children: [
            CustomTextField(
              controller: _titleController,
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
              controller: _descriptionController,
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
            BlocConsumer<TodoBloc, TodoState>(
              listener: (context, state) {
                if (state.status == TodoStatus.success) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                if (state.status == TodoStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return CustomButton(
                  title: 'Save',
                  onPressed: () {
                    context.read<TodoBloc>().add(UpdateTodo(
                        docId: widget.todoModel.docId!,
                        title: _titleController.text,
                        description: _descriptionController.text));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
