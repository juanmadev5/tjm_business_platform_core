import 'package:tjm_business_platform_logic/core/model/expense.dart';
import 'package:tjm_business_platform_logic/core/model/report.dart';

class DashboardDataModel {
  final double totalIncome;
  final double totalExpenses;
  final double netProfit;
  final int totalReports;
  final int totalCustomers;
  final int pendingReportsCount;
  final int unpaidReportsCount;
  final List<Report> recentReports;
  final List<Expense> recentExpenses;

  DashboardDataModel({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netProfit,
    required this.totalReports,
    required this.totalCustomers,
    required this.pendingReportsCount,
    required this.unpaidReportsCount,
    required this.recentReports,
    required this.recentExpenses,
  });
}
