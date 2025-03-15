part of 'update_permission_bloc.dart';

sealed class UpdatePermissionEvent extends Equatable {
  const UpdatePermissionEvent();

  @override
  List<Object> get props => [];
}

class EventUpdatePermission extends UpdatePermissionEvent {
  final AuthToken authToken;
  final UpdatePermissionParam updatePermissionParam;

  const EventUpdatePermission({
    required this.authToken,
    required this.updatePermissionParam,
  });
}
