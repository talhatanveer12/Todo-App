import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/isar_service.dart';
import 'package:todo_app/state/providers/todo_provider.dart';
import 'package:todo_app/state/providers/user_provider.dart';
import 'package:todo_app/widgets/Modal/add_task.dart';
import 'package:todo_app/widgets/bottom_bar.dart';

const List<String> list = <String>['Today', 'Yesterday', '1 Week'];
const List<String> list1 = <String>['Completed', 'Deleted', 'Pending'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomeWidgetState();
}

class _MyHomeWidgetState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final int number = 1;
  final IsarService _isarService = IsarService();
  String dropdownValue = list.first;
  String dropdownValue1 = list1.first;
  late final TabController _tabController;

  @override
  void initState() {
    _isarService.getTask(false).then((todo) {
      Provider.of<TodoProvider>(context, listen: false).getAllPendingTask(todo);
    });
    _isarService.getTask(true).then((todo) {
      Provider.of<TodoProvider>(context, listen: false)
          .getAllCompletedTask(todo);
    });
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserInformationProvider, TodoProvider>(
        builder: (context, userInfo, task, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarIconBrightness: Brightness.light,
                ),
                elevation: 0,
                backgroundColor: const Color.fromARGB(31, 163, 163, 163),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'lib/resources/assets/svg/bar.svg',
                    ),
                    const Text(
                      'Home',
                      style: TextStyle(fontSize: 16),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: userInfo.user?.photoURL == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 20,
                            )
                          : CircleAvatar(
                              radius: 20,
                              child: ClipOval(
                                child: Image.network(
                                  userInfo.user?.photoURL ?? '',
                                  width:
                                      40, // Set the width to twice the radius
                                  height:
                                      40, // Set the height to twice the radius
                                  fit: BoxFit
                                      .cover, // This ensures the image covers the oval shape
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              body: number == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Center(
                              child: SvgPicture.asset(
                                  'lib/resources/assets/svg/task.svg')),
                          const Text(
                            'What do you want to do today?',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const Text('Tap + to add your tasks',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white))
                        ])
                  : Container(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "Search for your task...",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  prefixIconColor: Colors.amber,
                                  prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: SvgPicture.asset(
                                          'lib/resources/assets/svg/search.svg')),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
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
                                    labelPadding:
                                        EdgeInsets.symmetric(horizontal: 30),
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
                                      Tab(
                                        child: Text(
                                          'InComplete',
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
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height:
                                      MediaQuery.of(context).size.height * .28,
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color:
                                                const Color.fromARGB(
                                              31, 163, 163, 163),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: ListTile(
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            '/edit-task',
                                            arguments: task.todo[index].id,
                                          ),
                                          leading: SvgPicture.asset(
                                              'lib/resources/assets/svg/circle.svg'),
                                          title: Text(
                                            '${task.todo[index].name}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '${task.todo[index].description}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                      color: Colors.purple,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              IconData(
                                                                  task
                                                                          .todo[
                                                                              index]
                                                                          .category
                                                                          .value
                                                                          ?.icon ??
                                                                      0,
                                                                  fontFamily:
                                                                      'MaterialIcons'),
                                                              size: 16,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 4.0,
                                                                      left:
                                                                          4.0),
                                                              child: Text(
                                                                '${task.todo[index].category.value?.name}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        11),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  Container(
                                                      color: Colors.blue,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'lib/resources/assets/svg/flag.svg',
                                                              width: 14,
                                                              height: 14,
                                                            ),
                                                            Text(
                                                              '${task.todo[index].flag}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: task.todo.length,
                                    separatorBuilder: (context, index) {
                                      return const Padding(
                                          padding: EdgeInsets.all(8));
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height:
                                      MediaQuery.of(context).size.height * .28,
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color:
                                                const Color.fromARGB(
                                              31, 163, 163, 163),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: ListTile(
                                          leading: SvgPicture.asset(
                                              'lib/resources/assets/svg/circle.svg'),
                                          title: Text(
                                            '${task.completed[index].name}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            '${task.completed[index].description}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: task.completed.length,
                                    separatorBuilder: (context, index) {
                                      return const Padding(
                                          padding: EdgeInsets.all(8));
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height:
                                      MediaQuery.of(context).size.height * .28,
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color:
                                                const Color.fromARGB(
                                              31, 163, 163, 163),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: ListTile(
                                          leading: SvgPicture.asset(
                                              'lib/resources/assets/svg/circle.svg'),
                                          title: Text(
                                            '${task.completed[index].name}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            '${task.completed[index].description}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: task.completed.length,
                                    separatorBuilder: (context, index) {
                                      return const Padding(
                                          padding: EdgeInsets.all(8));
                                    },
                                  ),
                                ),
                              ],
                            )),
                            // Align(
                            //   alignment: Alignment.topLeft,
                            //   child: Container(
                            //     margin: const EdgeInsets.only(top: 10),
                            //     width: MediaQuery.of(context).size.width * .25,
                            //     padding:
                            //         const EdgeInsets.only(right: 10, left: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.black38,
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),

                            //     alignment: Alignment.topLeft,
                            //     // dropdown below..
                            //     child: DropdownButton<String>(
                            //       value: dropdownValue,
                            //       onChanged: (value) =>
                            //           setState(() => dropdownValue = value!),
                            //       // onChanged: (String newValue)
                            //       //   setState(() => dropdownValue = newValue),
                            //       items: list
                            //           .map<DropdownMenuItem<String>>(
                            //               (String value) =>
                            //                   DropdownMenuItem<String>(
                            //                     value: value,
                            //                     child: Text(value),
                            //                   ))
                            //           .toList(),

                            //       // add extra sugar..
                            //       icon: SvgPicture.asset(
                            //           'lib/resources/assets/svg/arrow.svg'),
                            //       iconSize: 42,
                            //       underline: const SizedBox(),
                            //       style: const TextStyle(color: Colors.white),
                            //       dropdownColor: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   margin: const EdgeInsets.only(top: 10),
                            //   height: MediaQuery.of(context).size.height * .28,
                            //   child: ListView.separated(
                            //     itemBuilder: (context, index) {
                            //       return ListTile(
                            //         onTap: () => Navigator.pushNamed(
                            //           context,
                            //           '/edit-task',
                            //           arguments: task.todo[index].id,
                            //         ),
                            //         tileColor:
                            //             const Color.fromARGB(31, 163, 163, 163),
                            //         leading: SvgPicture.asset(
                            //             'lib/resources/assets/svg/circle.svg'),
                            //         title: Text(
                            //           '${task.todo[index].name}',
                            //           style: const TextStyle(color: Colors.white),
                            //         ),
                            //         subtitle: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Flexible(
                            //               child: Text(
                            //                 '${task.todo[index].description}',
                            //                 maxLines: 1,
                            //                 overflow: TextOverflow.ellipsis,
                            //                 style: const TextStyle(
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //             Row(
                            //               children: [
                            //                 Container(
                            //                     color: Colors.purple,
                            //                     child: Padding(
                            //                       padding:
                            //                           const EdgeInsets.all(8.0),
                            //                       child: Row(
                            //                         mainAxisAlignment:
                            //                             MainAxisAlignment
                            //                                 .spaceBetween,
                            //                         crossAxisAlignment:
                            //                             CrossAxisAlignment.center,
                            //                         children: [
                            //                           Icon(
                            //                             IconData(
                            //                                 task
                            //                                         .todo[index]
                            //                                         .category
                            //                                         .value
                            //                                         ?.icon ??
                            //                                     0,
                            //                                 fontFamily:
                            //                                     'MaterialIcons'),
                            //                             size: 16,
                            //                           ),
                            //                           Padding(
                            //                             padding:
                            //                                 const EdgeInsets.only(
                            //                                     top: 4.0,
                            //                                     left: 4.0),
                            //                             child: Text(
                            //                               '${task.todo[index].category.value?.name}',
                            //                               style: const TextStyle(
                            //                                   color: Colors.white,
                            //                                   fontSize: 11),
                            //                             ),
                            //                           ),
                            //                         ],
                            //                       ),
                            //                     )),
                            //                 Container(
                            //                     color: Colors.blue,
                            //                     child: Padding(
                            //                       padding:
                            //                           const EdgeInsets.all(8.0),
                            //                       child: Row(
                            //                         children: [
                            //                           SvgPicture.asset(
                            //                             'lib/resources/assets/svg/flag.svg',
                            //                             width: 14,
                            //                             height: 14,
                            //                           ),
                            //                           Text(
                            //                             '${task.todo[index].flag}',
                            //                             style: const TextStyle(
                            //                                 color: Colors.white),
                            //                           ),
                            //                         ],
                            //                       ),
                            //                     )),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //     itemCount: task.todo.length,
                            //     separatorBuilder: (context, index) {
                            //       return const Padding(
                            //           padding: EdgeInsets.all(8));
                            //     },
                            //   ),
                            // ),
                            // Align(
                            //   alignment: Alignment.topLeft,
                            //   child: Container(
                            //     margin: const EdgeInsets.only(top: 10),
                            //     width: MediaQuery.of(context).size.width * .26,
                            //     padding:
                            //         const EdgeInsets.only(right: 10, left: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.black38,
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),

                            //     alignment: Alignment.topLeft,
                            //     // dropdown below..
                            //     child: DropdownButton<String>(
                            //       value: dropdownValue1,
                            //       onChanged: (value) =>
                            //           setState(() => dropdownValue1 = value!),
                            //       // onChanged: (String newValue)
                            //       //   setState(() => dropdownValue = newValue),
                            //       items: list1
                            //           .map<DropdownMenuItem<String>>(
                            //               (String value) =>
                            //                   DropdownMenuItem<String>(
                            //                     value: value,
                            //                     child: Text(value),
                            //                   ))
                            //           .toList(),

                            //       // add extra sugar..
                            //       icon: SvgPicture.asset(
                            //           'lib/resources/assets/svg/arrow.svg'),
                            //       iconSize: 42,
                            //       underline: const SizedBox(),
                            //       style: const TextStyle(color: Colors.white),
                            //       dropdownColor: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   margin: const EdgeInsets.only(top: 10),
                            //   height: MediaQuery.of(context).size.height * .28,
                            //   child: ListView.separated(
                            //     itemBuilder: (context, index) {
                            //       return ListTile(
                            //         tileColor:
                            //             const Color.fromARGB(31, 163, 163, 163),
                            //         leading: SvgPicture.asset(
                            //             'lib/resources/assets/svg/circle.svg'),
                            //         title: Text(
                            //           '${task.completed[index].name}',
                            //           style: const TextStyle(color: Colors.white),
                            //         ),
                            //         subtitle: Text(
                            //           '${task.completed[index].description}',
                            //           style: const TextStyle(color: Colors.white),
                            //         ),
                            //       );
                            //     },
                            //     itemCount: task.completed.length,
                            //     separatorBuilder: (context, index) {
                            //       return const Padding(
                            //           padding: EdgeInsets.all(8));
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _addTaskModal(context);
                },
                child: const Icon(Icons.add),
              ),
              backgroundColor: Colors.black,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: const BottomBar(),
            ));
  }
}

void _addTaskModal(BuildContext context) async {
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
