import 'package:flutter/material.dart';
import 'package:squirrel_app/core/utils/formated_date.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class RemovalCard extends StatelessWidget {
  final Removal removal;

  const RemovalCard({Key? key, required this.removal}) : super(key: key);

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
            const Icon(Icons.remove_circle, color: Colors.red, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Removal",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Item ID: ${removal.itemId}"),
                  Text("Remarks: ${removal.remarks}"),
                  Text(formatDate(removal.removedAt), style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(
              "-${removal.quantity}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}