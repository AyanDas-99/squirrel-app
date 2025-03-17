import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/utils/show_toaster.dart';
import 'package:squirrel_app/core/widgets/confirm_dialog.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_by_id_bloc.dart';
import 'package:squirrel_app/features/items/presentation/bloc/item_refill_bloc.dart';
import 'package:squirrel_app/features/transactions/presentation/bloc/issue_item_bloc.dart';

class IssueItemScreen extends StatefulWidget {
  final Item item;
  final AuthToken token;
  const IssueItemScreen({super.key, required this.item, required this.token});

  @override
  State<IssueItemScreen> createState() => _IssueItemScreenState();
}

class _IssueItemScreenState extends State<IssueItemScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  _loadItem() {
    context.read<ItemByIdBloc>().add(
      LoadItemByIdEvent(token: widget.token, itemId: widget.item.id),
    );
  }

  _issueItem({required int quantity, required String issueTo}) async {
    final canIssue = await showShadDialog(
      context: context,
      builder:
          (context) => ConfirmDialog(
            title: "Do you want to issue items?",
            description:
                "You are issuing $quantity '${widget.item.name}' to '$issueTo'",
          ),
    );

    if (canIssue == true && mounted) {
      context.read<IssueItemBloc>().add(
        EventIssueItem(
          itemId: widget.item.id,
          quantity: quantity,
          issuedTo: issueTo,
          token: widget.token,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: Text("Issue Item"),
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
              placeholder: Text("Issuing to"),
              id: "remarks",
              maxLines: 3,
              validator: (value) {
                if (value.isEmpty) {
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
                  showToast(
                    context: context,
                    desc: 'Item issued to ${state.issue.issuedTo} successfully',
                  );
                  _loadItem();
                  Navigator.pop(context);
                } else if (state is IssueItemError) {
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
                              final issueTo =
                                  _formKey.currentState!.value['remarks'];
                              _issueItem(quantity: quantity, issueTo: issueTo);
                            }
                          },
                  child:
                      (state is ItemRefillLoading)
                          ? const Center(child: CircularProgressIndicator())
                          : const Text('Issue', style: TextStyle(fontSize: 16)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
