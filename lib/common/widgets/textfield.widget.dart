import 'package:flutter/material.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool obscureText;
  final double? height;
  final int? maxLines;
  final Widget? suffixIcon;
  final String? placeholder;
  final bool? isReadOnly;
  const TextFieldWidget(
      {super.key,
      required this.hint,
      this.obscureText = false,
      this.height = 55,
      this.maxLines = 1,
      this.suffixIcon,
      this.placeholder,
      this.isReadOnly,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint, style: MyAppStyles.hintTextStyle),
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: MyAppColors.whiteColor,
              border:
                  Border.all(color: MyAppColors.grayColor.withOpacity(0.6))),
          height: height,
          child: TextField(
            controller: controller,
            readOnly: isReadOnly ?? false,
            obscureText: obscureText,
            maxLines: maxLines,
            style: MyAppStyles.textFieldTextStyle,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: placeholder ?? hint,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }
}
