import 'package:todo_app/exports.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/repositories/todo_repo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository = TodoRepository();

  TodoBloc() : super(const TodoState()) {
    on<SaveTodo>(_saveTodo);
  }

  void _saveTodo(SaveTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    await _todoRepository.saveTodo(event.todoModel).then((value) {
      emit(state.copyWith(todo: value, status: TodoStatus.success));
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: TodoStatus.failure));
    });
  }
}
