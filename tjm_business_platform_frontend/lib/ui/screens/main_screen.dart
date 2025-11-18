import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/ui/model/dashboard_data_model.dart';
import 'package:tjm_business_platform/ui/navigation/navigation_item.dart';
import 'package:tjm_business_platform/ui/navigation/navigation_items_provider.dart';
import 'package:tjm_business_platform/ui/screens/all_customers.dart';
import 'package:tjm_business_platform/ui/screens/all_expenses.dart';
import 'package:tjm_business_platform/ui/screens/all_reports.dart';
import 'package:tjm_business_platform/ui/screens/create_customer.dart';
import 'package:tjm_business_platform/ui/screens/create_report.dart';
import 'package:tjm_business_platform/ui/screens/dashboard_screen.dart';
import 'package:tjm_business_platform/ui/screens/login_screen.dart';
import 'package:tjm_business_platform/ui/screens/register_purchase.dart';
import 'package:tjm_business_platform/ui/utils/get_role.dart';
import 'package:tjm_business_platform/ui/utils/greet_by_hour.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/domain/auth.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Data data = Data();
  final Auth auth = Auth();

  PlatformUser? user;
  bool isLoading = true;
  String? errorMessage;
  DashboardDataModel? dashboardData;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadData();
  }

  Future<void> _loadData() async {
    final totalIncome = await data.getTotalIncome();
    final totalExpenses = await data.getTotalExpenses();
    final netProfit = await data.getNetProfit();
    final totalReports = await data.getAllReports();
    final totalCustomers = await data.getAllCustomers();

    setState(() {
      dashboardData = DashboardDataModel(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netProfit: netProfit,
        totalReports: totalReports.length,
        totalCustomers: totalCustomers.length,
      );
    });
  }

  Future<void> _loadUserProfile() async {
    setState(() => isLoading = true);
    try {
      final profile = await auth.getUserProfile();
      if (profile == null) {
        setState(() {
          isLoading = false;
          errorMessage = AppStrings.userNotFound;
        });
        return;
      }
      setState(() {
        user = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar el perfil: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = NavigationItemsProvider.items();
    final userRole = user?.userRole;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    final filteredItems = items
        .where((item) => item.roles.contains(userRole))
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          user!.email,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (isDesktop) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${greetByHour()} ${user!.name} ${user!.lastName}!",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            getRole(user!.userRole),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: filteredItems
                          .map((item) => _desktopTile(item))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${greetByHour()} ${user!.name} ${user!.lastName}!",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getRole(user!.userRole),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...filteredItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          item.icon,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () => _navigateTo(item),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _desktopTile(NavigationItem item) {
    return InkWell(
      onTap: () => _navigateTo(item),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(NavigationItem item) {
    if (item.name == AppStrings.dashboard) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(data: dashboardData)),
      );
    } else if (item.name == AppStrings.createReport) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CreateReport(user: user)),
      );
    } else if (item.name == AppStrings.reports) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AllReports(user: user!)),
      );
    } else if (item.name == AppStrings.registerCustomer) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CreateCustomer()),
      );
    } else if (item.name == AppStrings.customers) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AllCustomers()),
      );
    } else if (item.name == AppStrings.registerPurchase) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RegisterPurchase()),
      );
    } else if (item.name == AppStrings.purchases) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AllExpenses()));
    }
  }
}
