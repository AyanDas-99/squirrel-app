import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/features/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/auth/domain/entities/user.dart';
import 'package:squirrel_app/features/auth/domain/repositories/user_repository.dart';
import 'package:squirrel_app/features/auth/domain/usecases/login.dart';
import 'package:squirrel_app/features/auth/domain/usecases/signup.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Signup signUp;
  final Login login;

  UserBloc(this.signUp, this.login) : super(UserInitial()) {
    on<SignUpEvent>(_signup);
    on<LoginEvent>(_login);
  }

  void _login(LoginEvent event, Emitter<UserState> emit) async {
    emit(LoginLoading());
    final usernameAndPassword =
        UsernameAndPassword(username: event.username, password: event.password);
    final failureOrToken = await login(usernameAndPassword);
    failureOrToken.fold(
      (failure) => emit(LoginError(failure.properties.toString())),
      (token) => emit(LoggedIn(token)),
    );
  }

  void _signup(SignUpEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final usernameAndPassword =
        UsernameAndPassword(username: event.username, password: event.password);
    final failureOrUser = await signUp(usernameAndPassword);
    failureOrUser.fold(
      (failure) => emit(SignupError(failure.properties?.first.toString() ??
          failure.properties.toString())),
      (user) => emit(UserLoaded(user)),
    );
  }
}
