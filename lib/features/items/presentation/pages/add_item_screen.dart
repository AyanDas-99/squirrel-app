import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/items/presentation/bloc/add_item_bloc.dart';

class AddItemScreen extends StatefulWidget {
  final AuthToken token;
  const AddItemScreen({super.key, required this.token});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  int quantity = 0;
  String? remarks;

  _addItem() {
    context.read<AddItemBloc>().add(
      EventAddItem(
        token: widget.token,
        name: name,
        quantity: quantity,
        remarks: remarks,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
                onSaved: (value) => name = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Quantity is required";
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return "Enter a valid number greater than zero";
                  }
                  return null;
                },
                onSaved: (value) => quantity = int.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Remarks (Optional)",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => remarks = value?.trim(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<AddItemBloc, AddItemState>(
                  builder: (context, state) {
                    return switch (state) {
                      AddItemLoading() => Center(
                        child: CircularProgressIndicator(),
                      ),
                      _ => ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Handle form submission (e.g., API call, database insert)
                            _addItem();
                          }
                        },
                        child: const Text("Add Item"),
                      ),
                    };
                  },
                  listener: (BuildContext context, AddItemState state) {
                    if (state is AddItemError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }

                    if (state is AddItemLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${state.item.name} added!')),
                      );
                      Navigator.of(context).maybePop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
