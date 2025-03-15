import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/usecases/add_removals.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

part 'add_removal_event.dart';
part 'add_removal_state.dart';

class AddRemovalBloc extends Bloc<AddRemovalEvent, AddRemovalState> {
  final AddRemoval addRemoval;

  AddRemovalBloc({required this.addRemoval}) : super(AddRemovalInitial()) {
    on<EventAddRemoval>(_addRemoval);
  }

  _addRemoval(EventAddRemoval event, Emitter<AddRemovalState> emit) async {
    emit(AddRemovalLoading());
    final failureOrRemoval = await addRemoval(
      Tokenparam(
        token: AuthTokenModel(
          token: event.token.token,
          expiry: event.token.expiry,
        ),
        param: RemovalParam(
          itemId: event.itemId,
          quantity: event.quantity,
          remarks: event.remarks,
        ),
      ),
    );

    failureOrRemoval.fold(
      (failure) {
        emit(
          AddRemovalError(
            message:
                failure.properties?.first.toString() ?? 'Error refilling stock',
          ),
        );

        emit(AddRemovalInitial());
      },
      (removal) {
        emit(RemovalAdded(removal: removal));
        emit(AddRemovalInitial());
      },
    );
  }
}
