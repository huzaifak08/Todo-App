import 'package:todo_app/exports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.01),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/Icon-todo.png'),
                CustomTextField(
                  controller: emailController,
                  onFiledSubmissionValue: (newValue) {
                    if (newValue != null) {
                      passwordFocusNode.requestFocus();
                    }
                  },
                  onValidator: (value) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)
                        ? null
                        : 'Enter a valid Email';
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
                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      onValidator: (value) {
                        if (passwordController.text.isEmpty ||
                            passwordController.text.length < 6) {
                          return 'Please enter a valid 6-digits password';
                        }
                        return null;
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
                      ),
                    );
                  },
                ),
                SizedBox(height: getHeight(context) * 0.003),
                Align(
                  alignment: Alignment.centerRight,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.isEmailSend) {
                        showSnackBar(context: context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          context.read<AuthBloc>().add(ForgotPassword(
                              email: emailController.text.trim()));
                        },
                        child: Text(
                          'Forgot Password? ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: getHeight(context) * 0.01),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.success) {
                      Navigator.pushReplacementNamed(
                          context, RouteName.navBarScreen);
                    } else if (state.status == AuthStatus.failure) {
                      showSnackBar(context: context, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state.status == AuthStatus.loading) {
                      return const CircularProgressIndicator();
                    }
                    return CustomButton(
                      title: 'Login',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(SignIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()));
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: getHeight(context) * 0.01),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodySmall,
                    children: <TextSpan>[
                      TextSpan(
                        text: "SignUp",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, RouteName.signUpScreen);

                            emailController.clear();
                            passwordController.clear();
                          },
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(height: getHeight(context) * 0.02),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.failure) {
                      showSnackBar(context: context, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    switch (state.status) {
                      case AuthStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      case AuthStatus.failure:
                        return const Center(
                          child: Text('Something Went Wrong'),
                        );

                      case AuthStatus.success:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomAuthButton(
                              imageUrl: 'assets/google.png',
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SignInWithGoogle());
                              },
                            ),
                            SizedBox(width: getWidth(context) * 0.02),
                            CustomAuthButton(
                              imageUrl: 'assets/facebook.png',
                              onPressed: () async {
                                await AuthRepository().signInWithFacebook();
                              },
                            ),
                            SizedBox(width: getWidth(context) * 0.02),
                            CustomAuthButton(
                              imageUrl: 'assets/microsoft.png',
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SignInWithGoogle());
                              },
                            ),
                          ],
                        );

                      case AuthStatus.initial:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomAuthButton(
                              imageUrl: 'assets/google.png',
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SignInWithGoogle());
                              },
                            ),
                            SizedBox(width: getWidth(context) * 0.02),
                            CustomAuthButton(
                              imageUrl: 'assets/facebook.png',
                              onPressed: () async {
                                await AuthRepository().signInWithFacebook();
                              },
                            ),
                            SizedBox(width: getWidth(context) * 0.02),
                            CustomAuthButton(
                              imageUrl: 'assets/microsoft.png',
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SignInWithGoogle());
                              },
                            ),
                          ],
                        );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
