import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/users/domain/usecases/update_permission.dart';

part 'update_permission_event.dart';
part 'update_permission_state.dart';

class UpdatePermissionBloc
    extends Bloc<UpdatePermissionEvent, UpdatePermissionState> {
  final UpdatePermission updatePermission;

  UpdatePermissionBloc(this.updatePermission)
    : super(UpdatePermissionInitial()) {
    on<EventUpdatePermission>((event, emit) async {
      emit(UpdatePermissionLoading());
      final failureOrUpdated = await updatePermission(
        Tokenparam(
          token: AuthTokenModel(
            token: event.authToken.token,
            expiry: event.authToken.expiry,
          ),
          param: event.updatePermissionParam,
        ),
      );
      failureOrUpdated.fold(
        (f) => emit(
          UpdatePermissionError(
            message:
                f.properties?.first.toString() ?? "Error updating permission",
          ),
        ),
        (updated) {
          if (updated) {
            emit(PermissionUpdated());
          } else {
            emit(UpdatePermissionError(message: "Error updating permission"));
          }
        },
      );
    });
  }
}
