import 'package:isar/isar.dart';
import 'package:todo_app/models/todo.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? name;

  int? icon;

  int? color;


  @Backlink(to: 'category')
  final todo = IsarLink<Todo>();

}