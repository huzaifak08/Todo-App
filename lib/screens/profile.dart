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
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          switch (state.userDataStatus) {
            case UserDataStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case UserDataStatus.success:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      title: 'Phone', value: state.userModel!.phone.toString()),
                  CustomRow(title: 'Email', value: state.userModel!.email),
                  SizedBox(height: getHeight(context) * 0.04),
                  CustomButton(
                    title: 'Sign Out',
                    onPressed: () {},
                  )
                ],
              );
            default:
              return const Center(child: Text('Some Issue Occoured'));
          }
        },
      ),
    );
  }
}
