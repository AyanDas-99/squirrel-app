import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';
import 'package:squirrel_app/features/tags/domain/usecases/add_tag.dart';
import 'package:squirrel_app/features/tags/domain/usecases/get_all_tags.dart';
import 'package:squirrel_app/features/tags/domain/usecases/remove_tag.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final GetAllTags getAllTags;
  final AddTag addTag;
  final RemoveTag removeTag;

  TagsBloc({required this.getAllTags, required this.addTag, required this.removeTag})
    : super(TagsInitial()) {
    on<AddTagEvent>(_addTag);
    on<RemoveTagEvent>(_removeTag);
    on<LoadTagsEvent>(_loadTags);
  }

  void _loadTags(LoadTagsEvent event, Emitter<TagsState> emit) async {
    emit(TagsLoading());
    final failureOrTags = await getAllTags(event.authToken);

    if (failureOrTags.isLeft()) {
      final err = failureOrTags.fold((l) => l, (r) => null);
      emit(TagsError(message: err!.properties?.first.toString() ?? "Error"));
    } else {
      final tags = failureOrTags.fold((l) => null, (r) => r);
      emit(TagsLoaded(tags: tags!));
    }
  }

  void _removeTag(RemoveTagEvent event, Emitter<TagsState> emit) async {
    emit(TagsLoading());
    final failureOrBool = await removeTag(
      Tokenparam(token: event.tokenTagId.token, param: event.tokenTagId.param),
    );

    if (failureOrBool.isLeft()) {
      final err = failureOrBool.fold((l) => l, (r) => null);
      emit(TagsError(message: err!.properties?.first.toString() ?? "Error"));
    } else {
      final isRemoved = failureOrBool.fold((l) => null, (r) => r);
      if (isRemoved == true) {
        emit(TagsDeleted());
      }
    }
    add(LoadTagsEvent(authToken: event.tokenTagId.token));
  }

  void _addTag(AddTagEvent event, Emitter<TagsState> emit) async {
    emit(TagsLoading());
    final failureOrTag = await addTag(
      Tokenparam(token: event.tokenTag.token, param: event.tokenTag.param),
    );

    if (failureOrTag.isLeft()) {
      final err = failureOrTag.fold((l) => l, (r) => null);
      emit(TagsError(message: err!.properties?.first.toString() ?? "Error"));
    } else {
      final tag = failureOrTag.fold((l) => null, (r) => r);
      emit(TagsLoaded(tags: [tag!]));
    }

    add(LoadTagsEvent(authToken: event.tokenTag.token));
  }
}
