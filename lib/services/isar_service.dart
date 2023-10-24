import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/user.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TodoSchema, UserSchema, CategorySchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<List<Category>> getAllCategory() async {
    final isar = await db;
    final allCategory = await isar.categorys.where().findAll();
    return allCategory;
  }

  Future<void> addCategory(Category category) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.categorys.putSync(category));
  }

  Future<void> addTodo(Todo todo) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.todos.putSync(todo));
  }

  Future<List<Todo>> getTask(bool q) async {
    final isar = await db;
    return q
        ? await isar.todos.filter().isCompleteEqualTo(q).findAll()
        : await isar.todos
            .filter()
            .isCompleteEqualTo(q)
            .dateGreaterThan(DateTime.now())
            .findAll();
  }

  Future<List<Todo>> getInCompleteTask() async {
    final isar = await db;
    return await isar.todos
        .filter()
        .isCompleteEqualTo(false)
        .dateLessThan(DateTime.now())
        .findAll();
  }

  Future<List<Todo>> getTaskByDate(DateTime date, bool q) async {
    final isar = await db;
    final DateTime startDate = DateTime(date.year, date.month, date.day);
    final DateTime endDate = DateTime(date.year, date.month, date.day);
    return await isar.todos
        .filter()
        .isCompleteEqualTo(q)
        .dateBetween(startDate, endDate)
        .findAll();
  }

  Future<Todo?> getTaskById(int id) async {
    final isar = await db;
    return await isar.todos.filter().idEqualTo(id).findFirst();
  }

  Future<void> updateState(int id) async {
    final isar = await db;
    Todo? task = await isar.todos.get(id);
    if (task != null) {
      task.isComplete = true;
      isar.writeTxn(() => isar.todos.put(task));
    }
  }
}
