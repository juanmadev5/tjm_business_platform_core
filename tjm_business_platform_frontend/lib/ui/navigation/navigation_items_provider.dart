import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/ui/navigation/navigation_item.dart';
import 'package:tjm_business_platform_logic/core/role.dart';

class NavigationItemsProvider {
  static List<NavigationItem> items() {
    return [
      NavigationItem(
        name: AppStrings.dashboard,
        icon: Icons.dashboard_rounded,
        roles: [Role.admin, Role.accountant],
      ),
      NavigationItem(
        name: AppStrings.createReport,
        icon: Icons.post_add_rounded,
        roles: [Role.admin, Role.user],
      ),
      NavigationItem(
        name: AppStrings.reports,
        icon: Icons.list_alt_rounded,
        roles: [Role.admin, Role.user],
      ),
      NavigationItem(
        name: AppStrings.registerCustomer,
        icon: Icons.group_add_rounded,
        roles: [Role.admin, Role.user],
      ),
      NavigationItem(
        name: AppStrings.customers,
        icon: Icons.groups_rounded,
        roles: [Role.admin, Role.user],
      ),
      NavigationItem(
        name: AppStrings.registerPurchase,
        icon: Icons.request_quote_rounded,
        roles: [Role.admin, Role.accountant],
      ),
      NavigationItem(
        name: AppStrings.purchases,
        icon: Icons.shopping_basket_rounded,
        roles: [Role.admin, Role.accountant],
      ),
    ];
  }
}
