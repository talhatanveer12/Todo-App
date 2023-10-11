import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/state/providers/user_provider.dart';

class AuthMiddleware {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkAuth(BuildContext context) async {
    final user = _auth.currentUser;

    if (user == null) {
      // User is not authenticated, navigate to the login page
      Navigator.pushReplacementNamed(context, '/login');
      return false;
    } else {
      // User is authenticated, you can load user data or perform other actions here
      // For example, you can update user information in a Provider
      final userInformationProvider =
          Provider.of<UserInformationProvider>(context, listen: false);
      userInformationProvider.getUserInfo(user);
      return true;
    }
  }
}
