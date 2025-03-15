import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:squirrel_app/core/auth/presentation/pages/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    controller: userNameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  if (state is LoginLoading) CircularProgressIndicator(),
                  if (state is! LoginLoading)
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(
                          LoginEvent(
                            username: userNameController.text,
                            password: passwordController.text,
                          ),
                        );
                      },
                      child: Text('Login'),
                    ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                        (route) => false,
                      );
                    },
                    child: Text("Don't have an account? Signup"),
                  ),
                  SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
