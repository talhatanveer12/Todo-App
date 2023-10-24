import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/isar_service.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> todo = [];
  List<Todo> completed = [];
  List<Todo> inComplete = [];
  Todo? task;

  getAllPendingTask(List<Todo> todo) {
    this.todo = todo;
    debugPrint('Test 445');
    notifyListeners();
  }

  getAllCompletedTask(List<Todo> completed) {
    this.completed = completed;
    notifyListeners();
  }
  getAllInCompletedTask(List<Todo> inComplete) {
    this.inComplete = inComplete;
    notifyListeners();
  }

  getTaskById(Todo? task) {
    if (task != null) this.task = task;
    notifyListeners();
  }

  getTaskByDate(DateTime dateTime) async {
    IsarService isarService = IsarService();
    todo = await isarService.getTaskByDate(dateTime, false);
    debugPrint('test: ${todo.length} $dateTime');
    completed = await isarService.getTaskByDate(dateTime, true);
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
