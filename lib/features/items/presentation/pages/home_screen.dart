import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/widgets/loading_image.dart';
import 'package:squirrel_app/core/widgets/logo_image.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/pages/add_item_screen.dart';
import 'package:squirrel_app/features/items/presentation/widgets/is_admin_title.dart';
import 'package:squirrel_app/features/settings/presentation/settings_screen.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';
import 'item_detail_screen.dart';
import 'dart:developer' as dev;

class HomeScreen extends StatefulWidget {
  final AuthToken authToken;
  const HomeScreen({super.key, required this.authToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchQuery = TextEditingController();

  bool searchName = true;

  late ItemsFilter filter;

  @override
  void initState() {
    super.initState();
    updateTagsList();
    filter = ItemsFilter(page: 1);
    updateList();
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }

  void updateTagsList() {
    context.read<TagsBloc>().add(LoadTagsEvent(authToken: widget.authToken));
  }

  void updateList() {
    context.read<ItemBloc>().add(
      GetItems(
        tokenparam: Tokenparam(
          token: AuthTokenModel(
            token: widget.authToken.token,
            expiry: widget.authToken.expiry,
          ),
          param: filter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        updateList();
        updateTagsList();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              LogoImage(width: 35),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Squirrel", style: const TextStyle(fontSize: 20)),
                  IsAdminText(),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            SettingsScreen(authToken: widget.authToken),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
              child: Row(
                children: [
                  ShadButton.outline(
                    onPressed: () {
                      setState(() {
                        searchName = !searchName;
                      });
                    },
                    child: Text(searchName ? 'Name' : 'Remarks'),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: ShadInput(
                      controller: searchQuery,
                      placeholder: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          Text(
                            "Search items with ${(searchName) ? "name" : "remarks"}",
                          ),
                        ],
                      ),
                      onChanged: (value) {
                        searchQuery.text = searchQuery.text.trim();
                        if (searchName) {
                          filter.name = searchQuery.text;
                        } else {
                          filter.remarks = searchQuery.text;
                        }
                        dev.log(filter.toQuery());
                        updateList();
                      },
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<TagsBloc, TagsState>(
              builder: (context, state) {
                return switch (state) {
                  TagsInitial() => Container(),
                  TagsLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  TagsError() => Text(state.message),
                  TagsLoaded() => Wrap(
                    children:
                        state.tags.map((tag) {
                          final isSelected = tag.id == filter.tagId;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              showCheckmark: false,
                              label: Text(tag.tag),
                              shadowColor: Colors.white,
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  filter.tagId = isSelected ? null : tag.id;
                                });
                                updateList();
                              },
                              backgroundColor: Colors.white,
                              selectedColor: Colors.blue,
                              labelStyle: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  TagsDeleted() => Container(),
                };
              },
            ),

            Expanded(
              child: BlocConsumer<ItemBloc, ItemState>(
                builder: (context, state) {
                  return switch (state) {
                    ItemsError() => Center(child: Text(state.message)),
                    ItemsLoaded() => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items (${state.itemsAndMeta.items.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.itemsAndMeta.items.isEmpty)
                          Center(child: Text("Nothing to see here!")),
                        if (state.itemsAndMeta.items.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Wrap(
                                children:
                                    state.itemsAndMeta.items
                                        .map(
                                          (item) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ItemCard(
                                              item: item,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ItemDetailScreen(
                                                          itemId: item.id,
                                                          token:
                                                              widget.authToken,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                        if (!state.itemsAndMeta.meta.isAnyNull())
                          Row(
                            children: [
                              IconButton(
                                onPressed:
                                    (state.itemsAndMeta.meta.currentPage! >
                                            state.itemsAndMeta.meta.firstPage!)
                                        ? () {
                                          filter.page -= 1;
                                          updateList();
                                        }
                                        : null,
                                icon: Icon(Icons.arrow_back_ios_new_rounded),
                              ),
                              Text(
                                state.itemsAndMeta.meta.currentPage.toString(),
                              ),
                              IconButton(
                                onPressed:
                                    (state.itemsAndMeta.meta.currentPage! <
                                            state.itemsAndMeta.meta.lastPage!)
                                        ? () {
                                          filter.page += 1;
                                          updateList();
                                        }
                                        : null,
                                icon: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ],
                          ),
                      ],
                    ),
                    _ => Center(child: LoadingImage()),
                  };
                },
                listener: (BuildContext context, ItemState state) {
                  dev.log(state.toString());
                },
              ),
            ),
          ],
        ),
        floatingActionButton: ShadButton.outline(
          backgroundColor: Colors.white,
          shadows: [
            BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(1, 1)),
          ],
          onPressed: () {
            showShadDialog(
              context: context,
              builder: (context) => AddItemScreen(token: widget.authToken),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const ItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ShadCard(
        rowMainAxisSize: MainAxisSize.min,
        columnMainAxisSize: MainAxisSize.min,
        backgroundColor: Colors.grey.shade100,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            ShadBadge(
              child: Text(
                '${item.remaining}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        footer: Text(item.remarks, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
