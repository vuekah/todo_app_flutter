import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter/model/task_model.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/service/task_service.dart';
import 'package:todo_app_flutter/utils/date_util.dart';

class AddTaskViewModel extends ChangeNotifier {
  TimeOfDay _time = TimeOfDay.now();
  Status _addTaskStatus = Status.init;
  int _selectedButton = 1;

  Status get addTaskStatus => _addTaskStatus;
  String get time {
    final now = DateTime.now();
    final formattedTime = DateFormat('H:mm a').format(
        DateTime(now.year, now.month, now.day, _time.hour, _time.minute));
    return formattedTime;
  }

  int get selectedButton => _selectedButton;

  void setSelected(int index) {
    _selectedButton = index;
    notifyListeners();
  }

 

  void setTimeSelected(TimeOfDay? time) {
    _time = time ?? _time;
    notifyListeners();
  }

  Future<TaskModel?> addTask(String title, String notes,String date) async {
    try {
      if (title.isEmpty || notes.isEmpty ) {
        _addTaskStatus = Status.error;
      } else {
        _addTaskStatus = Status.loading;
        notifyListeners();
        final task = TaskModel(
          category: selectedButton,
          taskTitle: title,
          date: date.toReverseFormattedDateString()!,
          time: time.convertTo24HourFormat(),
          notes: notes,
          uid: Supabase.instance.client.auth.currentUser?.id ?? "",
          isCompleted: false,
        );
        final taskModel = await TaskService().addTask(task);
        _addTaskStatus = Status.completed;
        return taskModel;
      }
    } catch (e) {
      _addTaskStatus = Status.error;
      debugPrint("errror"+e.toString());
    } finally {
      notifyListeners();
    }
    return null;
  }
}
