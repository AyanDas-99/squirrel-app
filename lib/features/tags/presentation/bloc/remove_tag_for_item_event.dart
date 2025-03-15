part of 'remove_tag_for_item_bloc.dart';

sealed class RemoveTagForItemDartEvent extends Equatable {
  const RemoveTagForItemDartEvent();

  @override
  List<Object> get props => [];
}

class EventRemoveTag extends RemoveTagForItemDartEvent {
  final AuthToken token;
  final int itemId;
  final int tagId;

  const EventRemoveTag({
    required this.token,
    required this.itemId,
    required this.tagId,
  });

  @override
  List<Object> get props => [token, itemId, tagId];
}
