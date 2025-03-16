import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/widgets/confirm_dialog.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';

class TagsSection extends StatefulWidget {
  final AuthToken authToken;
  const TagsSection({super.key, required this.authToken});

  @override
  State<TagsSection> createState() => _TagsSectionState();
}

class _TagsSectionState extends State<TagsSection> {
  final _newTagController = TextEditingController();

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }

  void _removeTag(int tagId) async {
    if (tagId != 0) {
      final canRemove = await showShadDialog(
        animateIn: [FadeEffect(duration: const Duration(milliseconds: 100))],
        context: context,
        builder:
            (BuildContext context) => ConfirmDialog(
              title: "Do you want to permanently remove tag?",
              description:
                  "This step cannot be revoked.",
            ),
      );

      if (canRemove == true && mounted) {
        context.read<TagsBloc>().add(
          RemoveTagEvent(
            tokenTagId: Tokenparam(
              token: AuthTokenModel(
                token: widget.authToken.token,
                expiry: widget.authToken.expiry,
              ),
              param: tagId,
            ),
          ),
        );
      }
    }
  }

  void _addTag() async {
    if (_newTagController.text.trim().isNotEmpty) {
      final adding = await showShadDialog(
        animateIn: [FadeEffect(duration: const Duration(milliseconds: 100))],
        context: context,
        builder:
            (BuildContext context) => ConfirmDialog(
              title: "Do you want to add tag?",
              description:
                  "Do you want to add tag '${_newTagController.text.trim()}'?",
            ),
      );
      if (adding == true && mounted) {
        context.read<TagsBloc>().add(
          AddTagEvent(
            tokenTag: Tokenparam(
              token: AuthTokenModel(
                token: widget.authToken.token,
                expiry: widget.authToken.expiry,
              ),
              param: _newTagController.text.trim(),
            ),
          ),
        );

        _newTagController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Tag',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ShadInput(
                      controller: _newTagController,
                      placeholder: Text("Tag name"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ShadButton(
                    autofocus: false,
                    onPressed: _addTag,
                    leading: Icon(Icons.add),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Tags List
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: const Text(
            'Manage Tags',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<TagsBloc, TagsState>(
            builder: (context, state) {
              return switch (state) {
                TagsInitial() => const Center(
                  child: CircularProgressIndicator(),
                ),
                TagsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                TagsDeleted() => const Center(
                  child: CircularProgressIndicator(),
                ),
                TagsError() => Text(state.message),
                TagsLoaded() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.tags.length,
                  itemBuilder: (context, index) {
                    final tag = state.tags[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ShadCard(
                        height: 70,
                        trailing: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _removeTag(tag.id);
                          },
                        ),
                        title: Text(
                          tag.tag,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    );
                  },
                ),
              };
            },
          ),
        ),
      ],
    );
  }
}
