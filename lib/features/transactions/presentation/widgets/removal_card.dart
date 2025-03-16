import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/utils/formated_date.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class RemovalCard extends StatelessWidget {
  final Removal removal;

  const RemovalCard({Key? key, required this.removal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(15),
      leading: const Row(
        children: [
          Icon(Icons.remove_circle, color: Colors.red, size: 32),
          SizedBox(width: 10),
        ],
      ),
      title: Column(
        children: [
          Text(
            "Removal",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
        ],
      ),
      description: Column(
        children: [
          Text(
            formatDate(removal.removedAt),
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 10),
        ],
      ),
      trailing: Text(
        "-${removal.quantity}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      child: Row(
        children: [
          Text(
            "Reason:  ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(removal.remarks),
        ],
      ),
    );
  }
}
