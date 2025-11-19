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

    setState(() => isLoading = true);

    final newCustomers = await data.appDatabase.getCustomersByPage(page);

    setState(() {
      if (newCustomers.length < 15) hasMore = false;
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

          if (customers.isEmpty) {
            return const Center(
              child: Text(
                "No hay clientes registrados",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          if (isDesktop) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 128,
                vertical: 16,
              ),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 4,
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
          } else {
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
        },
      ),
    );
  }

  Widget _customerCard(Customer customer) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            // Icono circular
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
              child: const Icon(
                Icons.person,
                color: Colors.blueAccent,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Información del cliente
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.phoneNumber,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (customer.email != null && customer.email!.isNotEmpty)
                    Text(
                      customer.email!,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                ],
              ),
            ),
            // Botón de acción
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditCustomer(customer: customer),
                  ),
                );
                if (result == true) await _fetchCustomers(reset: true);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.seedColor.onSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
