class Expense {
  final String id;
  final String name;
  final String detail;
  final int quantity;
  final double price;

  Expense({
    required this.id,
    required this.name,
    required this.detail,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id.isEmpty ? null : id,
      'name': name,
      'detail': detail,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'] as double;

    return Expense(
      id: json['id'] as String,
      name: json['name'] as String,
      detail: json['detail'] as String,
      quantity: json['quantity'] as int,
      price: priceValue,
    );
  }
}
