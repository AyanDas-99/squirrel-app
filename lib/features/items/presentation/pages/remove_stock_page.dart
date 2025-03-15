import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_removal_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_refill_bloc.dart';

class RemoveStockPage extends StatefulWidget {
  final int itemId;
  final AuthToken token;
  const RemoveStockPage({super.key, required this.itemId, required this.token});

  @override
  State<RemoveStockPage> createState() => _RemoveStockPageState();
}

class _RemoveStockPageState extends State<RemoveStockPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  _loadItem() {
    context.read<ItemByIdBloc>().add(
      LoadItemByIdEvent(token: widget.token, itemId: widget.itemId),
    );
  }

  _removeStock({required int quantity, required String remarks}) {
    context.read<AddRemovalBloc>().add(
      EventAddRemoval(
        itemId: widget.itemId,
        quantity: quantity,
        remarks: remarks,
        token: widget.token,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remove Stock')),
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
                  } else if(int.parse(value) < 1) {
                    return 'Quantity should be more than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter remarks';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocConsumer<AddRemovalBloc, AddRemovalState>(
                listener: (context, state) {
                  if (state is RemovalAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Stock removed!')),
                    );
                    _loadItem();
                    Navigator.pop(context);
                  } else if (state is AddRemovalError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        (state is AddRemovalLoading)
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                final quantity = int.parse(
                                  _quantityController.text,
                                );
                                final remarks = _remarksController.text;
                                _removeStock(quantity: quantity, remarks: remarks);
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child:
                        (state is ItemRefillLoading)
                            ? const Center(child: CircularProgressIndicator())
                            : const Text(
                              'Remove Stock',
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
