import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';
import 'package:squirrel_app/features/transactions/domain/entities/transaction.dart';
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
  late TransactionFilter filter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    filter = TransactionFilter(page: 1);
    _loadTransactions();
  }

  _loadTransactions() {
    context.read<TransactionBloc>().add(
      LoadTransaction(
        token: widget.authToken,
        itemID: widget.itemId,
        filter: filter,
      ),
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

        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            return switch (state) {
              TransactionLoaded() =>
                (state.transaction.metadata.isAnyNull())
                    ? Container()
                    : Row(
                      children: [
                        IconButton(
                          onPressed:
                              (state.transaction.metadata.currentPage! >
                                      state.transaction.metadata.firstPage!)
                                  ? () {
                                    filter.page -= 1;
                                    _loadTransactions();
                                  }
                                  : null,
                          icon: Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        Text(state.transaction.metadata.currentPage.toString()),
                        IconButton(
                          onPressed:
                              (state.transaction.metadata.currentPage! <
                                      state.transaction.metadata.lastPage!)
                                  ? () {
                                    filter.page += 1;
                                    _loadTransactions();
                                  }
                                  : null,
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ],
                    ),
              _ => Container(),
            };
          },
        ),
      ],
    );
  }

  Widget _buildTransactionList(List<Event> transactions) {
    if (transactions.isEmpty) {
      return Center(child: Text("Nothing to see here!"));
    }
    return RefreshIndicator(
      onRefresh: () {
        _loadTransactions();
        return Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: switch (transaction) {
              Addition() => AdditionCard(addition: transaction),
              Issue() => IssueCard(issue: transaction),
              Removal() => RemovalCard(removal: transaction),
            },
          );
        },
      ),
    );
  }
}
