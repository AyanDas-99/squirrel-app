// item_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/widgets/transaction_tab.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  final AuthToken token;

  const ItemDetailScreen({super.key, required this.item, required this.token});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TagsForItemBloc>().add(
      LoadTagsForItemEvent(token: widget.token, itemId: widget.item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Info Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      widget.item.remarks,
                      style: TextStyle(color: Colors.grey[600]),
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
                      'Current Stock: ${widget.item.remaining}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BlocBuilder<TagsForItemBloc, TagsForItemState>(
                  builder: (context, state) {
                    return switch (state) {
                      TagsForItemInitial() => Center(
                        child: CircularProgressIndicator(),
                      ),
                      TagsForItemLoading() => Center(
                        child: CircularProgressIndicator(),
                      ),
                      TagsForItemError() => Text(state.message),
                      TagsForItemLoaded() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            state.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(tag.tag),
                              );
                            }).toList(),
                      ),
                    };
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  widget.item.remarks,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add stock
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Stock'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Issue item
                        },
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('Issue Item'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),

          // Tab Bar
          Expanded(
            child: TransactionTab(
              authToken: widget.token,
              itemId: widget.item.id,
            ),
          ),
        ],
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
