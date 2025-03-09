import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/widgets/addition_card.dart';
import 'package:squirrel_app/features/transactions/presentation/widgets/issue_card.dart';
import 'package:squirrel_app/features/transactions/presentation/widgets/removal_card.dart';

class TransactionTab extends StatefulWidget {
  final AuthToken authToken;
  final int itemId;
  const TransactionTab({
    super.key,
    required this.authToken,
    required this.itemId,
  });

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<TransactionBloc>().add(
      LoadTransaction(token: widget.authToken, itemID: widget.itemId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Additions'),
            Tab(text: 'Issues'),
            Tab(text: 'Removals'),
          ],
        ),

        // Transaction Lists
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            return switch (state) {
              TransactionInitial() => Center(
                child: CircularProgressIndicator(),
              ),
              TransactionLoading() => Center(
                child: CircularProgressIndicator(),
              ),
              TransactionLoaded() => Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTransactionList(state.transaction.getSortedList()),
                    _buildTransactionList(state.transaction.additions),
                    _buildTransactionList(state.transaction.issues),
                    _buildTransactionList(state.transaction.removals),
                  ],
                ),
              ),
              TransactionError() => Text(state.failure.properties.toString()),
            };
          },
        ),
      ],
    );
  }

  Widget _buildTransactionList(List<Event> transactions) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return switch (transaction) {
          Addition() => AdditionCard(addition: transaction),
          Issue() => IssueCard(issue: transaction),
          Removal() => RemovalCard(removal: transaction),
        };
      },
    );
  }
}
