import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/state/customer_controller.dart';
import 'package:tjm_business_platform/ui/components/customer_card.dart';
import 'package:tjm_business_platform/ui/components/responsive_layout.dart';
import 'package:tjm_business_platform/ui/screens/edit_customer.dart';
import 'package:tjm_business_platform_logic/core/model/customer.dart';

class AllCustomers extends StatefulWidget {
  const AllCustomers({super.key});

  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  final CustomerController _controller = CustomerController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (!_controller.hasData) {
      _controller.fetchCustomers();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_controller.isLoading &&
          _controller.hasMore) {
        _controller.fetchCustomers();
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
      appBar: AppBar(title: Text(AppStrings.customers)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.customers.isEmpty && _controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.customers.isEmpty) {
      return Center(
        child: Text(AppStrings.noCustomers, style: TextStyle(fontSize: 18)),
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
      itemCount: _controller.customers.length + (_controller.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _controller.customers.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final customer = _controller.customers[index];
        return CustomerCard(
          customer: customer,
          onTap: () => _navigateToEdit(customer),
        );
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
          mainAxisSpacing: 8,
          childAspectRatio: 3,
        ),
        itemCount: _controller.customers.length + (_controller.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _controller.customers.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final customer = _controller.customers[index];
          return CustomerCard(
            customer: customer,
            onTap: () => _navigateToEdit(customer),
          );
        },
      ),
    );
  }

  Future<void> _navigateToEdit(Customer customer) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCustomer(customer: customer)),
    );
  }
}
