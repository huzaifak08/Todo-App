import 'package:todo_app/exports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        selectImageSource(
                          cameraPressed: () {
                            context.read<AuthBloc>().add(CameraCapture());
                            Navigator.pop(context);
                          },
                          galleryPressed: () {
                            context.read<AuthBloc>().add(GalleryImagePicker());
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: state.file == null
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.asset('assets/Icon-todo.png',
                                    width: getWidth(context) * 0.3),
                                const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.pendingColor,
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  getWidth(context) * 0.14),
                              child: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 50,
                                child: Image.file(
                                  File(state.file!.path.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    );
                  },
                ),
                SizedBox(height: getHeight(context) * 0.01),
                CustomTextField(
                  myController: nameController,
                  onValidator: (value) {
                    return RegExp(r"^[A-Za-z][^0-9]").hasMatch(value!)
                        ? null
                        : 'Enter a valid Username';
                  },
                  keyboardType: TextInputType.name,
                  hint: 'Enter Full Name',
                  obsecureText: false,
                  suffixIcon: const Icon(
                    Icons.account_circle,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: getHeight(context) * 0.01),
                CustomTextField(
                  myController: phoneController,
                  onValidator: (value) {
                    return RegExp(r"^[0-9]{8,}").hasMatch(value!)
                        ? null
                        : 'Enter a valid Phone number';
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
                      myController: passwordController,
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
                SizedBox(height: getHeight(context) * 0.01),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.success &&
                        state.file != null) {
                      showSnackBar(context: context, message: state.message);
                      nextScreenReplacement(
                          context: context, page: const HomeScreen());
                    }
                  },
                  builder: (context, state) {
                    if (state.status == AuthStatus.loading) {
                      return const CircularProgressIndicator();
                    }
                    return CustomButton(
                      title: 'Register',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          UserModel user = UserModel(
                            uid: '',
                            profilePic: state.file!.path.toString(),
                            name: nameController.text.trim(),
                            phone: int.parse(phoneController.text.trim()),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          context.read<AuthBloc>().add(Register(
                              user: user, file: File(state.file!.path)));
                        }
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
      ),
    );
  }

  selectImageSource(
      {required VoidCallback cameraPressed,
      required VoidCallback galleryPressed}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Please select Image Source!'),
        actions: [
          ElevatedButton.icon(
              onPressed: cameraPressed,
              icon: const Icon(Icons.camera),
              label: const Text('Camera')),
          ElevatedButton.icon(
              onPressed: galleryPressed,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Gallery')),
        ],
      ),
    );
  }
}
