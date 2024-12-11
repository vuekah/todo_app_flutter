import 'package:flutter/material.dart';
import 'package:todo_app_flutter/theme/text_style.dart';

class ItemWidget extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback callBack;
  final String? suffixText;
  const ItemWidget(
      {super.key,
      required this.title,
      required this.callBack,
      required this.icon,
      this.suffixText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: callBack,
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Expanded(child: Text(title, style: MyAppStyles.completedTextStyle)),
            Text(suffixText ?? '')
          ],
        ),
      ),
    );
  }
}
