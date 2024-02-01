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

class FetchTodo extends TodoEvent {}

class DeleteTodo extends TodoEvent {
  final String docId;
  const DeleteTodo({required this.docId});

  @override
  List<Object> get props => [docId];
}

class UpdateTodo extends TodoEvent {
  final String docId;
  final String title;
  final String description;

  const UpdateTodo(
      {required this.docId, required this.title, required this.description});

  @override
  List<Object> get props => [docId, title, description];
}

class SaveToken extends TodoEvent {
  final String token;
  const SaveToken({required this.token});

  @override
  List<Object> get props => [token];
}

class FetchToken extends TodoEvent {}

class SendNotification extends TodoEvent {
  final String token;
  const SendNotification({required this.token});

  @override
  List<Object> get props => [token];
}
