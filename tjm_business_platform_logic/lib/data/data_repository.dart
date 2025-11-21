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

  Future<List<Report>> getAllReports() async {
    try {
      final response = await client!
          .from('reports')
          .select('*, customers(name)');

      return (response as List).map((json) {
        return Report.fromJson(json);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Report>> getReportByPage(int page) async {
    const int pageSize = 15;
    final int from = (page - 1) * pageSize;
    final int to = from + pageSize - 1;

    try {
      final response = await client!
          .from('reports')
          .select('*, customers(name)')
          .range(0, to)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        return Report.fromJson(json);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    try {
      final response = await client!.from('customers').select();
      return (response as List).map((json) => Customer.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<int> getTotalCustomers() async {
    try {
      final response = await client!.from('customers').select('id').count();
      return response.count;
    } catch (_) {
      return 0;
    }
  }

  Future<int> getTotalReports() async {
    try {
      final response = await client!.from('reports').select('id').count();
      return response.count;
    } catch (_) {
      return 0;
    }
  }

  Future<List<Customer>> getCustomersByPage(int page, {int limit = 15}) async {
    final from = (page - 1) * limit;
    final to = from + limit - 1;

    try {
      final response = await client!
          .from('customers')
          .select()
          .order('created_at', ascending: false)
          .range(from, to);

      return (response as List).map((json) => Customer.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Expense>> getExpensesByPage(int page, {int limit = 15}) async {
    final from = (page - 1) * limit;
    final to = from + limit - 1;

    try {
      final response = await client!
          .from('expenses')
          .select()
          .order('created_at', ascending: false) // Más recientes primero
          .range(from, to);

      return (response as List).map((json) => Expense.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<ActionResult> addNewCustomer(Customer newCustomer) async {
    try {
      await client!.from('customers').insert(newCustomer.toMap());
      return ActionResult.ok;
    } catch (_) {
      return ActionResult.error;
    }
  }

  Future<ActionResult> addNewReport(Report newReport) async {
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
              'email': "",
            })
            .select()
            .single();

        print("Customer created: $result");
      }

      await client!.from('reports').insert(newReport.toMap());

      return ActionResult.ok;
    } catch (_) {
      return ActionResult.error;
    }
  }

  Future<ActionResult> addNewExpense(Expense newExpense) async {
    try {
      await client!.from('expenses').insert(newExpense.toMap());
      return ActionResult.ok;
    } catch (_) {
      return ActionResult.error;
    }
  }

  Future<List<Map<String, String>>> findCustomersByNameFragment(
    String name,
  ) async {
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
    } catch (_) {
      return [];
    }
  }

  Future<ActionResult> deleteReport(String reportId) async {
    try {
      await client!.from('reports').delete().eq('id', reportId);
      return ActionResult.ok;
    } catch (_) {
      return ActionResult.error;
    }
  }

  Future<ActionResult> deleteCustomer(String customerId) async {
    try {
      await client!.from('customers').delete().eq('id', customerId);
      return ActionResult.ok;
    } catch (_) {
      return ActionResult.error;
    }
  }

  Future<ActionResult> editCustomer(Customer updatedCustomer) async {
    try {
      await client!
          .from('customers')
          .update(updatedCustomer.toMap())
          .eq('id', updatedCustomer.id);

      return ActionResult.ok;
    } catch (_) {
      return ActionResult.error;
    }
  }

  Future<ActionResult> editReport(Report updatedReport) async {
    try {
      await client!
          .from('reports')
          .update(updatedReport.toMap())
          .eq('id', updatedReport.id);

      return ActionResult.ok;
    } catch (_) {
      return ActionResult.error;
    }
  }

  Future<double> getTotalIncome() async {
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
    } catch (_) {
      return 0.0;
    }
  }

  Future<double> getTotalExpenses() async {
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
    } catch (_) {
      return 0.0;
    }
  }

  Future<double> getNetProfit() async {
    final income = await getTotalIncome();
    final expenses = await getTotalExpenses();
    return income - expenses;
  }

  Future<int> getPendingReportsCount() async {
    try {
      final response = await client!
          .from('reports')
          .select('id')
          .eq('is_pending', true);
      return (response as List).length;
    } catch (_) {
      return 0;
    }
  }

  Future<int> getUnpaidReportsCount() async {
    try {
      final response = await client!
          .from('reports')
          .select('id')
          .eq('is_paid', false);
      return (response as List).length;
    } catch (_) {
      return 0;
    }
  }

  Future<List<Report>> getRecentReports({int limit = 5}) async {
    try {
      final response = await client!
          .from('reports')
          .select('*, customers(name)')
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((json) {
        return Report.fromJson(json);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Expense>> getRecentExpenses({int limit = 5}) async {
    try {
      final response = await client!
          .from('expenses')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      return (response as List).map((json) => Expense.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }
}
