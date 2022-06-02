
class Payment{
  final String id;
  final DateTime createdAt;
  final String status;
  final int amount;
  final String eventName;

  Payment({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.amount,
    required this.eventName,
  });
}