import 'package:todo_app/exports.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldSetter? onFiledSubmissionValue;
  final FormFieldValidator onValidator;
  final TextInputType? keyboardType;
  final String hint;
  final bool? obsecureText;
  final bool enable, autoFocus;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon, suffixIcon;
  final int? maxLines, maxLength;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.onFiledSubmissionValue,
    required this.onValidator,
    this.keyboardType,
    required this.hint,
    this.obsecureText = false,
    this.enable = true,
    this.autoFocus = false,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obsecureText ?? false,
        onFieldSubmitted: onFiledSubmissionValue,
        validator: onValidator,
        keyboardType: keyboardType ?? TextInputType.text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 19),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
                color: AppColors.textFieldDefaultFocus, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.ternaryColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.alertColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.ternaryColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.primaryTextColor.withOpacity(0.8), height: 0),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        onChanged: onChanged,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        cursorColor: AppColors.primaryColor,
      ),
    );
  }
}
