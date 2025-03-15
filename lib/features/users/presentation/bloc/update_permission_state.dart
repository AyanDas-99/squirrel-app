part of 'update_permission_bloc.dart';

sealed class UpdatePermissionState extends Equatable {
  const UpdatePermissionState();

  @override
  List<Object> get props => [];
}

final class UpdatePermissionInitial extends UpdatePermissionState {}

final class UpdatePermissionLoading extends UpdatePermissionState {}

final class UpdatePermissionError extends UpdatePermissionState {
  final String message;

  const UpdatePermissionError({required this.message});
}

final class PermissionUpdated extends UpdatePermissionState {}
