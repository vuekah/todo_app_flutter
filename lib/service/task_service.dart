import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter/model/task_model.dart';

class TaskService {
  final String _tableName = "tasks";
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTodos() async {
    return await _client
        .from(_tableName)
        .select()
        .eq("isCompleted", false)
        .eq("uid", _client.auth.currentSession!.user.id);
  }

  Future<List<Map<String, dynamic>>> fetchCompleted() async {
    try {
      return await _client
          .from(_tableName)
          .select()
          .eq("isCompleted", true)
          .eq("uid", _client.auth.currentSession!.user.id);
    } catch (e) {
      throw Exception("error fetch completed $e");
    }
  }

  Future<TaskModel> addTask(TaskModel task) async {
    try {
      final res = await _client.from(_tableName).insert(task.toJson()).select();

      final insertedTask = TaskModel.fromJson(res[0]);
      debugPrint('insert task ID: ${insertedTask.id}');
      return insertedTask;
    } catch (e) {
      throw Exception('Failed to addTask: ${e.toString()}');
    }
  }

  Future<void> updateTask(int id) async {
    await _client.from(_tableName).update({'isCompleted': true}).eq('id', id);
  }
}
