import 'package:tjm_business_platform_logic/core/role.dart';

class PlatformUser {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String phoneNumber;
  final Role userRole;

  PlatformUser({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.userRole,
  });

  factory PlatformUser.fromJson(Map<String, dynamic> json) {
    final String roleString = json['role'] as String;

    Role parseRole(String roleString) {
      switch (roleString.toLowerCase()) {
        case 'admin':
          return Role.admin;
        case 'user':
          return Role.user;
        case 'accountant':
          return Role.accountant;
        default:
          throw ArgumentError('Role string not recognized: $roleString');
      }
    }

    return PlatformUser(
      id: json['id'] as String,
      name: json['name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      userRole: parseRole(roleString),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'role': userRole.name,
    };
  }
}
