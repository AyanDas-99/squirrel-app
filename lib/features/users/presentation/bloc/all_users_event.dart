part of 'all_users_bloc.dart';

sealed class AllUsersEvent extends Equatable {
  const AllUsersEvent();

  @override
  List<Object> get props => [];
}

class LoadUsersEvent extends AllUsersEvent {
  final AuthToken token;

  const LoadUsersEvent({required this.token});
}
