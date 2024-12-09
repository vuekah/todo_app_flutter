import 'package:flutter/material.dart';
import 'package:todo_app_flutter/model/task_model.dart';
import 'package:todo_app_flutter/service/auth_service.dart';
import 'package:todo_app_flutter/service/task_service.dart';

enum Status { init, loading, completed, error }

class HomeViewModel extends ChangeNotifier {
  List<TaskModel> _listTodo = [];
  List<TaskModel> _listCompleted = [];
  Status _status = Status.init;
  Status _completedStatus = Status.init;
  Status get completedStatus => _completedStatus;

  ///MARK: getter
  Status get status => _status;
  List<TaskModel> get listTodo => _listTodo;
  List<TaskModel> get listCompleted => _listCompleted;

  void fetchTodos() async {
    _status = Status.loading;
    try {
      final res = await TaskService().fetchTodos();
      _listTodo = res.map((e) => TaskModel.fromJson(e)).toList();
      _status = Status.completed;
    } catch (e) {
      _status = Status.error;
      debugPrint(e.toString());
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
      debugPrint(e.toString());
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
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      notifyListeners();
    }
  }

  void addNewTask(TaskModel task) {
    debugPrint(task.toString());
    _listTodo.add(task);
    notifyListeners();
  }

  void resetAllState() {
    _listTodo = [];
    _listCompleted = [];
    _status = Status.init;
    _completedStatus = Status.init;
  }

  Future logout() async {
    try {
      return await AuthService().logout();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
