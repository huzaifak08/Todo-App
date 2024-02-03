import 'dart:async';

import 'package:todo_app/exports.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository = TodoRepository();
  final NotificationRepository _notification = NotificationRepository();

  late StreamSubscription<QuerySnapshot> _todoSubscription;

  TodoBloc() : super(const TodoState()) {
    on<SaveTodo>(_saveTodo);
    on<FetchTodo>(_fetchTodo);
    on<CancelStream>(_cancelTodoSubscription);
    on<DeleteTodo>(_deleteTodo);
    on<UpdateTodo>(_updateTodo);
    on<SaveToken>(_saveToken);
    on<FetchToken>(_fetchToken);
    on<SendNotification>(_sendNotification);
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
    final streamController = StreamController<QuerySnapshot>();

    _todoSubscription = _todoRepository.getTodos().listen((snapshot) {
      streamController.add(snapshot);
    });

    await for (var snapshot in streamController.stream) {
      final List<DocumentSnapshot> document = snapshot.docs;
      final List<TodoModel> todoList = document.map((e) {
        return TodoModel.fromDocument(e);
      }).toList();
      emit(state.copyWith(
          status: TodoStatus.success, todoList: List.from(todoList)));
    }

    await streamController.close();
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

  void _saveToken(SaveToken event, Emitter<TodoState> emit) async {
    await _notification.saveDeviceToken(token: event.token);
  }

  void _fetchToken(FetchToken event, Emitter<TodoState> emit) async {
    Map<String, dynamic> tokenMap = await _notification.fetchDeviceToken();

    // String token = tokenMap.map((key, value) => value).toString();
    // String token = tokenMap.values.toString(); // (values)
    String token = tokenMap['token'];

    debugPrint('Token in Bloc: $token');

    emit(state.copyWith(deviceToken: token));
  }

  void _sendNotification(
      SendNotification event, Emitter<TodoState> emit) async {
    await _notification.sendNotification(token: event.token);
  }

  void _cancelTodoSubscription(CancelStream event, Emitter<TodoState> emit) {
    _todoSubscription.cancel();
    // _todoSubscription = null;
  }
}
