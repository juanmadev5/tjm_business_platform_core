import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/ui/utils/currency_format.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
import 'package:tjm_business_platform_logic/core/model/expense.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  final Data data = Data();
  final ScrollController _scrollController = ScrollController();

  List<Expense> expenses = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        page++;
        _fetchExpenses();
      }
    });
  }

  Future<void> _fetchExpenses({bool reset = false}) async {
    if (reset) {
      expenses.clear();
      page = 1;
      hasMore = true;
    }

    setState(() {
      isLoading = true;
    });

    final newExpenses = await data.appDatabase.getExpensesByPage(page);

    setState(() {
      if (newExpenses.length < 15) {
        hasMore = false;
      }
      expenses.addAll(newExpenses);
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.purchases)),
      body: _body(),
    );
  }

  Widget _body() {
    if (expenses.isEmpty && isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: expenses.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= expenses.length) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final expense = expenses[index];
          return ListTile(
            title: Text(expense.name),
            subtitle: Text(expense.detail),
            trailing: Text(
              "${expense.quantity} × ${formatDoubleToGs(expense.price)}",
            ),
          );
        },
      );
    }
  }
}
