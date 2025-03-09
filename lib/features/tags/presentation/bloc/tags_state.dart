part of 'tags_bloc.dart';

sealed class TagsState extends Equatable {
  const TagsState();

  @override
  List<Object> get props => [];
}

final class TagsInitial extends TagsState {}

final class TagsLoading extends TagsState {}
final class TagsDeleted extends TagsState {}

final class TagsError extends TagsState {
  final String message;

  const TagsError({required this.message});
}

final class TagsLoaded extends TagsState {
  final List<Tag> tags;

  const TagsLoaded({required this.tags});
}
