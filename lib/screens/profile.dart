import 'package:todo_app/exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    context.read<UserBloc>().add(FetchUserData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getHeight(context) * 0.04),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                switch (state.userDataStatus) {
                  case UserDataStatus.initial:
                    return const Center(child: Text('Please Wait...'));

                  case UserDataStatus.failure:
                    return const Center(child: Text('Please refresh page...'));

                  case UserDataStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  case UserDataStatus.success:
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(getWidth(context) * 0.14),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 50,
                            child: Image.network(
                              state.userModel!.profilePic,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress != null) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.secondaryColor),
                                  );
                                }
                                return child;
                              },
                            ),
                          ),
                        ),
                        CustomRow(title: 'Name', value: state.userModel!.name),
                        CustomRow(
                            title: 'Phone',
                            value: state.userModel!.phone.toString()),
                        CustomRow(
                            title: 'Email', value: state.userModel!.email),
                      ],
                    );
                }
              },
            ),
            SizedBox(height: getHeight(context) * 0.04),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.success) {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(
                          RouteName.loginScreen, (route) => false);

                  context.read<TodoBloc>().add(CancelStream());
                }
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // RefreshIndicator(child: , onRefresh: onRefresh)
                    CustomButton(
                      width: getWidth(context) * 0.6,
                      title: 'Change Password',
                      onPressed: () => changePasswordDialog(
                        onPressed: () {
                          context.read<AuthBloc>().add(ChangePassword(
                              password: passwordController.text));
                        },
                      ),
                    ),
                    CustomButton(
                      title: 'Sign Out',
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOut());
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  changePasswordDialog({required VoidCallback onPressed}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'You cannot use change password feature if you are logged in using Google account.'),
            SizedBox(height: getHeight(context) * 0.01),
            CustomTextField(
              controller: passwordController,
              keyboardType: TextInputType.name,
              obsecureText: false,
              hint: 'Enter Password here',
              onValidator: (value) {
                return null;
              },
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel')),
          ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.password),
              label: const Text('Submit')),
        ],
      ),
    );
  }
}
