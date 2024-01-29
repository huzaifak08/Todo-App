import 'package:todo_app/exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(CheckUserStatus());

    Future.delayed(const Duration(seconds: 3));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoggedIn) {
            nextScreenReplacement(context: context, page: const HomeScreen());
          } else {
            nextScreenReplacement(context: context, page: const LoginScreen());
          }
        },
        child: Center(
          child: Image.asset('assets/Icon-todo.png'),
        ),
      ),
    );
  }
}
