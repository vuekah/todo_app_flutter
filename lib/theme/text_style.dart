import 'package:flutter/material.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/theme/color_style.dart';

class MyAppStyles {
  static const titleAppbarTextStyle = TextStyle(
      fontWeight: FontWeight.w700, fontSize: 17, fontFamily: FontFamily.inter);
  static const titleButtonTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    color: MyAppColors.whiteColor,
    fontFamily: FontFamily.inter,
  );
  static const todoListTitleTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 25,
    fontFamily: FontFamily.inter,
    color: MyAppColors.whiteColor,
  );

  static const completedTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: FontFamily.inter,
    color: MyAppColors.black,
  );
  static const formattedDateTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    fontFamily: FontFamily.inter,
    color: MyAppColors.whiteColor,
  );
  static const hintTextStyle = TextStyle(
      color: MyAppColors.black,
      fontSize: 14,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w600);
  static const textFieldTextStyle = TextStyle(
      fontSize: 14,
      color: MyAppColors.black,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w600);
  static const completedTitleTextStyle = TextStyle(
      fontSize: 14,
      color: MyAppColors.grayColor,
      decoration: TextDecoration.lineThrough,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w600);
  static const completedTitleTextStyle2 = TextStyle(
      fontSize: 14,
      color: MyAppColors.grayColor,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w600);
}
