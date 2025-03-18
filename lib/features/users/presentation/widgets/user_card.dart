import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/widgets/error_text_widget.dart';
import 'package:squirrel_app/features/users/domain/usecases/update_permission.dart';
import 'package:squirrel_app/features/users/presentation/bloc/update_permission_bloc.dart';
import 'package:squirrel_app/features/users/presentation/bloc/user_permissions_bloc.dart';

class UserCard extends StatefulWidget {
  final User user;
  final AuthToken token;
  const UserCard({super.key, required this.user, required this.token});

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
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: ShadAccordionItem(
          value: widget.user.id,
          underlineTitleOnHover: false,
          separator: Container(),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User avatar
              Icon(Icons.person_outline_sharp),
              SizedBox(width: 30),
              // User details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "ID: ${widget.user.id}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: BlocConsumer<UserPermissionsBloc, UserPermissionsState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return switch (state) {
                  UserPermissionsError() => Center(
                    child: ErrorTextWidget(description: state.message),
                  ),
                  UserPermissionsLoaded() => Column(
                    children: [
                      // Read Permission Switch
                      Row(
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
                      // Issue Permission Switch
                      Row(
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

                      // Write Permission Switch
                      Row(
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
                    ],
                  ),
                  _ => Center(child: CircularProgressIndicator()),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
