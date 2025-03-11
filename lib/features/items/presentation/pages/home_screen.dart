import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
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
  int _currentIndex = 0;

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
          title: IsAdminText(),
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
            IconButton(
              icon: const Icon(Icons.people_outline),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const UsersScreen()),
                // );
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
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        searchName = !searchName;
                      });
                    },
                    child: Text(searchName ? 'Name' : 'Remarks'),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: searchQuery,
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
                      decoration: InputDecoration(
                        hintText: 'Search items...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
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
                              label: Text(tag.tag),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  filter.tagId = isSelected ? null : tag.id;
                                });
                                updateList();
                              },
                              backgroundColor: Colors.grey[100],
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
                    ItemsInitial() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    ItemsLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
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
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: state.itemsAndMeta.items.length,
                              itemBuilder: (context, index) {
                                final item = state.itemsAndMeta.items[index];
                                return ItemCard(
                                  item: item,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ItemDetailScreen(
                                              itemId: item.id,
                                              token: widget.authToken,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
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
                  };
                },
                listener: (BuildContext context, ItemState state) {
                  dev.log(state.toString());
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Users',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddItemScreen(token: widget.authToken),
              ),
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

  const ItemCard({Key? key, required this.item, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.remarks,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Qty: ${item.remaining}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
