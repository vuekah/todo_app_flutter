import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/model/task_model.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/service/task_service.dart';

class AddTaskViewModel extends ChangeNotifier {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  Status _addTaskStatus = Status.init;
  String _errorAddTask = "";
  int _selectedButton = 1;

  String get errorAddTask => _errorAddTask;
  Status get addTaskStatus => _addTaskStatus;
  String get time {
    final now = DateTime.now();
    final formattedTime = DateFormat('H:mm a').format(
        DateTime(now.year, now.month, now.day, _time.hour, _time.minute));
    return formattedTime;
  }

  int get selectedButton => _selectedButton;
  String get date => DateFormat("MMMM dd, yyyy").format(_date);

  void setSelected(int index) {
    _selectedButton = index;
    notifyListeners();
  }

  void setDateSelected(DateTime? date) {
    _date = date ?? _date;
    notifyListeners();
  }

  void setTimeSelected(TimeOfDay? time) {
    _time = time ?? _time;
    notifyListeners();
  }

  Future<int?> addTask(TaskModel task) async {
    try {
      if (task.taskTitle.isEmpty || task.notes.isEmpty) {
        _addTaskStatus = Status.error;
        _errorAddTask = "Task and Notes is empty";
      } else {
        _addTaskStatus = Status.loading;
        notifyListeners();
        final id = await TaskService().addTask(task);
        _addTaskStatus = Status.completed;
        _errorAddTask = "Add Successfiully!";
        return id;
      }
    } catch (e) {
      _addTaskStatus = Status.error;
      _errorAddTask = e.toString();
    } finally {
      notifyListeners();
    }
    return null;
  }
}
