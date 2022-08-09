import 'package:flutter/material.dart';
import 'package:flutter_book_list/login/login_view_model.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final viewModel = LoginViewModel();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '이메일',
            ),
          ),
          TextField(
            controller: _passwordTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '패스워드',
            ),
          ),
          SignInButton(
            Buttons.Email,
            onPressed: () {
              viewModel.signInWithEmailAndPassword(
                  _emailTextController.text, _passwordTextController.text);
            },
          ),
          ElevatedButton(
            child: const Text('신규등록'),
            onPressed: () {
              viewModel.createUserWithEmailAndPassword(
                  _emailTextController.text, _passwordTextController.text);
            },
          ),
          SignInButton(
            Buttons.Google,
            onPressed: () {
              viewModel.signInWithGoogle();
            },
          ),
        ],
      ),
    );
  }
}
