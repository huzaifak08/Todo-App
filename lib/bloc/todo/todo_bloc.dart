import 'package:todo_app/exports.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository = TodoRepository();

  TodoBloc() : super(const TodoState()) {
    on<SaveTodo>(_saveTodo);
    on<FetchTodo>(_fetchTodo);
    on<DeleteTodo>(_deleteTodo);
    on<UpdateTodo>(_updateTodo);
  }

  void _saveTodo(SaveTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    await _todoRepository.saveTodo(event.todoModel).then((value) {
      emit(state.copyWith(todo: value, status: TodoStatus.success));
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: TodoStatus.failure));
    });
  }

  void _fetchTodo(FetchTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    Stream<QuerySnapshot> todoStream = _todoRepository.getTodos();

    emit(state.copyWith(status: TodoStatus.success));

    await for (QuerySnapshot snapshot in todoStream) {
      final List<DocumentSnapshot> document = snapshot.docs;

      final List<TodoModel> todoList = document.map((e) {
        return TodoModel.fromDocument(e);
      }).toList();

      emit(state.copyWith(todoList: todoList));
    }
  }

  void _deleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    await _todoRepository.deleteTodo(docId: event.docId);
  }

  void _updateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));

    await _todoRepository.updateTodo(
        docId: event.docId, title: event.title, description: event.description);

    emit(state.copyWith(status: TodoStatus.success));
  }
}
