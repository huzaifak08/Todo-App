part of 'todo_bloc.dart';

class TodoState extends Equatable {
  final TodoModel? todo;
  final TodoStatus status;
  const TodoState({
    this.todo,
    this.status = TodoStatus.initial,
  });

  TodoState copyWith({TodoModel? todo, TodoStatus? status}) {
    return TodoState(
      todo: todo ?? this.todo,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [todo, status];
}
