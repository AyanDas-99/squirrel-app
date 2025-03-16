import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: Text(title),
      description: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(description),
      ),
      actions: [
        ShadButton.outline(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(false),
        ),

        ShadButton.outline(
          child: const Text("Continue"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
