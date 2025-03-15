import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/tags/domain/usecases/add_tag_for_item.dart';
import 'package:squirrel_app/features/tags/domain/usecases/remove_tag_for_item.dart';

part 'remove_tag_for_item_event.dart';
part 'remove_tag_for_item_state.dart';

class RemoveTagForItemBloc
    extends Bloc<RemoveTagForItemDartEvent, RemoveTagForItemDartState> {
  final RemoveTagForItem removeTagForItem;

  RemoveTagForItemBloc({required this.removeTagForItem})
    : super(RemoveTagForItemDartInitial()) {
    on<EventRemoveTag>((event, emit) async {
      emit(RemoveTagForItemDartLoading());
      final failureOrRemoved = await removeTagForItem(
        Tokenparam(
          token: AuthTokenModel(
            token: event.token.token,
            expiry: event.token.expiry,
          ),
          param: ItemTagParam(itemId: event.itemId, tagId: event.tagId),
        ),
      );

      failureOrRemoved.fold(
        (f) => emit(
          RemoveTagForItemDartError(
            message:
                f.properties?.first.toString() ??
                "Error removing tag from item",
          ),
        ),
        (removed) {
          if (removed) {
            emit(TagRemoved());
          } else {
            emit(
              RemoveTagForItemDartError(
                message: "Error removing tag from item",
              ),
            );
          }
        },
      );
    });
  }
}
