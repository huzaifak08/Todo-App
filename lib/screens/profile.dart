import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:todo_app/exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      body: Column(
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
                            loadingBuilder: (context, child, loadingProgress) {
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
                      CustomRow(title: 'Email', value: state.userModel!.email),
                    ],
                  );
              }
            },
          ),
          SizedBox(height: getHeight(context) * 0.04),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.success) {
                // showSnackBar(context: context, message: state.message);
                nextScreenReplacement(
                    context: context, page: const LoginScreen());
                PersistentNavBarNavigator.pushNewScreen(context,
                    screen: const LoginScreen(), withNavBar: false);
              }
            },
            builder: (context, state) {
              return CustomButton(
                title: 'Sign Out',
                onPressed: () {
                  context.read<AuthBloc>().add(SignOut());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
