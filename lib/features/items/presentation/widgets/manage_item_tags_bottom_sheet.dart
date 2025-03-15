import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/add_tag_for_item_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/remove_tag_for_item_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';

class ManageItemTagsBottomSheet extends StatefulWidget {
  final AuthToken token;
  final int itemId;
  const ManageItemTagsBottomSheet({
    super.key,
    required this.token,
    required this.itemId,
  });

  @override
  State<ManageItemTagsBottomSheet> createState() =>
      _ManageItemTagsBottomSheetState();
}

class _ManageItemTagsBottomSheetState extends State<ManageItemTagsBottomSheet> {
  _addTag(int tagId) {
    context.read<AddTagForItemBloc>().add(
      EventAddTagForItem(
        token: widget.token,
        itemId: widget.itemId,
        tagId: tagId,
      ),
    );
  }

  _removeTag(int tagId) {
    context.read<RemoveTagForItemBloc>().add(
      EventRemoveTag(token: widget.token, itemId: widget.itemId, tagId: tagId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTagForItemBloc, AddTagForItemState>(
      listener: (context, state) {
        if (state is TagAdded) {
          context.read<TagsForItemBloc>().add(
            LoadTagsForItemEvent(token: widget.token, itemId: widget.itemId),
          );
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddTagForItemBloc, AddTagForItemState>(
            listener: (context, state) {
              if (state is TagAdded) {
                context.read<TagsForItemBloc>().add(
                  LoadTagsForItemEvent(
                    token: widget.token,
                    itemId: widget.itemId,
                  ),
                );
              }
            },
          ),

          BlocListener<RemoveTagForItemBloc, RemoveTagForItemDartState>(
            listener: (context, state) {
              if (state is TagRemoved) {
                context.read<TagsForItemBloc>().add(
                  LoadTagsForItemEvent(
                    token: widget.token,
                    itemId: widget.itemId,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<TagsBloc, TagsState>(
          builder: (context, allTagState) {
            return switch (allTagState) {
              TagsInitial() => throw UnimplementedError(),
              TagsLoading() => throw UnimplementedError(),
              TagsDeleted() => throw UnimplementedError(),
              TagsError() => throw UnimplementedError(),
              TagsLoaded() => BlocBuilder<TagsForItemBloc, TagsForItemState>(
                builder: (context, state) {
                  return switch (state) {
                    TagsForItemError() => Center(child: Text(state.message)),
                    TagsForItemLoaded() => Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Manage Tags",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Existing Tags
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Existing Tags",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (state.tags.isEmpty)
                            Center(child: Text("No tags here!")),
                          if (state.tags.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              children:
                                  state.tags.map((tag) {
                                    return Chip(
                                      label: Text(tag.tag),
                                      deleteIcon: Icon(Icons.close, size: 18),
                                      onDeleted: () {
                                        int id =
                                            allTagState.tags
                                                .firstWhere(
                                                  (t) => t.tag == tag.tag,
                                                )
                                                .id;
                                        _removeTag(id);
                                      },
                                    );
                                  }).toList(),
                            ),

                          SizedBox(height: 10),

                          // Available Tags
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Available Tags",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          const SizedBox(height: 10),
                          if(allTagState.tags.isEmpty)
                          Center(child: Text("No tags present!")),
                          if(allTagState.tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children:
                                allTagState.tags
                                    .where(
                                      (tag) =>
                                          !state.tags
                                              .map((t) => t.tag)
                                              .contains(tag.tag),
                                    )
                                    .map((tag) {
                                      return ActionChip(
                                        label: Text(tag.tag),
                                        onPressed: () {
                                          _addTag(tag.id);
                                        },
                                      );
                                    })
                                    .toList(),
                          ),

                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    _ => Center(child: CircularProgressIndicator()),
                  };
                },
              ),
            };
          },
        ),
      ),
    );
  }
}
