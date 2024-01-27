import 'package:todo_app/exports.dart';

showSnackBar({required context, required String message}) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}
