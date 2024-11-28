import 'package:flutter/material.dart';
import 'package:todo_app_flutter/pages/add_task/add_task_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final int index;
  final String assets;
  const CategoryWidget(
      {super.key,
      required this.index,
      required this.assets});
  @override
  Widget build(BuildContext context) {
    final selectedButton = context.select((AddTaskViewModel t)=>t.selectedButton);
    return GestureDetector(
      onTap: (){
        context.read<AddTaskViewModel>().setSelected(index);
      },
      child: Opacity(
        opacity: selectedButton == index ? 1 : .2,
        child: Image.asset(assets),
      ),
    );
  }
}
