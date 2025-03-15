import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/dependency_injection.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:squirrel_app/core/auth/presentation/pages/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => sl<UserBloc>(),
          child: Center(
            child: BlocConsumer<UserBloc, UserState>(
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
                    if (state is UserLoading) CircularProgressIndicator(),
                    if (state is! UserLoading)
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserBloc>().add(
                            SignUpEvent(
                              username: userNameController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                        child: Text('Signup'),
                      ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text("Already have an account? Login"),
                    ),
                    SizedBox(height: 30),
                  ],
                );
              },
              listener: (BuildContext context, UserState state) {
                switch (state) {
                  case UserLoaded():
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  case SignupError():
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  default:
                  // TODO: Handle this case.
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
