import 'package:flutter/material.dart';
import 'package:todo_app_flutter/gen/assets.gen.dart';
import 'package:todo_app_flutter/model/task_model.dart';
import 'package:todo_app_flutter/theme/text_style.dart';
import 'package:todo_app_flutter/utils/date_util.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final GestureTapCallback? callback;
  const TaskItem({super.key, required this.task, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(13)),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13),
      child: Row(
        children: [
          Opacity(
            opacity: task.isCompleted ? 0.5 : 1,
            child: Image.asset(changeAssets(task.category)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Opacity(
              opacity: task.isCompleted ? 0.5 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.taskTitle,
                    style: task.isCompleted
                        ? MyAppStyles.completedTitleTextStyle
                        : MyAppStyles.completedTextStyle,
                  ),
                  Text(
                    task.time.formatTime(),
                    style: task.isCompleted
                        ? MyAppStyles.completedTitleTextStyle
                        : MyAppStyles.completedTitleTextStyle2,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: callback,
            child: Image.asset(task.isCompleted
                ? Assets.images.checked.path
                : Assets.images.uncheck.path),
          ),
        ],
      ),
    );
  }

  String changeAssets(int category) {
    List<String> listCategory = [
      Assets.images.book.path,
      Assets.images.book.path,
      Assets.images.schedule.path,
      Assets.images.cup.path
    ];
    return listCategory[category];
  }
}
