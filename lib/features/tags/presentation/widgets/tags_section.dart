import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
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

  void _removeTag(int tagId) {
    if (tagId != 0) {
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

  void _addTag() {
    if (_newTagController.text.trim().isNotEmpty) {
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
                    child: TextField(
                      controller: _newTagController,
                      decoration: InputDecoration(
                        hintText: 'Enter tag name...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addTag,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tag.tag,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red[400],
                              onPressed: () {
                                _removeTag(tag.id);
                              },
                            ),
                          ],
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
