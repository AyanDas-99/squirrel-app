part of 'remove_item_bloc.dart';

sealed class RemoveItemEvent extends Equatable {
  const RemoveItemEvent();

  @override
  List<Object> get props => [];
}

class EventRemoveItem extends RemoveItemEvent {
  final AuthToken token;
  final int itemId;

  const EventRemoveItem({required this.token, required this.itemId});
}
