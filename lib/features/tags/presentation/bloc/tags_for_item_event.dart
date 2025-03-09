part of 'tags_for_item_bloc.dart';

sealed class TagsForItemEvent extends Equatable {
  const TagsForItemEvent();

  @override
  List<Object> get props => [];
}

class LoadTagsForItemEvent extends TagsForItemEvent {
  final AuthToken token;
  final int itemId;

  const LoadTagsForItemEvent({required this.token, required this.itemId});
}
