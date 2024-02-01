part of 'todo_bloc.dart';

class TodoState extends Equatable {
  final TodoModel? todo;
  final TodoStatus status;
  final List<TodoModel> todoList;
  final String deviceToken;
  const TodoState({
    this.todo,
    this.status = TodoStatus.initial,
    this.todoList = const [],
    this.deviceToken = '',
  });

  TodoState copyWith({
    TodoModel? todo,
    TodoStatus? status,
    List<TodoModel>? todoList,
    String? deviceToken,
  }) {
    return TodoState(
      todo: todo ?? this.todo,
      status: status ?? this.status,
      todoList: todoList ?? this.todoList,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }

  @override
  List<Object?> get props => [todo, status, todoList, deviceToken];
}
