import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/model/task.model.dart';
import 'package:todo_app_flutter/service/task.service.dart';

enum Status { init, loading, completed, error }

class ViewModel extends ChangeNotifier {
  int _selectedButton = 1;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  List<TaskModel> _listTodo = [];
  List<TaskModel> _listCompleted = [];
  Status _status = Status.init;
  Status _completedStatus = Status.init;
  Status _addTaskStatus = Status.init;
  int _currendId = 0;
  String _errorAddTask = "";
  String _errorFetchTodoList = "";
  String _errorFetchCompletedList = "";

  ///MARK: getter
  int get selectedButton => _selectedButton;
  String get time {
    final now = DateTime.now();
    final formattedTime = DateFormat('H:mm a').format(
        DateTime(now.year, now.month, now.day, _time.hour, _time.minute));
    return formattedTime;
  }
  int get currentId => _currendId;
  String get errorAddTask => _errorAddTask;
  String get errorFetchTodoList => _errorFetchTodoList;
  String get errorFetchCompletedList => _errorFetchCompletedList;

  Status get status => _status;
  Status get completedStatus => _completedStatus;
  Status get addTaskStatus => _addTaskStatus;
  String get date => DateFormat("MMMM dd, yyyy").format(_date);
  List<TaskModel> get listTodo => _listTodo;
  List<TaskModel> get listCompleted => _listCompleted;

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

  void fetchTodos() async {
    _status = Status.loading;
    try {
      final res = await TaskService().fetchTodos();
      _listTodo = res.map((e) => TaskModel.fromJson(e)).toList();
      _status = Status.completed;
      if (listTodo.isNotEmpty) {
        _currendId = _listTodo[_listTodo.length - 1].id ?? 0;
      }
      notifyListeners();
    } catch (e) {
      _status = Status.error;
      _errorFetchTodoList = '$e';
    } finally {
      notifyListeners();
    }
  }

  void fetchCompletedTodos() async {
    _completedStatus = Status.loading;
    try {
      final res = await TaskService().fetchCompleted();
      _completedStatus = Status.completed;
      _listCompleted = res.map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      _completedStatus = Status.error;
      _errorFetchCompletedList = 'Failed to load task: $e';
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      if (task.taskTitle.isEmpty || task.notes.isEmpty) {
        _addTaskStatus = Status.error;
        _errorAddTask = "Task and Notes is empty";
      } else {
        _addTaskStatus = Status.loading;
        notifyListeners();
        _listTodo.add(task);
        _currendId = task.id ?? 0;
        // for (var e in _listTodo) {
        //   print(e.taskTitle);
        // }
        await TaskService().addTask(task);
        _addTaskStatus = Status.completed;
        _errorAddTask = "Add Successfiully!";
      }
    } catch (e) {
      _addTaskStatus = Status.error;
      _errorAddTask = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTask(int id) async {
    try {
      await TaskService().updateTask(id);

      final task = _listTodo.firstWhere((e) => e.id == id);

      _listTodo.removeWhere((e) => e.id == id);

      _listCompleted.add(TaskModel(
          id: task.id,
          category: task.category,
          taskTitle: task.taskTitle,
          date: task.date,
          time: task.time,
          notes: task.notes,
          isCompleted: true,
          uid: task.uid));
      print("update success");
    } catch (e) {
      print('Error: $e');
    } finally {
      notifyListeners();
    }
  }

  void resetAllState() {
    _selectedButton = 1;
    _date = DateTime.now();
    _time = TimeOfDay.now();
    _listTodo = [];
    _listCompleted = [];
    _status = Status.init;
    _completedStatus = Status.init;
    _addTaskStatus = Status.init;
    _errorAddTask = "";
    _errorFetchTodoList = "";
    _errorFetchCompletedList = "";
    print("========================");
    notifyListeners();
  }
}
