import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ErrorTextWidget extends StatelessWidget {
  final String description;
  const ErrorTextWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return ShadAlert(
      icon: Icon(Icons.error_outline),
      title: Text("Error"),
      description: Text(description),
    );
  }
}
