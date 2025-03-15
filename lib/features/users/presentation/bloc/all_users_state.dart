part of 'all_users_bloc.dart';

sealed class AllUsersState extends Equatable {
  const AllUsersState();

  @override
  List<Object> get props => [];
}

final class AllUsersInitial extends AllUsersState {}

final class AllUsersLoading extends AllUsersState {}

final class AllUsersError extends AllUsersState {
  final String message;

  const AllUsersError({required this.message});
}

final class AllUsersLoaded extends AllUsersState {
  final List<User> users;

  const AllUsersLoaded({required this.users});
}
