import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform_logic/core/role.dart';

String getRole(Role role) {
  return switch (role) {
    Role.admin => AppStrings.admin,
    Role.user => AppStrings.user,
    Role.accountant => AppStrings.accountant,
  };
}
