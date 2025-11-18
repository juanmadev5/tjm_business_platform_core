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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (expenses.isEmpty && isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (isDesktop) {
            return Padding(
              padding: .only(left: 128, right: 128),
              child: desktopView(),
            );
          } else {
            return mobileView();
          }
        },
      ),
    );
  }

  ListView mobileView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= expenses.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final expense = expenses[index];
        return _expenseCard(expense);
      },
    );
  }

  Padding desktopView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
        ),
        itemCount: expenses.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= expenses.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final expense = expenses[index];
          return _expenseCard(expense);
        },
      ),
    );
  }

  Widget _expenseCard(Expense expense) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          expense.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(expense.detail),
        trailing: Text(
          "${expense.quantity} × ${formatDoubleToGs(expense.price)}",
        ),
      ),
    );
  }
}
