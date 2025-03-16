import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';

class ItemTagsList extends StatelessWidget {
  const ItemTagsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagsForItemBloc, TagsForItemState>(
      builder: (context, state) {
        return switch (state) {
          TagsForItemInitial() => Center(child: CircularProgressIndicator()),
          TagsForItemLoading() => Center(child: CircularProgressIndicator()),
          TagsForItemError() => Text(state.message),
          TagsForItemLoaded() =>
            (state.tags.isEmpty)
                ? Container()
                : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      state.tags.map((tag) {
                        return ShadBadge(
                          backgroundColor: Colors.blueGrey.shade100,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Text(tag.tag),
                        );
                      }).toList(),
                ),
        };
      },
    );
  }
}
