import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_refill_bloc.dart';
import 'package:squirrel_app/features/tags/presentation/bloc/tags_for_item_bloc.dart';

class AddStockPage extends StatefulWidget {
  final Item item;
  final AuthToken token;
  const AddStockPage({super.key, required this.item, required this.token});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  _loadTags() {
    context.read<TagsForItemBloc>().add(
      LoadTagsForItemEvent(token: widget.token, itemId: widget.item.id),
    );
  }

  _loadItem() {
    context.read<ItemByIdBloc>().add(
      LoadItemByIdEvent(token: widget.token, itemId: widget.item.id),
    );
  }

  _addstock({required int quantity, required String remarks}) {
    context.read<ItemRefillBloc>().add(
      EventRefillItem(
        itemId: widget.item.id,
        quantity: quantity,
        remarks: remarks,
        token: widget.token,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Stock')),
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
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              BlocConsumer<ItemRefillBloc, ItemRefillState>(
                listener: (context, state) {
                  if (state is ItemRefilled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Stock added successfully')),
                    );
                    _loadTags();
                    _loadItem();
                    Navigator.pop(context);
                  } else if (state is ItemRefillError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
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
                                final remarks = _remarksController.text;
                                _addstock(quantity: quantity, remarks: remarks);
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
