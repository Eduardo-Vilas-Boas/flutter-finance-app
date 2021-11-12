class UserTransaction {
  final int id;
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  UserTransaction({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });
}
