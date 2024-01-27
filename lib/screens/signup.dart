import 'package:todo_app/exports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Signup Building');

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getWidth(context) * 0.01,
              vertical: getHeight(context) * 0.04),
          child: Column(
            children: [
              Image.asset('assets/Icon-todo.png',
                  width: getWidth(context) * 0.3),
              SizedBox(height: getHeight(context) * 0.01),
              CustomTextField(
                onValidator: (value) {
                  return '';
                },
                keyboardType: TextInputType.name,
                hint: 'Enter Full Name',
                obsecureText: false,
                suffixIcon: const Icon(
                  Icons.account_circle,
                  color: AppColors.primaryColor,
                ),
                onChanged: (value) {},
              ),
              SizedBox(height: getHeight(context) * 0.01),
              CustomTextField(
                onValidator: (value) {
                  return '';
                },
                keyboardType: TextInputType.phone,
                hint: 'Enter Phone number',
                obsecureText: false,
                suffixIcon: const Icon(
                  Icons.phone,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: getHeight(context) * 0.01),
              CustomTextField(
                myController: emailController,
                onValidator: (value) {
                  return '';
                },
                keyboardType: TextInputType.emailAddress,
                hint: 'Enter Email Address',
                obsecureText: false,
                suffixIcon: const Icon(
                  Icons.email,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: getHeight(context) * 0.01),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomTextField(
                      myController: passwordController,
                      onValidator: (value) {
                        return '';
                      },
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Enter Password',
                      obsecureText: state.isVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.isVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                              ToggleVisiblity(isVisible: !state.isVisible));
                        },
                      ));
                },
              ),
              SizedBox(height: getHeight(context) * 0.01),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.status == AuthStatus.success) {
                    showSnackBar(context: context, message: state.message);
                  }
                },
                builder: (context, state) {
                  if (state.status == AuthStatus.loading) {
                    return const CircularProgressIndicator();
                  }
                  return CustomButton(
                    title: 'Register',
                    onPressed: () {
                      context.read<AuthBloc>().add(Register(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim()));
                    },
                  );
                },
              ),
              SizedBox(height: getHeight(context) * 0.01),
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: Theme.of(context).textTheme.bodySmall,
                  children: <TextSpan>[
                    TextSpan(
                      text: "SignIn",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
