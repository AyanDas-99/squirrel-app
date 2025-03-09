sealed class Event {
  final DateTime timestamp;
  Event({required this.timestamp});
}

class Addition extends Event {
  final int id;
  final int itemId;
  final int quantity;
  final String remarks;
  final DateTime addedAt;

  Addition({
    required this.id,
    required this.itemId,
    required this.quantity,
    required this.remarks,
    required this.addedAt,
  }) : super(timestamp: addedAt);
}

class Issue extends Event {
  final int id;
  final int itemId;
  final int quantity;
  final String issuedTo;
  final DateTime issuedAt;

  Issue({
    required this.id,
    required this.itemId,
    required this.quantity,
    required this.issuedTo,
    required this.issuedAt,
  }) : super(timestamp: issuedAt);
}

class Removal extends Event {
  final int id;
  final int itemId;
  final int quantity;
  final String remarks;
  final DateTime removedAt;

  Removal({
    required this.id,
    required this.itemId,
    required this.quantity,
    required this.remarks,
    required this.removedAt,
  }) : super(timestamp: removedAt);
}