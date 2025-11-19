class Report {
  final String id;
  final String author;
  final String customerId;
  final String customerName;
  final String detail;
  final double price;
  final bool isPending;
  final bool isPaid;

  Report({
    required this.id,
    required this.author,
    required this.customerId,
    required this.customerName,
    required this.detail,
    required this.price,
    required this.isPending,
    required this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id.isEmpty ? null : id,
      'author': author,
      'customer_id': customerId,
      'detail': detail,
      'price': price,
      'is_pending': isPending,
      'is_paid': isPaid,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json, {String? customerName}) {
    final priceValue = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'] as double;

    return Report(
      id: json['id'] as String,
      author: json['author'] as String,
      customerId: json['customer_id'] as String,
      customerName: customerName ?? 'Unknown',
      detail: json['detail'] as String,
      price: priceValue,
      isPending: json['is_pending'] as bool,
      isPaid: json['is_paid'] as bool,
    );
  }

  Report copyWith({
    String? id,
    String? author,
    String? customerId,
    String? customerName,
    String? detail,
    double? price,
    bool? isPending,
    bool? isPaid,
  }) {
    return Report(
      id: id ?? this.id,
      author: author ?? this.author,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      detail: detail ?? this.detail,
      price: price ?? this.price,
      isPending: isPending ?? this.isPending,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  String get workDetails => detail;
  DateTime get createdAt => DateTime.now(); // Placeholder
}
