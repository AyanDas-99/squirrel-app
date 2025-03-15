import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/users/domain/entities/permisssion.dart';
import 'package:squirrel_app/features/users/domain/usecases/get_permissions_for_user.dart';

part 'user_permissions_event.dart';
part 'user_permissions_state.dart';

class UserPermissionsBloc
    extends Bloc<UserPermissionsEvent, UserPermissionsState> {
  final GetPermissionsForUser getPermissionsForUser;

  UserPermissionsBloc(this.getPermissionsForUser)
    : super(UserPermissionsInitial()) {
    on<EventGetUserPermissions>((event, emit) async {
      emit(UserPermissionsLoading());
      final fialureOrPermissions = await getPermissionsForUser(
        Tokenparam(
          token: AuthTokenModel(
            token: event.token.token,
            expiry: event.token.expiry,
          ),
          param: event.userId,
        ),
      );
      fialureOrPermissions.fold(
        (f) => emit(
          UserPermissionsError(
            message:
                f.properties?.first.toString() ?? "Error loading permissions",
          ),
        ),
        (perms) {
          final permissions =
              perms.map((p) => Permission(permission: p).toId()).toList();
          emit(UserPermissionsLoaded(permissions: permissions));
        },
      );
    });
  }
}
