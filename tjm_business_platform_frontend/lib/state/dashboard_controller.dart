import 'package:flutter/material.dart';
import 'package:tjm_business_platform/ui/model/dashboard_data_model.dart';
import 'package:tjm_business_platform_logic/core/model/expense.dart';
import 'package:tjm_business_platform_logic/core/model/report.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';

class DashboardController extends ChangeNotifier {
  static final DashboardController _instance = DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();

  final Data _data = Data();

  DashboardDataModel? _dashboardData;
  DashboardDataModel? get dashboardData => _dashboardData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _data.getTotalIncome(),
        _data.getTotalExpenses(),
        _data.getNetProfit(),
        _data.getTotalReports(),
        _data.getTotalCustomers(),
        _data.getPendingReportsCount(),
        _data.getUnpaidReportsCount(),
        _data.getRecentReports(),
        _data.getRecentExpenses(),
      ]);

      _dashboardData = DashboardDataModel(
        totalIncome: results[0] as double,
        totalExpenses: results[1] as double,
        netProfit: results[2] as double,
        totalReports: results[3] as int,
        totalCustomers: results[4] as int,
        pendingReportsCount: results[5] as int,
        unpaidReportsCount: results[6] as int,
        recentReports: results[7] as List<Report>,
        recentExpenses: results[8] as List<Expense>,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
