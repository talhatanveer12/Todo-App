import 'package:isar/isar.dart';
import 'package:todo_app/models/category.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? name;

  String? description;

  int? flag;

  String? time;

  DateTime? date;

  late bool isComplete;

  final category = IsarLink<Category>();


}