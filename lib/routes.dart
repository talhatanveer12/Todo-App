import 'package:flutter/material.dart';
import 'package:todo_app/middleware/auth_middleware.dart';
import 'package:todo_app/screens/calendar_screen.dart';
import 'package:todo_app/screens/category_screen.dart';
import 'package:todo_app/screens/edit_task_screen.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

class RouteGenerator {
  static final AuthMiddleware _middleware = AuthMiddleware();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) {
            return FutureBuilder<bool>(
              future: _middleware.checkAuth(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    // User is authenticated, navigate to the profile page
                    return const HomeScreen();
                  }
                  // User is not authenticated, the middleware has already redirected to the login page
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (context) {
            return FutureBuilder<bool>(
              future: _middleware.checkAuth(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    // User is authenticated, navigate to the profile page
                    return const ProfileScreen();
                  }
                  // User is not authenticated, the middleware has already redirected to the login page
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        );
      case '/calendar':
        return MaterialPageRoute(builder: (context) => const CalendarScreen());
      case '/register':
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/category':
        return MaterialPageRoute(builder: (context) => const CategoryScreen());
      case '/edit-task':
        return MaterialPageRoute(builder: (context) => const EditTaskScreen());
      default:
        // Handle unknown routes here
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
