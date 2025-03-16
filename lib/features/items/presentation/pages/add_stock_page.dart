import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/utils/show_toaster.dart';
import 'package:squirrel_app/core/widgets/confirm_dialog.dart';
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
  final _formKey = GlobalKey<ShadFormState>();

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

  _addstock({required int quantity, required String remarks}) async {
    final canAdd = await showShadDialog(
      context: context,
      builder:
          (context) => ConfirmDialog(
            title: "Do you want to add stock?",
            description:
                "You are adding $quantity items to ${widget.item.name}",
          ),
    );

    if (canAdd == true && mounted) {
      context.read<ItemRefillBloc>().add(
        EventRefillItem(
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
      title: Text("Add stock"),
      description: Text("Refill stock for '${widget.item.name}'"),
      child: ShadForm(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShadInputFormField(
              id: "quantity",
              keyboardType: TextInputType.number,
              placeholder: Text("Quantity"),
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
              id: "remarks",
              placeholder: Text("Remarks (Optional)"),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            BlocConsumer<ItemRefillBloc, ItemRefillState>(
              listener: (context, state) {
                if (state is ItemRefilled) {
                  showToast(context: context, desc: "Stock added successfully");
                  _loadTags();
                  _loadItem();
                  Navigator.pop(context);
                } else if (state is ItemRefillError) {
                  showToast(
                    context: context,
                    desc: state.message,
                    isDestructive: true,
                  );
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
                              final remarks =
                                  _formKey.currentState!.value['remarks'] ?? "";
                              _addstock(quantity: quantity, remarks: remarks);
                            }
                          },
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
    );
  }
}
