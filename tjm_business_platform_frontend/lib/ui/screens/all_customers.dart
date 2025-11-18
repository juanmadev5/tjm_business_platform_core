import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/ui/screens/edit_customer.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
import 'package:tjm_business_platform_logic/core/model/customer.dart';

class AllCustomers extends StatefulWidget {
  const AllCustomers({super.key});

  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  final Data data = Data();
  final ScrollController _scrollController = ScrollController();

  List<Customer> customers = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        page++;
        _fetchCustomers();
      }
    });
  }

  Future<void> _fetchCustomers({bool reset = false}) async {
    if (reset) {
      customers.clear();
      page = 1;
      hasMore = true;
    }

    setState(() {
      isLoading = true;
    });

    final newCustomers = await data.appDatabase.getCustomersByPage(page);

    setState(() {
      if (newCustomers.length < 15) {
        hasMore = false;
      }
      customers.addAll(newCustomers);
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
      appBar: AppBar(title: Text(AppStrings.customers)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (customers.isEmpty && isLoading) {
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
      itemCount: customers.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= customers.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final customer = customers[index];
        return _customerCard(customer);
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
        itemCount: customers.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= customers.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final customer = customers[index];
          return _customerCard(customer);
        },
      ),
    );
  }

  Widget _customerCard(Customer customer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(customer.phoneNumber),
        trailing: IconButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditCustomer(customer: customer),
              ),
            );

            if (result == true) {
              await _fetchCustomers(reset: true);
            }
          },
          icon: Icon(Icons.chevron_right, color: AppColors.seedColor.primary),
        ),
      ),
    );
  }
}
