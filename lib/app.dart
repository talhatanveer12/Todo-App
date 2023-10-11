import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/calendar_screen.dart';
import 'package:todo_app/screens/category_screen.dart';
import 'package:todo_app/screens/edit_task_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/profile_screen.dart';
import 'package:todo_app/screens/register_screen.dart';
import 'package:todo_app/state/providers/category_provider.dart';
import 'package:todo_app/state/providers/todo_provider.dart';
import 'package:todo_app/state/providers/user_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = _auth.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInformationProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
        )
      ],
      child: MaterialApp(
        title: 'My Flutter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.purple,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) {
            final userProvider = Provider.of<UserInformationProvider>(context,listen: true);
            if (_auth.currentUser != null) {
              userProvider.getUserInfo(user);
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
            
          },
          '/profile': (context) => const ProfileScreen(),
          '/calendar': (context) => const CalendarScreen(),
          '/register': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/category':(context) => const CategoryScreen(),
          '/edit-task':(context) => const EditTaskScreen(),
        },
      ),
    );
  }
}
