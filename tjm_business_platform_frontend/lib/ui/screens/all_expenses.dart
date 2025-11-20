import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/core/is_desktop.dart';
import 'package:tjm_business_platform/state/expense_controller.dart';
import 'package:tjm_business_platform/ui/components/expense_card.dart';
import 'package:tjm_business_platform/ui/components/responsive_layout.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  final ExpenseController _controller = ExpenseController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (!_controller.hasData) {
      _controller.fetchExpenses();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_controller.isLoading &&
          _controller.hasMore) {
        _controller.fetchExpenses();
      }
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
      appBar: !isDesktop(context)
          ? AppBar(title: Text(AppStrings.purchases))
          : null,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.expenses.isEmpty && _controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.expenses.isEmpty) {
      return const Center(
        child: Text(AppStrings.noExpenses, style: TextStyle(fontSize: 18)),
      );
    }

    return ResponsiveLayout(
      mobileBody: _buildMobileList(),
      desktopBody: _buildDesktopGrid(),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _controller.expenses.length + (_controller.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _controller.expenses.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final expense = _controller.expenses[index];
        return ExpenseCard(expense: expense);
      },
    );
  }

  Widget _buildDesktopGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
        ),
        itemCount: _controller.expenses.length + (_controller.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _controller.expenses.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final expense = _controller.expenses[index];
          return ExpenseCard(expense: expense);
        },
      ),
    );
  }
}
