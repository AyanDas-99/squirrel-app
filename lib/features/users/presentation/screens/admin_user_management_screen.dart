import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/widgets/error_text_widget.dart';
import 'package:squirrel_app/dependency_injection.dart';
import 'package:squirrel_app/features/users/presentation/bloc/all_users_bloc.dart';
import 'package:squirrel_app/features/users/presentation/bloc/user_permissions_bloc.dart';
import 'package:squirrel_app/features/users/presentation/widgets/user_card.dart';

class AdminUserManagementScreen extends StatefulWidget {
  final AuthToken token;
  const AdminUserManagementScreen({super.key, required this.token});

  @override
  AdminUserManagementScreenState createState() =>
      AdminUserManagementScreenState();
}

class AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  int openIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    context.read<AllUsersBloc>().add(LoadUsersEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllUsersBloc, AllUsersState>(
      builder: (context, state) {
        return switch (state) {
          AllUsersError() => Center(child: ErrorTextWidget(description:state.message)),
          AllUsersLoaded() => _buildBody(state.users),
          _ => Center(child: CircularProgressIndicator()),
        };
      },
    );
  }

  Widget _buildBody(List<User> users) {
    if (users.isEmpty) {
      return Center(
        child: Text('No users found', style: TextStyle(fontSize: 18)),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SingleChildScrollView(
        child: ShadAccordion<int>(
          children: users.map((user) {
            return BlocProvider(
              create:
                  (context) =>
                      sl<UserPermissionsBloc>()..add(
                        EventGetUserPermissions(
                          token: widget.token,
                          userId: user.id,
                        ),
                      ),
              child: UserCard(user: user, token: widget.token),
            );
          }),
        ),
      ),
    );
  }
}
