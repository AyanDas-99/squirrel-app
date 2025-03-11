import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/usecases/get_item_by_id.dart';

part 'item_by_id_event.dart';
part 'item_by_id_state.dart';

class ItemByIdBloc extends Bloc<ItemByIdEvent, ItemByIdState> {
  final GetItemById getItemById;
  ItemByIdBloc({required this.getItemById}) : super(ItemByIdInitial()) {
    on<LoadItemByIdEvent>((event, emit) async {
      emit(ItemByIdLoading());
      final failureOrItem = await getItemById(
        Tokenparam(
          token: AuthTokenModel(
            token: event.token.token,
            expiry: event.token.expiry,
          ),
          param: event.itemId,
        ),
      );
      failureOrItem.fold(
        (failure) => emit(
          ItemByIdError(
            message:
                failure.properties?.first.toString() ?? 'Error loading item',
          ),
        ),
        (item) => emit(ItemByIdLoaded(item: item)),
      );
    });
  }
}
