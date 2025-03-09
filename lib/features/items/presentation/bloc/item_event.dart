part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class GetItems extends ItemEvent {
  final Tokenparam<ItemsFilter> tokenparam;

  const GetItems({required this.tokenparam});
}
