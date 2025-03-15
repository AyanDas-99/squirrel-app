import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/tags/domain/usecases/add_tag_for_item.dart';

part 'add_tag_for_item_event.dart';
part 'add_tag_for_item_state.dart';

class AddTagForItemBloc extends Bloc<AddTagForItemEvent, AddTagForItemState> {
  final AddTagForItem addTagForItem;
  AddTagForItemBloc({required this.addTagForItem})
    : super(AddTagForItemInitial()) {
    on<EventAddTagForItem>((event, emit) async {
      emit(AddTagForItemLoading());
      final failureOrAdded = await addTagForItem(
        Tokenparam(
          token: AuthTokenModel(
            token: event.token.token,
            expiry: event.token.expiry,
          ),
          param: ItemTagParam(itemId: event.itemId, tagId: event.tagId),
        ),
      );
      failureOrAdded.fold(
        (f) => emit(
          AddTagForItemError(
            message:
                f.properties?.first.toString() ?? "Error adding tag for item",
          ),
        ),
        (added) {
          if (added) {
            emit(TagAdded());
          } else {
            emit(AddTagForItemError(message: "Error adding tag for item"));
          }
        },
      );
    });
  }
}
