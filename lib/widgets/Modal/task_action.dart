import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/isar_service.dart';
import 'package:todo_app/state/providers/todo_provider.dart';

class TaskAction extends StatefulWidget {
  final int id;
  const TaskAction({Key? key, required this.id}) : super(key: key);

  @override
  State<TaskAction> createState() => _TaskActionModal();
}

class _TaskActionModal extends State<TaskAction> {
  IsarService _isarService = IsarService();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, value, child) => SizedBox(
        height: MediaQuery.of(context).size.height * .2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Task Action',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed('/edit-task', arguments: widget.id),
                    child: const Text(
                      'Edit Task',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      _isarService.updateState(widget.id);
                      _isarService.getTask(false).then((todo) {
                        value.getAllPendingTask(todo);
                      });
                      _isarService.getTask(true).then((completed) {
                        value.getAllCompletedTask(completed);
                      });
                      Navigator.of(context).pop();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'Complete',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
