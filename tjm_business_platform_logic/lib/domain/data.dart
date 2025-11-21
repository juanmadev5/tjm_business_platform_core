import '../core/action_result.dart';
import '../data/data_repository.dart';
import '../core/model/customer.dart';
import '../core/model/expense.dart';
import '../core/model/report.dart';

class Data {
  static final Data _instance = Data._internal();
  factory Data() => _instance;
  Data._internal();

  DataRepository appDatabase = DataRepository();

  Future<List<Report>> getAllReports() => appDatabase.getAllReports();

  Future<List<Report>> getReportByPage(int page) =>
      appDatabase.getReportByPage(page);

  Future<int> getTotalReports() => appDatabase.getTotalReports();

  Future<List<Customer>> getAllCustomers() => appDatabase.getAllCustomers();

  Future<int> getTotalCustomers() => appDatabase.getTotalCustomers();

  Future<List<Customer>> getCustomersByPage(int page) =>
      appDatabase.getCustomersByPage(page);

  Future<List<Expense>> getExpensesByPage(int page) =>
      appDatabase.getExpensesByPage(page);

  Future<ActionResult> addNewReport(Report newReport) async =>
      appDatabase.addNewReport(newReport);

  Future<ActionResult> addNewCustomer(Customer newCustomer) async =>
      appDatabase.addNewCustomer(newCustomer);

  Future<ActionResult> addNewExpense(Expense newExpense) async =>
      appDatabase.addNewExpense(newExpense);

  Future<List<Map<String, String>>> findCustomersByNameFragment(
    String name,
  ) async => appDatabase.findCustomersByNameFragment(name);

  Future<ActionResult> deleteReport(String reportId) async =>
      appDatabase.deleteReport(reportId);

  Future<ActionResult> deleteCustomer(String customerId) async =>
      appDatabase.deleteCustomer(customerId);

  Future<ActionResult> editCustomer(Customer updatedCustomer) async =>
      appDatabase.editCustomer(updatedCustomer);

  Future<ActionResult> editReport(Report updatedReport) async =>
      appDatabase.editReport(updatedReport);

  Future<double> getTotalIncome() async => appDatabase.getTotalIncome();

  Future<double> getTotalExpenses() async => appDatabase.getTotalExpenses();

  Future<double> getNetProfit() async => appDatabase.getNetProfit();

  Future<int> getPendingReportsCount() async =>
      appDatabase.getPendingReportsCount();

  Future<int> getUnpaidReportsCount() async =>
      appDatabase.getUnpaidReportsCount();

  Future<List<Report>> getRecentReports({int limit = 5}) async =>
      appDatabase.getRecentReports(limit: limit);

  Future<List<Expense>> getRecentExpenses({int limit = 5}) async =>
      appDatabase.getRecentExpenses(limit: limit);
}
