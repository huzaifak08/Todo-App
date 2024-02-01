import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:todo_app/exports.dart';

class TodoNavigationBar extends StatefulWidget {
  const TodoNavigationBar({super.key});

  @override
  State<TodoNavigationBar> createState() => _TodoNavigationBarState();
}

class _TodoNavigationBarState extends State<TodoNavigationBar> {
  List<Widget> _buildScreen() {
    return [
      const HomeScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem() {
    return [
      PersistentBottomNavBarItem(
        title: "Home",
        icon: const Icon(Icons.home_outlined),
        activeColorPrimary: AppColors.iconSelectedColor,
        inactiveIcon: const Icon(
          Icons.home_outlined,
          color: AppColors.iconPrimaryColor,
        ),
      ),
      PersistentBottomNavBarItem(
        title: "Profile",
        icon: const Icon(Icons.account_circle_outlined),
        activeColorPrimary: AppColors.iconSelectedColor,
        inactiveIcon: const Icon(
          Icons.account_circle_outlined,
          color: AppColors.iconPrimaryColor,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreen(),
      items: _navBarItem(),
      backgroundColor: AppColors.primaryColor,
      decoration: NavBarDecoration(borderRadius: BorderRadius.circular(1)),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
