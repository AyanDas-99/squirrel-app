import 'package:flutter/material.dart';
import 'package:squirrel_app/core/utils/formated_date.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class AdditionCard extends StatelessWidget {
  final Addition addition;

  const AdditionCard({super.key, required this.addition});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle, color: Colors.green, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Addition",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Item ID: ${addition.itemId}"),
                  Text("Remarks: ${addition.remarks}"),
                  Text(formatDate(addition.addedAt), style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(
              "+${addition.quantity}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}