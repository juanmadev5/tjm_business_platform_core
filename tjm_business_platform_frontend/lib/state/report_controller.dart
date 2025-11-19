import 'package:flutter/material.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/core/model/report.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
import 'package:uuid/uuid.dart';

class ReportController extends ChangeNotifier {
  static final ReportController _instance = ReportController._internal();
  factory ReportController() => _instance;
  ReportController._internal();

  final Data _data = Data();

  List<Report> _reports = [];
  List<Report> get reports => _reports;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _page = 1;

  bool get hasData => _reports.isNotEmpty;

  Future<void> fetchReports({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _reports.clear();
      notifyListeners();
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newReports = await _data.getReportByPage(_page);

      if (newReports.length < 15) {
        _hasMore = false;
      }

      _reports.addAll(newReports);
      _page++;
    } catch (e) {
      print("Error fetching reports: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ActionResult> addReport(Report report) async {
    final result = await _data.addNewReport(report);
    if (result == ActionResult.ok) {
      await fetchReports(reset: true);
    }
    return result;
  }

  Future<ActionResult> createReport({
    required String customerName,
    required String details,
    required double price,
    required bool isCompleted,
    required bool isPaid,
    required String author,
    String? existingCustomerId,
  }) async {
    String customerId = existingCustomerId ?? "";

    if (customerId.isEmpty) {
      try {
        final matches = await _data.findCustomersByNameFragment(customerName);
        final exactMatch = matches.firstWhere(
          (c) => c['name']?.toLowerCase() == customerName.toLowerCase(),
          orElse: () => {},
        );

        if (exactMatch.isNotEmpty) {
          customerId = exactMatch['id']!;
        }
      } catch (e) {
        print("Error checking existing customer: $e");
      }
    }

    if (customerId.isEmpty) {
      customerId = const Uuid().v4();
    }

    final newReport = Report(
      id: const Uuid().v4(),
      author: author,
      customerId: customerId,
      customerName: customerName,
      detail: details,
      price: price,
      isPending: !isCompleted,
      isPaid: isPaid,
    );

    return await addReport(newReport);
  }

  Future<ActionResult> editReport(Report report) async {
    final result = await _data.editReport(report);
    if (result == ActionResult.ok) {
      final index = _reports.indexWhere((r) => r.id == report.id);
      if (index != -1) {
        _reports[index] = report;
        notifyListeners();
      }
    }
    return result;
  }

  Future<ActionResult> deleteReport(String reportId) async {
    final result = await _data.deleteReport(reportId);
    if (result == ActionResult.ok) {
      _reports.removeWhere((r) => r.id == reportId);
      notifyListeners();
    }
    return result;
  }
}
