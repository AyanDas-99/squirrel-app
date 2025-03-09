import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/domain/usecases/get_all_items.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetAllItems getAllItems;
  ItemBloc({required this.getAllItems}) : super(ItemsInitial()) {
    on<GetItems>(_getItems);
  }

  void _getItems(GetItems event, Emitter<ItemState> emit) async {
    emit(ItemsLoading());
    final failureOrItems = await getAllItems(event.tokenparam);
    if (failureOrItems.isLeft()) {
      final err = failureOrItems.fold((l) => l, (r) => null);
      emit(ItemsError(message: err!.properties?.first.toString() ?? "Error"));
    } else {
      final itemsAndMeta = failureOrItems.fold((l) => null, (r) => r);
      emit(ItemsLoaded(itemsAndMeta: itemsAndMeta!));
    }
  }
}
