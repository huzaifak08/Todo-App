part of 'todo_bloc.dart';

class TodoState extends Equatable {
  final TodoModel? todo;
  final TodoStatus status;
  final List<TodoModel> todoList;
  const TodoState({
    this.todo,
    this.status = TodoStatus.initial,
    this.todoList = const [],
  });

  TodoState copyWith({
    TodoModel? todo,
    TodoStatus? status,
    List<TodoModel>? todoList,
  }) {
    return TodoState(
      todo: todo ?? this.todo,
      status: status ?? this.status,
      todoList: todoList ?? this.todoList,
    );
  }

  @override
  List<Object?> get props => [todo, status, todoList];
}
