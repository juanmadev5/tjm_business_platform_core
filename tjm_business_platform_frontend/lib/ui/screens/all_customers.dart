import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
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
    return Scaffold(body: _body());
  }

  Widget _body() {
    if (customers.isEmpty && isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: customers.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= customers.length) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final customer = customers[index];
          return ListTile(
            leading: IconButton(
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
              icon: Icon(Icons.edit, color: AppColors.seedColor.primary),
            ),

            title: Text(customer.name),
            subtitle: Text(customer.phoneNumber),
          );
        },
      );
    }
  }
}
