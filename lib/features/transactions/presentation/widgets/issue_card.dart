import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/utils/formated_date.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class IssueCard extends StatelessWidget {
  final Issue issue;

  const IssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(15),
      leading: const Row(
        children: [
          Icon(Icons.arrow_downward, color: Colors.blue, size: 32),
          SizedBox(width: 10),
        ],
      ),
      title: Column(
        children: [
          Text(
            "Issue",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
        ],
      ),
      description: Column(
        children: [
          Text(
            formatDate(issue.issuedAt),
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 10),
        ],
      ),
      trailing: Text(
        "-${issue.quantity}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      child: Row(
        children: [
          Text(
            "Issued To:  ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(issue.issuedTo),
        ],
      ),
    );
  }
}
