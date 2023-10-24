import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/state/providers/todo_provider.dart';
import 'package:todo_app/widgets/Modal/task_action.dart';

class TodoList extends StatelessWidget {
  final List<Todo> list;
  final String listType;

  const TodoList({super.key, required this.list, required this.listType});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context,value , child) => Container(
        margin: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height * .28,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _TaskActionModal(context, list[index].id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  //  width: SizeConfig.screenWidth * 0.78,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(list[index].category.value?.color ?? 0),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list[index].name ?? "",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.grey[200],
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${DateFormat.yMMMEd().format(list[index].date ?? DateTime.now())}  ${DateFormat.jm().format(list[index].date ?? DateTime.now())}",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[100]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            list[index].description ?? "",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[100]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 60,
                      width: 0.5,
                      color: Colors.grey[200]!.withOpacity(0.7),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text('${list[index].category.value?.name}',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ]),
                ),
              ),
            );
          },
          itemCount: list.length,
          separatorBuilder: (context, index) {
            return const Padding(padding: EdgeInsets.all(8));
          },
        ),
      ),
    );
  }
}

void _TaskActionModal(BuildContext context, int id) {
  showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return TaskAction(
          id: id,
        );
      });
}
