import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/services/isar_service.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> category = [];

  void getAllCategory(List<Category> category) {
    this.category = category;
    notifyListeners();
  }

  void addCategory(int? icon, int? color, String name) async {
    IsarService isarService = IsarService();
    isarService.addCategory(Category()
      ..color = color
      ..icon = icon
      ..name = name);
    category = await isarService.getAllCategory();
    notifyListeners();
  }
}
