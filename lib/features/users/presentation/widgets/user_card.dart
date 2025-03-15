import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/features/users/domain/usecases/update_permission.dart';
import 'package:squirrel_app/features/users/presentation/bloc/update_permission_bloc.dart';
import 'package:squirrel_app/features/users/presentation/bloc/user_permissions_bloc.dart';

class UserCard extends StatefulWidget {
  final User user;
  final AuthToken token;
  final bool isOpen;
  final VoidCallback switchVisibility;
  const UserCard({
    super.key,
    required this.user,
    required this.token,
    required this.isOpen,
    required this.switchVisibility,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  _updatePermission(int permission, bool grant) {
    context.read<UpdatePermissionBloc>().add(
      EventUpdatePermission(
        authToken: widget.token,
        updatePermissionParam: UpdatePermissionParam(
          userId: widget.user.id,
          permissionId: permission,
          grant: grant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdatePermissionBloc, UpdatePermissionState>(
      listener: (context, state) {
        if (state is PermissionUpdated) {
          context.read<UserPermissionsBloc>().add(
            EventGetUserPermissions(
              token: widget.token,
              userId: widget.user.id,
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User avatar
                  CircleAvatar(radius: 15, child: Icon(Icons.person)),
                  SizedBox(width: 25),
                  // User details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "ID: ${widget.user.id}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),

                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.switchVisibility();
                    },
                    icon:
                        widget.isOpen
                            ? Icon(Icons.arrow_drop_up_sharp)
                            : Icon(Icons.arrow_drop_down_sharp),
                  ),
                ],
              ),
              if (widget.isOpen)
                BlocConsumer<UserPermissionsBloc, UserPermissionsState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return switch (state) {
                      UserPermissionsError() => Center(
                        child: Text(state.message),
                      ),
                      UserPermissionsLoaded() => Row(
                        children: [
                          // Read Permission Switch
                          Expanded(
                            child: Row(
                              children: [
                                Text('Read'),
                                SizedBox(width: 8),
                                Switch(
                                  value: state.permissions.contains(1),
                                  onChanged: (value) {
                                    _updatePermission(1, value);
                                  },
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          // Issue Permission Switch
                          Expanded(
                            child: Row(
                              children: [
                                Text('Issue'),
                                SizedBox(width: 8),
                                Switch(
                                  value: state.permissions.contains(2),
                                  onChanged: (value) {
                                    _updatePermission(2, value);
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ],
                            ),
                          ),

                          // Write Permission Switch
                          Expanded(
                            child: Row(
                              children: [
                                Text('Write'),
                                SizedBox(width: 8),
                                Switch(
                                  value: state.permissions.contains(3),
                                  onChanged: (value) {
                                    _updatePermission(3, value);
                                  },
                                  activeColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _ => Center(child: CircularProgressIndicator()),
                    };
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
