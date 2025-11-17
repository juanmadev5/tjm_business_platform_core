import 'report.dart';

class Customer {
  final String id;
  final String name;
  final String phoneNumber;
  final List<Report> works;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.works,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id.isEmpty ? null : id,
      'name': name,
      'phone_number': phoneNumber,
    };
  }

  // Para crear desde Supabase
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      works: [],
    );
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    List<Report>? works,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      works: works ?? this.works,
    );
  }
}
