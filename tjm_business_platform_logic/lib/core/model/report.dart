class Report {
  final String id;
  final String author;
  final String customerId;
  final String customerName;
  final String detail;
  final double price;
  final bool isPending;
  final bool isPaid;
  final String? createdAt;

  Report({
    required this.id,
    required this.author,
    required this.customerId,
    required this.customerName,
    required this.detail,
    required this.price,
    required this.isPending,
    required this.isPaid,
    required this.createdAt,
  });

  // isn't necessary to return an id in the map because this field by default is [gen_random_uuid] in database
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'customer_id': customerId,
      'detail': detail,
      'price': price,
      'is_pending': isPending,
      'is_paid': isPaid,
      'created_at': DateTime.now().toString(),
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'] as double;

    return Report(
      id: "${json['id']}",
      author: "${json['author']}",
      customerId: "${json['customer_id']}",
      customerName: "${json['customers']['name']}",
      detail: "${json['detail']}",
      price: priceValue,
      isPending: json['is_pending'] as bool,
      isPaid: json['is_paid'] as bool,
      createdAt: json['created_at'],
    );
  }
}
