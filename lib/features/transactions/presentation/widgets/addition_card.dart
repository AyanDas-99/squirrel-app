import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/utils/formated_date.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class AdditionCard extends StatelessWidget {
  final Addition addition;

  const AdditionCard({super.key, required this.addition});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(15),
      leading: const Row(
        children: [
          Icon(Icons.add_circle, color: Colors.green, size: 32),
          SizedBox(width: 10),
        ],
      ),
      title: Column(
        children: [
          Text(
            "Addition",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
        ],
      ),
      description: Column(
        children: [
          Text(
            formatDate(addition.addedAt),
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 10),
        ],
      ),
      trailing: Text(
        "+${addition.quantity}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Remarks:  ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(addition.remarks, softWrap: true,)),
        ],
      ),
    );
  }
}
