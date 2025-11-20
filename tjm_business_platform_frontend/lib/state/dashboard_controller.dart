import 'package:flutter/material.dart';
import 'package:tjm_business_platform/ui/model/dashboard_data_model.dart';
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
      final totalIncome = await _data.getTotalIncome();
      final totalExpenses = await _data.getTotalExpenses();
      final netProfit = await _data.getNetProfit();
      final totalReports = await _data.getAllReports();
      final totalCustomers = await _data.getAllCustomers();
      final pendingReports = await _data.getPendingReportsCount();
      final unpaidReports = await _data.getUnpaidReportsCount();
      final recentReports = await _data.getRecentReports();
      final recentExpenses = await _data.getRecentExpenses();

      _dashboardData = DashboardDataModel(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netProfit: netProfit,
        totalReports: totalReports.length,
        totalCustomers: totalCustomers.length,
        pendingReportsCount: pendingReports,
        unpaidReportsCount: unpaidReports,
        recentReports: recentReports,
        recentExpenses: recentExpenses,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
