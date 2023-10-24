import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/isar_service.dart';
import 'package:todo_app/state/providers/todo_provider.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _MyEditTaskScreenWidgetState();
}

class _MyEditTaskScreenWidgetState extends State<EditTaskScreen> {
  final IsarService isarService = IsarService();
  @override
  void initState() {
    super.initState();
  }

// var format = DateFormat.yMd('ar');
//   var dateString = format.format(DateTime.now());
  

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {
      isarService.getTaskById(data).then((todo) {
        Provider.of<TodoProvider>(context, listen: false).getTaskById(todo);
      });
    });
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black87,
          statusBarIconBrightness: Brightness.light,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black87,
        title: const Center(child: Text('Edit Task')),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, value, child) => Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration:const BoxDecoration(
                          color:  Color.fromARGB(31, 163, 163, 163),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      height: 36,
                      width: 36,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    )),
               const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text('${value.task?.name}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                    SvgPicture.asset('lib/resources/assets/svg/edit.svg'),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    // SizedBox(
                    //   width: 24,
                    // ),
                    Flexible(
                      child: Text('${value.task?.description}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('lib/resources/assets/svg/clock.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Task Time :',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () => {}, child: Text("${DateFormat.MEd().format(value.task?.date ?? DateTime.now())} at ${DateFormat.jm().format(value.task?.date ?? DateTime.now())}"))
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('lib/resources/assets/svg/tag.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Task Category :',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => {},
                      icon: Icon(IconData(value.task?.category.value?.icon ?? 0,
                          fontFamily: 'MaterialIcons')),
                      label: Text('${value.task?.category.value?.name}'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(value.task?.category.value?.color ?? 0)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('lib/resources/assets/svg/flag.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Task Priority :',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () => {},
                        child: Text("Priority ${value.task?.flag}"))
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    SvgPicture.asset('lib/resources/assets/svg/delete.svg'),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      'Delete Task',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text('Edit Task')),
        ),
      ),
    );
  }
}
