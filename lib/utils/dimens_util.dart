
import 'package:flutter/material.dart';

class Dimens{
  static late double screenHeight;
  static late double screenWidth;
  static late EdgeInsets padding;
  static void init(BuildContext context){
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    padding = MediaQuery.of(context).padding;
  }
}