import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';

class IsAdminText extends StatelessWidget {
  const IsAdminText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder:
          (context, state) =>
              (state is LoggedIn && state.user.isAdmin)
                  ? Text(
                    "Admin",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : Container(),
    );
  }
}
