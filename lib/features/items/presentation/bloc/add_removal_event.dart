part of 'add_removal_bloc.dart';

sealed class AddRemovalEvent extends Equatable {
  const AddRemovalEvent();

  @override
  List<Object> get props => [];
}

class EventAddRemoval extends AddRemovalEvent {
  final int itemId;
  final int quantity;
  final String remarks;
  final AuthToken token;

  const EventAddRemoval({
    required this.itemId,
    required this.quantity,
    required this.remarks,
    required this.token,
  });
}
