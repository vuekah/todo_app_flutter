import 'package:flutter/material.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback callback;
  const ButtonWidget({super.key, required this.callback, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: MyAppColors.backgroundColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: MyAppStyles.titleButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
