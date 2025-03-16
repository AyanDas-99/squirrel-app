import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/pages/add_stock_page.dart';
import 'package:squirrel_app/features/items/presentation/widgets/item_menu.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/widgets/item_tags_list.dart';
import 'package:squirrel_app/features/transactions/presentation/screens/issue_item_screen.dart';
import 'package:squirrel_app/features/transactions/presentation/widgets/transaction_tab.dart';

class ItemDetailScreen extends StatefulWidget {
  final int itemId;
  final AuthToken token;

  const ItemDetailScreen({
    super.key,
    required this.itemId,
    required this.token,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadTags();
    _loadItem();
  }

  _loadTags() {
    context.read<TagsForItemBloc>().add(
      LoadTagsForItemEvent(token: widget.token, itemId: widget.itemId),
    );
  }

  _loadItem() {
    context.read<ItemByIdBloc>().add(
      LoadItemByIdEvent(token: widget.token, itemId: widget.itemId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        _loadItem();
        _loadTags();
        return Future.delayed(Duration.zero);
      },
      child: BlocBuilder<ItemByIdBloc, ItemByIdState>(
        builder: (context, state) {
          return switch (state) {
            ItemByIdInitial() => Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            ItemByIdLoading() => Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            ItemByIdError() => Scaffold(
              body: Center(child: Text("Error loading item")),
            ),
            ItemByIdLoaded() => Scaffold(
              appBar: AppBar(
                title: const Text('Item Details'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [ItemMenu(token: widget.token, itemId: widget.itemId)],
              ),
              body: Stack(
                children: [
                  ListView(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Info Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  state.item.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                ShadBadge(
                                  child: Text(
                                    '${state.item.remaining}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            if (state.item.remarks.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(state.item.remarks),
                            ],
                            const SizedBox(height: 12),
                            ItemTagsList(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ShadButton(
                                    leading: Icon(Icons.add),
                                    child: Text("Add Stock"),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => AddStockPage(
                                                item: state.item,
                                                token: widget.token,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ShadButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => IssueItemScreen(
                                                itemId: widget.itemId,
                                                token: widget.token,
                                              ),
                                        ),
                                      );
                                    },
                                    leading: const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.white,
                                    ),
                                    child: const Text(
                                      'Issue Item',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Transactions Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: const Text(
                          'Transactions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Tab Bar
                      Expanded(
                        child: TransactionTab(
                          authToken: widget.token,
                          itemId: widget.itemId,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}

class ItemDetail {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final List<String> tags;
  final String description;
  final List<Transaction> transactions;

  ItemDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.tags,
    required this.description,
    required this.transactions,
  });
}

enum TransactionType { addition, issue, removal }

class Transaction {
  final int id;
  final TransactionType type;
  final int quantity;
  final String date;
  final String user;
  final String? department;
  final String? reason;

  Transaction({
    required this.id,
    required this.type,
    required this.quantity,
    required this.date,
    required this.user,
    this.department,
    this.reason,
  });
}
