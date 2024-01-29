import 'package:todo_app/exports.dart';

class CustomRow extends StatelessWidget {
  final String title, value;

  const CustomRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColors.primaryTextColor),
          ),
          trailing: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
