class Report {
  final String author;
  final DateTime date;
  final String customerName;
  final String details;
  final double price;
  final bool isCompleted;

  Report({
    required this.author,
    required this.date,
    required this.customerName,
    required this.details,
    required this.price,
    required this.isCompleted,
  });
}
