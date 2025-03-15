import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/features/users/domain/usecases/get_all_users.dart';

part 'all_users_event.dart';
part 'all_users_state.dart';

class AllUsersBloc extends Bloc<AllUsersEvent, AllUsersState> {

  final GetAllUsers getAllUsers;

  AllUsersBloc(this.getAllUsers) : super(AllUsersInitial()) {
    on<LoadUsersEvent>((event, emit) async{
      emit(AllUsersLoading());
      final failureOrAllUsers = await getAllUsers(event.token);
      failureOrAllUsers.fold((failure) => emit(AllUsersError(message: failure.properties?.first?.toString() ?? "Error loading users")), (users) => emit(AllUsersLoaded(users: users)));
    });
  }
}
