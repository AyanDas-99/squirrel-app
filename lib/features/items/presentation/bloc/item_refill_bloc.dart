import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/domain/usecases/refill_item.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

part 'item_refill_event.dart';
part 'item_refill_state.dart';

class ItemRefillBloc extends Bloc<ItemRefillEvent, ItemRefillState> {
  final RefillItem refillItem;

  ItemRefillBloc({required this.refillItem}) : super(ItemRefillInitial()) {
    on<EventRefillItem>(_refilItem);
  }

  _refilItem(EventRefillItem event, Emitter<ItemRefillState> emit) async {
    emit(ItemRefillLoading());
    final failureOrAddition = await refillItem(
      Tokenparam(
        token: AuthTokenModel(
          token: event.token.token,
          expiry: event.token.expiry,
        ),
        param: ItemRefillParams(
          itemId: event.itemId,
          quantity: event.quantity,
          remarks: event.remarks,
        ),
      ),
    );

    failureOrAddition.fold(
      (failure) {
        emit(
          ItemRefillError(
            message:
                failure.properties?.first.toString() ?? 'Error refilling stock',
          ),
        );

        emit(ItemRefillInitial());
      },
      (addition) {
        emit(ItemRefilled(addition: addition));
        emit(ItemRefillInitial());
      },
    );
  }
}
