part of 'user_permissions_bloc.dart';

sealed class UserPermissionsEvent extends Equatable {
  const UserPermissionsEvent();

  @override
  List<Object> get props => [];
}

class EventGetUserPermissions extends UserPermissionsEvent {
  final AuthToken token;
  final int userId;

  const EventGetUserPermissions({required this.token, required this.userId});
}
