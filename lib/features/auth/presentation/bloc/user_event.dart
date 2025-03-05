part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends UserEvent {
  final String username;
  final String password;

  const SignUpEvent({required this.username, required this.password});
  @override
  List<Object> get props => [username, password];
}

class LoginEvent extends UserEvent {
  final String username;
  final String password;

  const LoginEvent({required this.username, required this.password});
  @override
  List<Object> get props => [username, password];
}
