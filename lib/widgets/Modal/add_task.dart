import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/services/isar_service.dart';
import 'package:todo_app/state/providers/category_provider.dart';
import 'package:todo_app/state/providers/todo_provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskModal();
}

class _AddTaskModal extends State<AddTask> with WidgetsBindingObserver {
  final IsarService _isarService = IsarService();
  int? flagValue;
  Category? category;
  DateTime? selectedDateTime;
  bool dateTimeError = false;
  bool flagError = false;
  bool categoryError = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Category> allCategory = [];
  @override
  void initState() {
    _isarService.getAllCategory().then((categories) {
      Provider.of<CategoryProvider>(context, listen: false)
          .getAllCategory(categories);
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('App is in the foreground (resumed).');
      // You can call your specific function here.
    } else if (state == AppLifecycleState.paused) {
      debugPrint('App is in the foreground (paused).');
      // App is in the background (paused).
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('App is in the foreground (inactive).');
      // App is in an inactive state.
      // This typically occurs when the app is about to be terminated.
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> yourAsyncFunction() async {
    debugPrint("test");
    allCategory = await _isarService.getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double normalHeight = MediaQuery.of(context).size.height * .4;

    Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2025));

    Future<TimeOfDay?> pickTime() => showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

    return Consumer2<CategoryProvider, TodoProvider>(
        builder: (context, categoryDetail, task, child) {
      return SizedBox(
        height: normalHeight + keyboardHeight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: (normalHeight + keyboardHeight) == normalHeight
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Task Title';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: "Task Title",
                          hintStyle: TextStyle(color: Colors.white),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Task Description';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Task Description",
                          hintStyle: TextStyle(color: Colors.white),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final date = await pickDate();
                            if (date != null) {}
                            final time = await pickTime();
                            if (time != null && date != null) {
                              selectedDateTime = DateTime(date.year, date.month,
                                  date.day, time.hour, time.minute);
                                  setState(() {
                                  dateTimeError = false;
                                });
                            }
                          },
                          icon: dateTimeError
                              ? SvgPicture.asset(
                                  'lib/resources/assets/svg/clock-error.svg')
                              : SvgPicture.asset(
                                  'lib/resources/assets/svg/clock.svg'),
                        ),
                        IconButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const DialogCategory(); // Your custom dialog widget.
                                },
                              );

                              if (result != null) {
                                category = result;
                                setState(() {
                                  categoryError = false;
                                });
                              }
                            },
                            icon: categoryError
                                ? SvgPicture.asset(
                                    'lib/resources/assets/svg/tag-error.svg')
                                : SvgPicture.asset(
                                    'lib/resources/assets/svg/tag.svg')),
                        IconButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const DialogTaskPriority(); // Your custom dialog widget.
                                },
                              );

                              if (result != null) {
                                flagValue = result;
                                setState(() {
                                  flagError = false;
                                });
                              }
                            },
                            icon: flagError
                                ? SvgPicture.asset(
                                    'lib/resources/assets/svg/flag-error.svg')
                                : SvgPicture.asset(
                                    'lib/resources/assets/svg/flag.svg'))
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          if (selectedDateTime == null) {
                            debugPrint("Test 000 $flagValue" );
                            setState(() {
                              dateTimeError = selectedDateTime == null ? true : false;
                              flagError = flagValue == null ? true : false;
                              categoryError = category == null ? true : false;
                            });
                            errorDialog(context,
                                'Please Select ${selectedDateTime == null ? flagValue == null ? category == null ? "Data Time, " : "Data Time." : "Data Time, and " : ""} ${category == null ? flagValue == null ? "Category, " : "Category." : ""}  ${flagValue == null ? "and Flag( Task Priority )." : ""}');
                          }
                          if (_formKey.currentState!.validate()) {
                            task.addTask(
                                selectedDateTime,
                                flagValue,
                                _titleController.text,
                                _descriptionController.text,
                                category);
                            Navigator.of(context).pop();
                          }
                        },
                        icon: SvgPicture.asset(
                            'lib/resources/assets/svg/send.svg')),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

Future<void> errorDialog(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Validation Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class DialogTaskPriority extends StatefulWidget {
  const DialogTaskPriority({super.key});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<DialogTaskPriority> {
  //bool _dialogState = false; // Example state that you want to pass back.
  int selectedFlag = -1;
  var arrColor = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //backgroundColor: Colors,
      title: const Center(child: Text('Task Priority')),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        height: MediaQuery.of(context).size.height * .25,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFlag = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color:
                        selectedFlag == index ? Colors.purple : Colors.black54,
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('lib/resources/assets/svg/flag.svg'),
                      Text(
                        '${arrColor[index]}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: arrColor.length,
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Save'),
          onPressed: () {
            Navigator.of(context).pop(selectedFlag + 1);
          },
        ),
      ],
    );
  }
}

// Future<void> _dialogBuilder(BuildContext context, int? flagValue) {
//   int selectedFlag = -1;
//   var arrColor = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//         return
//       });
//     },
//   );
// }

class DialogCategory extends StatefulWidget {
  const DialogCategory({super.key});

  @override
  _DialogCategoryState createState() => _DialogCategoryState();
}

class _DialogCategoryState extends State<DialogCategory> {
  int selectedFlag = -1;
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryDetail, child) => AlertDialog(
        //backgroundColor: Colors,
        title: const Center(child: Text('Choose Category')),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * .7,
          height: MediaQuery.of(context).size.height * .5,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFlag = index;
                    Navigator.of(context).pop(categoryDetail.category[index]);
                  });
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: selectedFlag == index
                              ? Color(categoryDetail.category[index].color ?? 0)
                              : Color(
                                  categoryDetail.category[index].color ?? 0),
                          borderRadius: BorderRadius.circular(6)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(IconData(
                                categoryDetail.category[index].icon ?? 0,
                                fontFamily: 'MaterialIcons'))
                          ],
                        ),
                      ),
                    ),
                    Text(
                      '${categoryDetail.category[index].name}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                ),
              );
            },
            itemCount: categoryDetail.category.length,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Add Category'),
            onPressed: () {
              Navigator.pushNamed(context, '/category');
            },
          ),
        ],
      ),
    );
  }
}

// Future<void> _dialogCategory(BuildContext context, List<Category> allCategory,
//     CategoryProvider categoryDetail) {
//   int selectedFlag = -1;
//   var arrColor = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//   debugPrint('TEST $allCategory');
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//         return 
//       });
//     },
//   );
// }
