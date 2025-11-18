import 'package:tjm_business_platform_logic/domain/auth.dart';
import 'package:supabase/supabase.dart';
import '../core/action_result.dart';
import '../core/model/customer.dart';
import '../core/model/expense.dart';
import '../core/model/report.dart';

/// Core class that controls data layer behavior
/// Uses [Supabase] as database.
class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal();

  SupabaseClient? client;

  void initSupabase(SupabaseClient supabaseClient) {
    client = supabaseClient;
  }

  Auth auth = Auth();
  bool _isLoggedIn() => auth.isLoggedIn();

  Future<List<Report>> getAllReports() async {
    if (!_isLoggedIn()) {
      return List.empty();
    }
    try {
      final response = await client!
          .from('reports')
          .select('*, customers(name)');

      return (response as List).map((json) {
        final customerData = json['customers'] as Map<String, dynamic>?;
        final customerName = customerData?['name'] as String? ?? 'N/A';

        return Report.fromJson(json, customerName: customerName);
      }).toList();
    } catch (e) {
      print('Error fetching reports: $e');
      return [];
    }
  }

  Future<List<Report>> getReportByPage(int page) async {
    if (!_isLoggedIn()) {
      return List.empty();
    }

    const int pageSize = 15;
    final int from = (page - 1) * pageSize;
    final int to = from + pageSize - 1;

    try {
      final response = await client!
          .from('reports')
          .select('*, customers(name)')
          .range(from, to)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        final customerData = json['customers'] as Map<String, dynamic>?;
        final customerName = customerData?['name'] as String? ?? 'N/A';

        return Report.fromJson(json, customerName: customerName);
      }).toList();
    } catch (e) {
      print('Error fetching paginated reports: $e');
      return [];
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    if (!_isLoggedIn()) {
      return List.empty();
    }
    try {
      final response = await client!.from('customers').select();
      return (response as List).map((json) => Customer.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching customers: $e');
      return [];
    }
  }

  Future<List<Customer>> getCustomersByPage(int page, {int limit = 15}) async {
    if (!_isLoggedIn()) return [];
    final from = (page - 1) * limit;
    final to = from + limit - 1;

    try {
      final response = await client!
          .from('customers')
          .select()
          .order('created_at', ascending: false)
          .range(from, to);

      return (response as List).map((json) => Customer.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching customers: $e');
      return [];
    }
  }

  Future<List<Expense>> getExpensesByPage(int page, {int limit = 15}) async {
    if (!_isLoggedIn()) return [];

    final from = (page - 1) * limit;
    final to = from + limit - 1;

    try {
      final response = await client!
          .from('expenses')
          .select()
          .order('created_at', ascending: false) // Más recientes primero
          .range(from, to);

      return (response as List).map((json) => Expense.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching paginated expenses: $e');
      return [];
    }
  }

  Future<ActionResult> addNewCustomer(Customer newCustomer) async {
    if (!_isLoggedIn()) {
      return ActionResult.error;
    }
    try {
      await client!.from('customers').insert(newCustomer.toMap());
      return ActionResult.ok;
    } on PostgrestException catch (e) {
      print('Error adding new customer: ${e.message}');
      return ActionResult.error;
    }
  }

  Future<ActionResult> addNewReport(Report newReport) async {
    if (!_isLoggedIn()) {
      return ActionResult.error;
    }

    try {
      final customerResponse = await client!
          .from('customers')
          .select()
          .eq('id', newReport.customerId)
          .maybeSingle();

      String customerId = newReport.customerId;

      if (customerResponse == null) {
        final result = await client!
            .from('customers')
            .insert({
              'id': customerId,
              'name': newReport.customerName,
              'phone_number': "",
            })
            .select()
            .single();

        print("Customer created: $result");
      }

      await client!.from('reports').insert(newReport.toMap());

      return ActionResult.ok;
    } on PostgrestException catch (e) {
      print("DB error saving report: ${e.message}");
      return ActionResult.error;
    } catch (e) {
      print("Unexpected error saving report: $e");
      return ActionResult.error;
    }
  }

  Future<ActionResult> addNewExpense(Expense newExpense) async {
    if (!_isLoggedIn()) {
      return ActionResult.error;
    }
    try {
      await client!.from('expenses').insert(newExpense.toMap());
      return ActionResult.ok;
    } catch (e) {
      print('Error adding new expense: $e');
      return ActionResult.error;
    }
  }

  Future<List<Map<String, String>>> findCustomersByNameFragment(
    String name,
  ) async {
    if (!_isLoggedIn()) {
      return List.empty();
    }

    try {
      final response = await client!
          .from('customers')
          .select('id, name, phone_number')
          .ilike('name', '%$name%');

      return (response as List)
          .map(
            (e) => {
              'id': e['id'].toString(),
              'name': e['name'] as String,
              'phoneNumber': e['phone_number'] as String,
            },
          )
          .toList();
    } catch (e) {
      print('Error finding customers: $e');
      return [];
    }
  }

  Future<ActionResult> deleteReport(String reportId) async {
    if (!_isLoggedIn()) {
      return ActionResult.error;
    }
    try {
      await client!.from('reports').delete().eq('id', reportId);
      return ActionResult.ok;
    } catch (e) {
      print('Error deleting report: $e');
      return ActionResult.error;
    }
  }

  Future<ActionResult> deleteCustomer(String customerId) async {
    if (!_isLoggedIn()) {
      return ActionResult.error;
    }
    try {
      await client!.from('customers').delete().eq('id', customerId);
      return ActionResult.ok;
    } catch (e) {
      print('Error deleting customer: $e');
      return ActionResult.error;
    }
  }

  Future<ActionResult> editCustomer(Customer updatedCustomer) async {
    if (!_isLoggedIn()) {
      return ActionResult.error;
    }
    try {
      await client!
          .from('customers')
          .update(updatedCustomer.toMap())
          .eq('id', updatedCustomer.id);

      return ActionResult.ok;
    } catch (e) {
      print('Error editing customer: $e');
      return ActionResult.error;
    }
  }

  Future<ActionResult> editReport(Report updatedReport) async {
    if (!_isLoggedIn()) {
      return ActionResult.error;
    }
    try {
      await client!
          .from('reports')
          .update(updatedReport.toMap())
          .eq('id', updatedReport.id);

      return ActionResult.ok;
    } catch (e) {
      print('Error editing report: $e');
      return ActionResult.error;
    }
  }

  Future<double> getTotalIncome() async {
    if (!_isLoggedIn()) {
      throw Exception("Invalid operation, need to be logged in");
    }
    try {
      final response = await client!
          .from('reports')
          .select('price')
          .eq('is_paid', true);

      final total = (response as List).fold<double>(
        0.0,
        (sum, r) =>
            sum +
            (r['price'] is int
                ? (r['price'] as int).toDouble()
                : r['price'] as double),
      );

      return total;
    } catch (e) {
      print('Error getting total income: $e');
      return 0.0;
    }
  }

  Future<double> getTotalExpenses() async {
    if (!_isLoggedIn()) {
      throw Exception("Invalid operation, need to be logged in");
    }
    try {
      final response = await client!.from('expenses').select('price');

      final total = (response as List).fold<double>(
        0.0,
        (sum, e) =>
            sum +
            (e['price'] is int
                ? (e['price'] as int).toDouble()
                : e['price'] as double),
      );

      return total;
    } catch (e) {
      print('Error getting total expenses: $e');
      return 0.0;
    }
  }

  Future<double> getNetProfit() async {
    if (!_isLoggedIn()) {
      throw Exception("Invalid operation, need to be logged in");
    }
    final income = await getTotalIncome();
    final expenses = await getTotalExpenses();
    return income - expenses;
  }
}
