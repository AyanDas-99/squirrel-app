part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class SignupError extends UserState {
  final String message;

  const SignupError(this.message);

  @override
  List<Object> get props => [message];
}

final class LoginLoading extends UserState {}

final class LoggedIn extends UserState {
  final AuthToken token;
  final User user;

  const LoggedIn(this.token, this.user);

  @override
  List<Object> get props => [token];
}

final class LoginError extends UserState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}

final class LocalAuthTokenError extends UserState {}