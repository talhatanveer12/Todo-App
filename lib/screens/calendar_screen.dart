import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/isar_service.dart';
import 'package:todo_app/state/providers/todo_provider.dart';
import 'package:todo_app/widgets/Modal/add_task.dart';
import 'package:todo_app/widgets/bottom_bar.dart';
import 'package:todo_app/widgets/todo_list.dart';

const List<String> list = <String>['Today', 'Yesterday', '1 Week'];

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _MyCalendarWidgetState();
}

class _MyCalendarWidgetState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  final IsarService _isarService = IsarService();
  late final TabController _tabController;
  @override
  void initState() {
    _isarService.getTaskByDate(selectedDate,false).then((todo) {
      Provider.of<TodoProvider>(context, listen: false).getAllPendingTask(todo);
    });
    _isarService.getTaskByDate(selectedDate,true).then((todo) {
      Provider.of<TodoProvider>(context, listen: false)
          .getAllCompletedTask(todo);
    });
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
            Navigator.of(context).pop();
         return false; // return false if you want to disable device back button click
       },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(31, 163, 163, 163),
          title: const Center(child: Text('Calendar')),
        ),
        body: Consumer<TodoProvider>(builder: (context, task, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DatePicker(
                DateTime.now(),
                height: 80,
                width: 60,
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.purple,
                selectedTextColor: Colors.white,
                dateTextStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
                dayTextStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                monthTextStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                onDateChange: (date) {
                  selectedDate = date;
                  task.getTaskByDate(date);
                },
              ),
              const SizedBox(height: 8.0),
              Card(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4)),
                  child: TabBar(
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.purple),
                      isScrollable: true,
                      controller: _tabController,
                      labelPadding: EdgeInsets.symmetric(horizontal: 30),
                      tabs: const [
                        Tab(
                          child: Text(
                            'Pending',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Complete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                ),
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  TodoList(list: task.todo, listType: 'pending',),
                  TodoList(list: task.completed, listType: 'complete'),
                ],
              )),
            ],
          ),
        ),),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTaskModal(context);
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: Colors.black,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const BottomBar(
          name: 'Calendar',
        ),
      ),
    );
  }
}

void _addTaskModal(BuildContext context) {
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
        return const AddTask();
      });
}
