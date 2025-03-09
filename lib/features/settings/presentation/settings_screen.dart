import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';

class SettingsScreen extends StatefulWidget {
  final AuthToken authToken;
  const SettingsScreen({super.key, required this.authToken});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _newTagController = TextEditingController();
  int _selectedSettingIndex = 0;

  final List<String> _settingCategories = [
    'Tags',
    'Categories',
    'Notifications',
    'Appearance',
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UserBloc>().add(LogoutEvent());
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings Navigation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(
                _settingCategories.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_settingCategories[index]),
                    selected: _selectedSettingIndex == index,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedSettingIndex = index;
                        });
                      }
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color:
                          _selectedSettingIndex == index
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Add Tag Section
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
      ),
    );
  }
}

class TagModel {
  final int id;
  final String name;
  final int count;

  TagModel({required this.id, required this.name, required this.count});
}
