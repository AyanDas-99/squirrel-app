part of 'user_permissions_bloc.dart';

sealed class UserPermissionsState extends Equatable {
  const UserPermissionsState();

  @override
  List<Object> get props => [];
}

final class UserPermissionsInitial extends UserPermissionsState {}

final class UserPermissionsLoading extends UserPermissionsState {}

final class UserPermissionsError extends UserPermissionsState {
  final String message;

  const UserPermissionsError({required this.message});
}

final class UserPermissionsLoaded extends UserPermissionsState {
  final List<int> permissions;

  const UserPermissionsLoaded({required this.permissions});
}
