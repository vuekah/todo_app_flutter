import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final int index;
  final GestureTapCallback callBack;
  final String assets;
  final int selected;
  const CategoryWidget(
      {super.key,
      required this.index,
      required this.assets,
      required this.callBack,
      required this.selected});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: Opacity(
        opacity: selected == index ? 1 : .2,
        child: Image.asset(assets),
      ),
    );
  }
}
