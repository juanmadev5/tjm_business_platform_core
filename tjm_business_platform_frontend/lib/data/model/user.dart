import 'package:tjm_business_platform/data/state/role/role.dart';

class PlatformUser {
  final String name;
  final String email;
  final Role userRole;

  PlatformUser({required this.name, required this.email, required this.userRole});
}
