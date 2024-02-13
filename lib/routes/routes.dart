import 'package:todo_app/exports.dart';
import 'package:todo_app/screens/all_chats.dart';
import 'package:todo_app/screens/chat.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case RouteName.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

      case RouteName.signUpScreen:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );

      case RouteName.navBarScreen:
        return MaterialPageRoute(
          builder: (context) => const TodoNavigationBar(),
        );

      case RouteName.homeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      case RouteName.addTodoScreen:
        return MaterialPageRoute(
          builder: (context) => const AddTodoScreen(),
        );

      case RouteName.updateTodoScreen:
        return MaterialPageRoute(
          builder: (context) =>
              UpdateTodoScreen(todoModel: settings.arguments as Map),
        );

      case RouteName.profileScreen:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );

      case RouteName.allChatsScreen:
        return MaterialPageRoute(
          builder: (context) => const AllChatsScreen(),
        );

      case RouteName.chatScreen:
        return MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('No Route Defined')),
          ),
        );
    }
  }
}
