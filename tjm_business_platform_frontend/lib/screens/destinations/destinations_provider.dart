import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/model/app_destination_item.dart';
import 'package:tjm_business_platform/core/strings.dart';
import 'package:tjm_business_platform/data/provider.dart';
import 'package:tjm_business_platform/data/state/role/role.dart';
import 'package:tjm_business_platform/screens/views/create_report.dart';
import 'package:tjm_business_platform/screens/views/customers.dart';
import 'package:tjm_business_platform/screens/views/dashboard.dart';
import 'package:tjm_business_platform/screens/views/expenses.dart';
import 'package:tjm_business_platform/screens/views/register_customer.dart';
import 'package:tjm_business_platform/screens/views/register_expense.dart';
import 'package:tjm_business_platform/screens/views/reports.dart';

class DestinationsProvider {
  /// Register all views destination
  static List<AppDestinationItem> destinations() {
    return [
      AppDestinationItem(
        AppStrings.dashboard,
        Icon(Icons.dashboard_outlined),
        Icon(Icons.dashboard),
        [Role.admin, Role.accountant],
      ),
      AppDestinationItem(
        AppStrings.createReport,
        Icon(Icons.create),
        Icon(Icons.create_outlined),
        [Role.admin, Role.employee],
      ),
      AppDestinationItem(
        AppStrings.allReports,
        Icon(Icons.view_list),
        Icon(Icons.view_list_outlined),
        [Role.admin, Role.employee],
      ),
      AppDestinationItem(
        AppStrings.registerExpense,
        Icon(Icons.monetization_on_outlined),
        Icon(Icons.monetization_on),
        [Role.admin, Role.accountant],
      ),
      AppDestinationItem(
        AppStrings.allExpenses,
        Icon(Icons.receipt_outlined),
        Icon(Icons.receipt),
        [Role.admin, Role.accountant],
      ),
      AppDestinationItem(
        AppStrings.allClients,
        Icon(Icons.people_outline),
        Icon(Icons.people),
        [Role.admin, Role.accountant, Role.employee],
      ),
      AppDestinationItem(
        AppStrings.addNewClient,
        Icon(Icons.person_add_outlined),
        Icon(Icons.person_add),
        [Role.admin, Role.accountant, Role.employee],
      ),
    ];
  }

  /// Register all views and return a view based on
  /// NavigationRail current index
  static Widget setView(int index, Provider provider) {
    List<Role> asignedRole = [];
    provider.getCurrentRole().forEach((role) {
      asignedRole.add(role);
    });

    if (asignedRole.contains(Role.accountant) &&
        !asignedRole.contains(Role.employee)) {
      return switch (index) {
        0 => DashboardView(),
        1 => RegisterExpenseView(),
        2 => ExpensesView(),
        3 => CustomersView(),
        4 => RegisterCustomerView(),
        _ => Text("Error"),
      };
    } else if (asignedRole.contains(Role.employee) &&
        !asignedRole.contains(Role.accountant)) {
      return switch (index) {
        0 => CreateReportView(),
        1 => ReportsView(),
        2 => CustomersView(),
        3 => RegisterCustomerView(),
        _ => Text("Error"),
      };
    } else {
      return switch (index) {
        0 => DashboardView(),
        1 => CreateReportView(),
        2 => ReportsView(),
        3 => RegisterExpenseView(),
        4 => ExpensesView(),
        5 => CustomersView(),
        6 => RegisterCustomerView(),
        _ => Text("Error"),
      };
    }
  }
}
