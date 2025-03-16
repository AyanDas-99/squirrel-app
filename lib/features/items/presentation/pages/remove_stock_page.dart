import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/utils/show_toaster.dart';
import 'package:squirrel_app/core/widgets/confirm_dialog.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_removal_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_refill_bloc.dart';

class RemoveStockPage extends StatefulWidget {
  final Item item;
  final AuthToken token;
  const RemoveStockPage({super.key, required this.item, required this.token});

  @override
  State<RemoveStockPage> createState() => _RemoveStockPageState();
}

class _RemoveStockPageState extends State<RemoveStockPage> {
  final _formKey = GlobalKey<ShadFormState>();

  _loadItem() {
    context.read<ItemByIdBloc>().add(
      LoadItemByIdEvent(token: widget.token, itemId: widget.item.id),
    );
  }

  _removeStock({required int quantity, required String remarks}) async {
    final canAdd = await showShadDialog(
      context: context,
      builder:
          (context) => ConfirmDialog(
            title: "Do you want to remove stock?",
            description:
                "You are removing $quantity ${widget.item.name} due to '$remarks",
          ),
    );

    if (canAdd == true && mounted) {
      context.read<AddRemovalBloc>().add(
        EventAddRemoval(
          itemId: widget.item.id,
          quantity: quantity,
          remarks: remarks,
          token: widget.token,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: Text("Remove stock"),
      description: Text(widget.item.name),
      child: ShadForm(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShadInputFormField(
              id: "quantity",
              placeholder: Text("quantity"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              placeholder: Text("Reason"),
              id: "remarks",
              maxLines: 3,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Must mention the reason to remove stock';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            BlocConsumer<AddRemovalBloc, AddRemovalState>(
              listener: (context, state) {
                if (state is RemovalAdded) {
                  showToast(
                    context: context,
                    desc: 'stock removed successfully',
                  );
                  _loadItem();
                  Navigator.pop(context);
                } else if (state is AddRemovalError) {
                  showToast(
                    context: context,
                    desc: state.message,
                    isDestructive: true,
                  );
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return ShadButton(
                  onPressed:
                      (state is ItemRefillLoading)
                          ? null
                          : () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              final quantity = int.parse(
                                _formKey.currentState!.value['quantity'],
                              );
                              final remark =
                                  _formKey.currentState!.value['remarks'];
                              _removeStock(quantity: quantity, remarks: remark);
                            }
                          },
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
    );
  }
}
