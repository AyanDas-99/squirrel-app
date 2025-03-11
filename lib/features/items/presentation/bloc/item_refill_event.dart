part of 'item_refill_bloc.dart';

sealed class ItemRefillEvent extends Equatable {
  const ItemRefillEvent();

  @override
  List<Object> get props => [];
}

class EventRefillItem extends ItemRefillEvent {
  final int itemId;
  final int quantity;
  final String remarks;
  final AuthToken token;

  const EventRefillItem({
    required this.itemId,
    required this.quantity,
    required this.remarks,
    required this.token,
  });
}
