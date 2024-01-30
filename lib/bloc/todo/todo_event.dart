part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class SaveTodo extends TodoEvent {
  final TodoModel todoModel;
  const SaveTodo({required this.todoModel});

  @override
  List<Object> get props => [todoModel];
}