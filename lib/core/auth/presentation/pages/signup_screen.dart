import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/utils/show_toaster.dart';
import 'package:squirrel_app/core/widgets/logo_image.dart';
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
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent.shade100, Colors.redAccent],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LogoImage(width: 50),
                      const SizedBox(width: 10),
                      Text(
                        "Squirrel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Create a new account",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: BlocConsumer<UserBloc, UserState>(
                  builder: (context, state) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextField(
                              controller: userNameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                filled: true,
                                fillColor: Colors.red.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                filled: true,
                                fillColor: Colors.red.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),

                            const SizedBox(height: 20),
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Confirm password",
                                filled: true,
                                fillColor: Colors.red.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),

                              onChanged: (value) {
                                setState(() {});
                              },
                            ),

                            const SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                  elevation: 5,
                                ),
                                onPressed:
                                    ((state is UserLoading) ||
                                            (passwordController.text !=
                                                confirmPasswordController
                                                    .text) ||
                                            passwordController.text.isEmpty)
                                        ? null
                                        : () {
                                          context.read<UserBloc>().add(
                                            SignUpEvent(
                                              username: userNameController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                        },
                                child:
                                    (state is UserLoading)
                                        ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.red,
                                          ),
                                        )
                                        : Text(
                                          "Create Account",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                              ),
                            ),

                            const SizedBox(height: 50),
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
                          ],
                        ),
                      ),
                    );
                  },
                  listener: (BuildContext context, UserState state) {
                    switch (state) {
                      case UserLoaded():
                        showToast(
                          context: context,
                          desc: "User Created!\nPlease Login",
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      case SignupError():
                        showToast(
                          context: context,
                          desc: state.message,
                          isDestructive: true,
                        );
                      default:
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
