import 'package:todo_app/exports.dart';

class CustomAuthButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onPressed;
  const CustomAuthButton(
      {super.key, required this.imageUrl, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context) * 0.07,
      padding: EdgeInsets.all(getHeight(context) * 0.008),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.ternaryColor),
        borderRadius: BorderRadius.circular(getWidth(context) * 0.03),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(imageUrl),
      ),
    );
  }
}
