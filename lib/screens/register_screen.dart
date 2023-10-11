import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/services/authentication_service.dart';
import 'package:todo_app/widgets/text_field.dart';
import 'package:todo_app/widgets/divider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _MyRegisterWidgetState();
}

class _MyRegisterWidgetState extends State<RegisterScreen> {

  final AuthService _authService = AuthService();

final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Register')),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Expanded(flex: 1, child: Center(child: Text('Todo App',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),))),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    CustomTextField(labelText: 'Username',controller: _usernameController,),
                    CustomTextField(labelText: 'Email',controller: _emailController,),
                    CustomTextField(labelText: 'Password',controller: _passwordController,),
                    ElevatedButton(
                        onPressed: () => _signUp(context),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text('Register')),
                    CustomDivider(),
                    OutlinedButton.icon(onPressed: () => {},label: const Text('SignUp with Google'), icon: SvgPicture.asset('lib/resources/assets/svg/google.svg'),
                     style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),),
                     
                  ],
                ),
              ),
              Expanded(flex: 1,child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Login'))
                ],
              ))
            ],
          )),
    );
  }

  void _signUp(BuildContext context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _authService.signUpWithEmailAndPassword(email, password,username);

    if (user != null) {
      Navigator.pushNamed(context, '/');
    } else {
      print("Error");
    }
  }
}
