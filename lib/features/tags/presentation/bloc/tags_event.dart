part of 'tags_bloc.dart';

sealed class TagsEvent extends Equatable {
  const TagsEvent();

  @override
  List<Object> get props => [];
}

class LoadTagsEvent extends TagsEvent {
  final AuthToken authToken;

  const LoadTagsEvent({required this.authToken});
}

class AddTagEvent extends TagsEvent {
  final Tokenparam<String> tokenTag;

  const AddTagEvent({required this.tokenTag});
}

class RemoveTagEvent extends TagsEvent {
  final Tokenparam<int> tokenTagId;

  const RemoveTagEvent({required this.tokenTagId});
}
