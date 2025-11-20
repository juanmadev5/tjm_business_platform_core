import 'package:flutter/material.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/core/model/expense.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';

class ExpenseController extends ChangeNotifier {
  static final ExpenseController _instance = ExpenseController._internal();
  factory ExpenseController() => _instance;
  ExpenseController._internal();

  final Data _data = Data();

  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _page = 1;

  bool get hasData => _expenses.isNotEmpty;

  Future<void> fetchExpenses({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _expenses.clear();
      notifyListeners();
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newExpenses = await _data.getExpensesByPage(_page);

      if (newExpenses.length < 15) {
        _hasMore = false;
      }

      _expenses.addAll(newExpenses);
      _page++;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ActionResult> addExpense(Expense expense) async {
    final result = await _data.addNewExpense(expense);
    if (result == ActionResult.ok) {
      await fetchExpenses(reset: true);
    }
    return result;
  }
}
