import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/isar_service.dart';
import 'package:todo_app/state/providers/todo_provider.dart';
import 'package:todo_app/state/providers/user_provider.dart';
import 'package:todo_app/widgets/Modal/add_task.dart';
import 'package:todo_app/widgets/bottom_bar.dart';
import 'package:todo_app/widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomeWidgetState();
}

class _MyHomeWidgetState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final int number = 1;
  final IsarService _isarService = IsarService();
  late final TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _fetchTasks();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    super.initState();
  }

  Future<void> _fetchTasks() async {
    try {
      // Start all API calls at the same time
      final results = await Future.wait([
        _isarService.getTask(false),
        _isarService.getTask(true),
        _isarService.getInCompleteTask()
      ]);

      final pendingTasks = results[0];
      final completedTasks = results[1];
      final incompletedTasks = results[2];

      // Notify your provider
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      todoProvider.getAllPendingTask(pendingTasks);
      todoProvider.getAllCompletedTask(completedTasks);
      todoProvider.getAllInCompletedTask(incompletedTasks);
    } catch (e) {
      // Handle error. You can show a snackbar or some other notification.
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch tasks!')));
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      debugPrint("Testing Pass");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserInformationProvider, TodoProvider>(
        builder: (context, userInfo, task, child) => WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop();
                return false; // return false if you want to disable device back button click
              },
              child: Scaffold(
                key: _scaffoldKey,
                drawer: Drawer(
                    backgroundColor: Colors.black,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 48.0, right: 8, left: 8),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(60)),
                            child: userInfo.user?.photoURL == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 50,
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    child: ClipOval(
                                      child: Image.network(
                                        userInfo.user?.photoURL ?? '',
                                        width:
                                            100, // Set the width to twice the radius
                                        height:
                                            100, // Set the height to twice the radius
                                        fit: BoxFit
                                            .cover, // This ensures the image covers the oval shape
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              userInfo.user?.displayName ?? 'User Name',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTextButton('5 Task left', Colors.white),
                              const SizedBox(
                                width: 8,
                              ),
                              _buildTextButton('10 Task done', Colors.white),
                            ],
                          ),
                          _buildListTile(
                              'Profile',
                              'lib/resources/assets/svg/profile.svg',
                              context,
                              () => Navigator.pushNamedAndRemoveUntil(
                                  context, '/profile', (route) => false),
                              ''),
                          _buildListTile(
                              'Calendar',
                              'lib/resources/assets/svg/calendar-inactive.svg',
                              context,
                              () => Navigator.pushNamedAndRemoveUntil(
                                  context, '/calendar', (route) => false),
                              ''),
                          _buildListTile(
                              'Focus',
                              'lib/resources/assets/svg/time.svg',
                              context,
                              () => {},
                              ''),
                          _buildListTile(
                              'About',
                              'lib/resources/assets/svg/about.svg',
                              context,
                              () => {},
                              ''),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () => {
                                // FirebaseAuth.instance.signOut(),
                                Navigator.pushReplacementNamed(
                                    context, '/login')
                              },
                              child: Row(children: [
                                SvgPicture.asset(
                                    'lib/resources/assets/svg/logout.svg'),
                                const SizedBox(width: 16),
                                const Text('Logout',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16)),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    )),
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
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: SvgPicture.asset(
                          'lib/resources/assets/svg/bar.svg',
                        ),
                      ),
                      const Text(
                        'Home',
                        style: TextStyle(fontSize: 16),
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const Text('Tap + to add your tasks',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))
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
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.purple),
                                      isScrollable: true,
                                      controller: _tabController,
                                      labelPadding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      tabs: const [
                                        Tab(
                                          child: Text(
                                            'Pending',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'Complete',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'InComplete',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                              Expanded(
                                  child: TabBarView(
                                controller: _tabController,
                                children: [
                                  TodoList(
                                    list: task.todo,
                                    listType: 'pending',
                                  ),
                                  TodoList(
                                      list: task.completed,
                                      listType: 'complete'),
                                  TodoList(
                                      list: task.inComplete,
                                      listType: 'inComplete'),
                                ],
                              )),
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
                bottomNavigationBar: const BottomBar(
                  name: 'Home',
                ),
              ),
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

Widget _buildTextButton(String text, Color color) {
  return TextButton(
    onPressed: () => {},
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.purple),
      // padding: MaterialStateProperty.all(
      //   const EdgeInsets.only(left: 48, right: 48, top: 16, bottom: 16),
      // ),
    ),
    child: Text(text, style: TextStyle(color: color)),
  );
}

Widget _buildListTile(String title, String iconPath, BuildContext context,
    VoidCallback dialogBuilder, String? username) {
  return Column(
    children: [
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath),
              const SizedBox(width: 16),
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          InkWell(
            onTap: dialogBuilder,
            child: SvgPicture.asset('lib/resources/assets/svg/rightArrow.svg'),
          )
        ],
      ),
    ],
  );
}
