import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_refill_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/issue_item_bloc.dart';

class IssueItemScreen extends StatefulWidget {
  final int itemId;
  final AuthToken token;
  const IssueItemScreen({super.key, required this.itemId, required this.token});

  @override
  State<IssueItemScreen> createState() => _IssueItemScreenState();
}

class _IssueItemScreenState extends State<IssueItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _issueToController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _issueToController.dispose();
    super.dispose();
  }

  _loadItem() {
    context.read<ItemByIdBloc>().add(
      LoadItemByIdEvent(token: widget.token, itemId: widget.itemId),
    );
  }

  _issueItem({required int quantity, required String issueTo}) {
    context.read<IssueItemBloc>().add(
      EventIssueItem(
        itemId: widget.itemId,
        quantity: quantity,
        issuedTo: issueTo,
        token: widget.token,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueToController,
                decoration: const InputDecoration(
                  labelText: 'Being issued to',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Must mention who the item is being issued to';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocConsumer<IssueItemBloc, IssueItemState>(
                listener: (context, state) {
                  dev.log(state.toString());
                  if (state is ItemIssued) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Item issued to ${state.issue.issuedTo} successfully',
                        ),
                      ),
                    );
                    _loadItem();
                    Navigator.pop(context);
                  } else if (state is IssueItemError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        (state is ItemRefillLoading)
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                final quantity = int.parse(
                                  _quantityController.text,
                                );
                                final issueTo = _issueToController.text;
                                _issueItem(
                                  quantity: quantity,
                                  issueTo: issueTo,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child:
                        (state is ItemRefillLoading)
                            ? const Center(child: CircularProgressIndicator())
                            : const Text(
                              'Add Stock',
                              style: TextStyle(fontSize: 16),
                            ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
