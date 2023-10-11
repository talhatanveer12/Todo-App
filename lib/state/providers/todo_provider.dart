import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/isar_service.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> todo = [];
  List<Todo> completed = [];
  Todo? task;

  getAllPendingTask(List<Todo> todo) {
    this.todo = todo;
    notifyListeners();
  }

  getAllCompletedTask(List<Todo> completed) {
    this.completed = completed;
    notifyListeners();
  }

  getTaskById(Todo? task) {
    if (task != null) this.task = task;
    else debugPrint("ewwewe");
    notifyListeners();
  }

  addTask(DateTime? dateTime, int? flag, String name, String description,
      Category? category) async {
    IsarService isarService = IsarService();
    await isarService.addTodo(Todo()
      ..date = dateTime
      ..flag = flag
      ..description = description
      ..isComplete = false
      ..name = name
      ..category.value = category
      ..time = '00:00');
    todo = await isarService.getTask(false);
    notifyListeners();
  }
}
