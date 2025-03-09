import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';
import 'package:squirrel_app/core/auth/domain/usecases/get_local_token.dart';
import 'package:squirrel_app/core/auth/domain/usecases/login.dart';
import 'package:squirrel_app/core/auth/domain/usecases/logout.dart';
import 'package:squirrel_app/core/auth/domain/usecases/signup.dart';
import 'package:squirrel_app/core/auth/domain/usecases/validate_token.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Signup signUp;
  final Login login;
  final GetLocalToken getLocalToken;
  final ValidateToken validateToken;
  final Logout logout;

  UserBloc({
    required this.signUp,
    required this.login,
    required this.getLocalToken,
    required this.validateToken,
    required this.logout,
  }) : super(UserInitial()) {
    on<SignUpEvent>(_signup);
    on<LoginEvent>(_login);
    on<CheckLogin>(_checkLogin);
    on<LogoutEvent>(_logout);
  }

  void _logout(LogoutEvent event, Emitter<UserState> emit) async {
    emit(LoginLoading());
    final tmpState = state;
    final failureOrLoggedout = await logout(NoParams());
    if (failureOrLoggedout.isLeft()) {
      emit(LocalAuthTokenError());
      emit(tmpState);
      return;
    }
    if (failureOrLoggedout.isRight()) {
      bool? loggedOut = failureOrLoggedout.fold((l) => null, (r) => r);
      if (loggedOut == true) {
        emit(UserInitial());
      } else {
        emit(tmpState);
      }
    }
  }

  void _login(LoginEvent event, Emitter<UserState> emit) async {
    emit(LoginLoading());
    final usernameAndPassword = UsernameAndPassword(
      username: event.username,
      password: event.password,
    );
    final failureOrTokenUser = await login(usernameAndPassword);
    failureOrTokenUser.fold(
      (failure) => emit(LoginError(failure.properties.toString())),
      (tokenAndUser) => emit(LoggedIn(tokenAndUser.token, tokenAndUser.param)),
    );
  }

  void _signup(SignUpEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final usernameAndPassword = UsernameAndPassword(
      username: event.username,
      password: event.password,
    );
    final failureOrUser = await signUp(usernameAndPassword);
    failureOrUser.fold(
      (failure) => emit(
        SignupError(
          failure.properties?.first.toString() ?? failure.properties.toString(),
        ),
      ),
      (user) => emit(UserLoaded(user)),
    );
  }

  void _checkLogin(CheckLogin event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final failureOrtoken = await getLocalToken(NoParams());

    if (failureOrtoken.isLeft()) {
      emit(LocalAuthTokenError());
      return;
    }
    if (failureOrtoken.isRight()) {
      AuthToken? token = failureOrtoken.fold((l) => null, (r) => r);
      final failureOrUser = await validateToken(token!);

      if (failureOrUser.isLeft()) {
        emit(LocalAuthTokenError());
        return;
      }
      if (failureOrUser.isRight()) {
        User? user = failureOrUser.fold((l) => null, (r) => r);
        emit(LoggedIn(token, user!));
        return;
      }
    }
  }
}
