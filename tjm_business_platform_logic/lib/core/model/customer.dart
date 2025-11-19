import 'report.dart';

class Customer {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final List<Report> works;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.works,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id.isEmpty ? null : id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      email: json['email'] ?? "",
      works: [],
    );
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    List<Report>? works,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      works: works ?? this.works,
    );
  }
}
