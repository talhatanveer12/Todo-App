import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/authentication_service.dart';
import 'package:todo_app/state/providers/user_provider.dart';
import 'package:todo_app/widgets/text_field.dart';
import 'package:todo_app/widgets/divider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyLoginWidgetState();
}

class _MyLoginWidgetState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Login')),
      ),
      body: Consumer<UserInformationProvider>(
        builder: (context, userInfo, child) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Todo App',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ))),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: 'Email',
                        controller: _emailController,
                      ),
                      CustomTextField(
                        labelText: 'Password',
                        controller: _passwordController,
                      ),
                      ElevatedButton(
                          onPressed: () => _signIn(context, userInfo),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)),
                          child: const Text('Login')),
                      CustomDivider(),
                      OutlinedButton.icon(
                        onPressed: () => {_signInWithGoogle(context, userInfo)},
                        label: Text('Login with Google'),
                        icon: SvgPicture.asset(
                            'lib/resources/assets/svg/google.svg'),
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don’t have an account? '),
                        TextButton(onPressed: () => {}, child: Text('Register'))
                      ],
                    ))
              ],
            )),
      ),
    );
  }

  void _signInWithGoogle(BuildContext context,
      UserInformationProvider userInformationProvider) async {
    User? user = await _authService.signUpWithGoogle();

    if (user != null) {
      userInformationProvider.getUserInfo(user);
      Navigator.pushNamed(context, '/');
    } else {
      debugPrint("Error");
    }
  }

  void _signIn(BuildContext context,
      UserInformationProvider userInformationProvider) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _authService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      userInformationProvider.getUserInfo(user);
      Navigator.pushNamed(context, '/');
    } else {
      debugPrint("Error");
    }
  }
}
