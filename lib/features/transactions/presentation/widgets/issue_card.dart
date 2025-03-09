import 'package:flutter/material.dart';
import 'package:squirrel_app/core/utils/formated_date.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class IssueCard extends StatelessWidget {
  final Issue issue;

  const IssueCard({super.key, required this.issue});

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
            const Icon(Icons.arrow_circle_up, color: Colors.blue, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Issue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Item ID: ${issue.itemId}"),
                  Text("Issued To: ${issue.issuedTo}"),
                  Text(formatDate(issue.issuedAt), style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(
              "-${issue.quantity}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}