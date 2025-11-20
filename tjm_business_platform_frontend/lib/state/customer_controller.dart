import 'package:flutter/material.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/core/model/customer.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';

class CustomerController extends ChangeNotifier {
  static final CustomerController _instance = CustomerController._internal();
  factory CustomerController() => _instance;
  CustomerController._internal();

  final Data _data = Data();

  final List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _page = 1;

  bool get hasData => _customers.isNotEmpty;

  Future<void> fetchCustomers({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _customers.clear();
      notifyListeners();
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newCustomers = await _data.getCustomersByPage(_page);

      if (newCustomers.length < 15) {
        _hasMore = false;
      }

      _customers.addAll(newCustomers);
      _page++;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ActionResult> addCustomer(Customer customer) async {
    final result = await _data.addNewCustomer(customer);
    if (result == ActionResult.ok) {
      await fetchCustomers(reset: true);
    }
    return result;
  }

  Future<ActionResult> editCustomer(Customer updatedCustomer) async {
    final result = await _data.editCustomer(updatedCustomer);
    if (result == ActionResult.ok) {
      final index = _customers.indexWhere((c) => c.id == updatedCustomer.id);
      if (index != -1) {
        _customers[index] = updatedCustomer;
        notifyListeners();
      }
    }
    return result;
  }

  Future<ActionResult> deleteCustomer(String customerId) async {
    final result = await _data.deleteCustomer(customerId);
    if (result == ActionResult.ok) {
      _customers.removeWhere((c) => c.id == customerId);
      notifyListeners();
    }
    return result;
  }
}
