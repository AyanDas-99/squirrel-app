import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';
import 'package:squirrel_app/features/tags/domain/usecases/get_all_tags_for_item.dart';

part 'tags_for_item_event.dart';
part 'tags_for_item_state.dart';

class TagsForItemBloc extends Bloc<TagsForItemEvent, TagsForItemState> {
  final GetAllTagsForItem getAllTagsForItem;
  TagsForItemBloc({required this.getAllTagsForItem})
    : super(TagsForItemInitial()) {
    on<LoadTagsForItemEvent>(_loadTagsForItem);
  }

  _loadTagsForItem(
    LoadTagsForItemEvent event,
    Emitter<TagsForItemState> emit,
  ) async {
    emit(TagsForItemLoading());
    final failureOrTags = await getAllTagsForItem(
      Tokenparam(
        token: AuthTokenModel(
          token: event.token.token,
          expiry: event.token.expiry,
        ),
        param: event.itemId,
      ),
    );

    if (failureOrTags.isLeft()) {
      final failure = failureOrTags.fold((l) => l, (r) => null)!;
      emit(TagsForItemError(message: failure.properties?.first.toString() ?? "Error loading tags"));
    } else {
      final tags = failureOrTags.fold((l) => null, (r) => r)!;
      emit(TagsForItemLoaded(tags: tags));
    }
  }
}
