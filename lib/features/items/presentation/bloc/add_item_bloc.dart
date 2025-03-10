import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/domain/usecases/add_item.dart';

part 'add_item_event.dart';
part 'add_item_state.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  final AddItem addItem;

  AddItemBloc({required this.addItem}) : super(AddItemInitial()) {
    on<EventAddItem>(_addItem);
  }

  void _addItem(EventAddItem event, Emitter<AddItemState> emit) async {
    emit(AddItemLoading());
    final failureOrItem = await addItem(
      Tokenparam(
        token: AuthTokenModel(
          token: event.token.token,
          expiry: event.token.expiry,
        ),
        param: ItemParams(
          name: event.name,
          quantity: event.quantity,
          remarks: event.remarks,
        ),
      ),
    );
    if (failureOrItem.isLeft()) {
      final failure = failureOrItem.fold((l) => l, (r) => null);
      emit(
        AddItemError(
          error: failure?.properties?.first.toString() ?? "Error adding item",
        ),
      );
    } else {
      final item = failureOrItem.fold((l) => null, (r) => r)!;
      emit(AddItemLoaded(item: item));
      emit(AddItemInitial());
    }
  }
}
