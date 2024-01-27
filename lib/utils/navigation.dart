import 'package:todo_app/exports.dart';

void nextScreen({required BuildContext context, required page}) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

void nextScreenReplacement({required BuildContext context, required page}) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}
