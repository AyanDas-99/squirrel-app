import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/usecases/remove_item.dart';

part 'remove_item_event.dart';
part 'remove_item_state.dart';

class RemoveItemBloc extends Bloc<RemoveItemEvent, RemoveItemState> {
  final RemoveItem removeItem;
  RemoveItemBloc({required this.removeItem}) : super(RemoveItemInitial()) {
    on<EventRemoveItem>(_removeItem);
  }

  void _removeItem(EventRemoveItem event, Emitter<RemoveItemState> emit) async {
    emit(RemoveItemLoading());
    final failureOrbool = await removeItem(
      Tokenparam(
        token: AuthTokenModel(
          token: event.token.token,
          expiry: event.token.expiry,
        ),
        param: event.itemId,
      ),
    );
    if (failureOrbool.isLeft()) {
      final failure = failureOrbool.fold((l) => l, (r) => null);
      emit(
        RemoveItemError(
          message:
              failure?.properties?.first.toString() ?? 'Error removing item',
        ),
      );
    } else {
      final isRemoved = failureOrbool.fold((l) => null, (r) => r)!;
      if (isRemoved) {
        emit(ItemRemoved());
      } else {
        emit(RemoveItemError(message: "Error removing item"));
      }
    }
  }
}
