import 'package:todo_app/exports.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool loading;
  final Color color, textColor;
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.whiteColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPressed,
      child: Container(
        margin: EdgeInsets.all(getWidth(context) * 0.01),
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  color: Colors.black,
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
        ),
      ),
    );
  }
}
