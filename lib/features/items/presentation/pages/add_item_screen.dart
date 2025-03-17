import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/utils/show_toaster.dart';
import 'package:squirrel_app/core/widgets/confirm_dialog.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_item_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_bloc.dart';

class AddItemScreen extends StatefulWidget {
  final AuthToken token;
  const AddItemScreen({super.key, required this.token});

  @override
  State<StatefulWidget> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  _addItem(String name, int quantity, String remarks) async {
    final canAdd = await showShadDialog(
      context: context,
      builder:
          (context) => ConfirmDialog(
            title: "Do you want to add item?",
            description: "You are adding $quantity $name",
          ),
    );

    if (canAdd == true && mounted) {
      context.read<AddItemBloc>().add(
        EventAddItem(
          token: widget.token,
          name: name,
          quantity: quantity,
          remarks: remarks,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text("Add item"),
      child: ShadForm(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadInputFormField(
              autofocus: true,
              id: 'name',
              placeholder: Text("Item name"),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              id: 'quantity',
              placeholder: Text("Quantity"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Quantity is required";
                }
                final number = int.tryParse(value);
                if (number == null || number <= 0) {
                  return "Enter a valid number greater than zero";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(id: 'remarks', placeholder: Text("Remarks")),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: BlocConsumer<AddItemBloc, AddItemState>(
                builder: (context, state) {
                  return switch (state) {
                    AddItemLoading() => Center(
                      child: CircularProgressIndicator(),
                    ),
                    _ => ShadButton(
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          int quantity = int.parse(
                            _formKey.currentState!.value['quantity'],
                          );
                          String name = _formKey.currentState!.value['name'];
                          String remarks =
                              _formKey.currentState!.value['remarks'];
                          _addItem(name, quantity, remarks);
                        }
                      },
                      child: const Text("Add Item"),
                    ),
                  };
                },
                listener: (BuildContext context, AddItemState state) {
                  if (state is AddItemError) {
                    showToast(
                      context: context,
                      desc: state.error,
                      isDestructive: true,
                    );
                    Navigator.of(context).maybePop();
                  }

                  if (state is AddItemLoaded) {
                    showToast(
                      context: context,
                      desc: "${state.item.name} added!",
                    );

                    context.read<ItemBloc>().add(
                      GetItems(
                        tokenparam: Tokenparam(
                          token: AuthTokenModel(
                            token: widget.token.token,
                            expiry: widget.token.expiry,
                          ),
                          param: ItemsFilter(page: 1),
                        ),
                      ),
                    );

                    Navigator.of(context).maybePop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
