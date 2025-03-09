import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:squirrel_app/core/auth/presentation/pages/login_screen.dart';
import 'package:squirrel_app/features/items/presentation/pages/home_screen.dart';
import 'dart:developer' as dev;

class ScreenController extends StatefulWidget {
  const ScreenController({super.key});

  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(CheckLogin());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (BuildContext context, state) {
        if (state is UserLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is LoggedIn) {
          return HomeScreen(authToken: state.token);
        }

        if (state is UserInitial ||
            state is LocalAuthTokenError ||
            state is LoginError) {
          return const LoginScreen();
        }

        return LoginScreen();
      },
      listener: (BuildContext context, UserState state) {
        dev.log(state.runtimeType.toString());
      },
    );
  }
}
