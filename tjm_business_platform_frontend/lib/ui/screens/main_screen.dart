import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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
        errorMessage = AppStrings.userNotFound;
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
    final isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Row(
          children: [
            if (isDesktop) ...[
              Text(
                "${greetByHour()} ${user!.name} ${user!.lastName}!",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 16),
              Text(
                "${getRole(user!.userRole)} |",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 16),
            ],
            Text(
              user!.email,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          if (!isDesktop)
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
      body: isDesktop
          ? _desktopLayout(context, filteredItems)
          : _mobileLayout(context, filteredItems),
    );
  }

  Widget _mobileLayout(
    BuildContext context,
    List<NavigationItem> filteredItems,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _headerCard(context),
        const SizedBox(height: 16),
        ...filteredItems.map((item) => _mobileTile(context, item)),
      ],
    );
  }

  Widget _mobileTile(BuildContext context, NavigationItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(
              item.icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(item.name),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _navigateTo(item),
        ),
      ),
    );
  }

  Widget _headerCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${greetByHour()} ${user!.name} ${user!.lastName}!",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(getRole(user!.userRole)),
          ],
        ),
      ),
    );
  }

  Widget _desktopLayout(
    BuildContext context,
    List<NavigationItem> filteredItems,
  ) {
    var colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        NavigationRail(
          extended: true,
          minExtendedWidth: 260,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedIndex: _selectedIndex,
          labelType: NavigationRailLabelType.none,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _navigateTo(filteredItems[index]);
          },
          destinations: filteredItems
              .map(
                (item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  label: Text(item.name),
                ),
              )
              .toList(),
          trailing: Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      auth.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colors.onSecondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            size: 20,
                            color: colors.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.logout,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _buildBody(filteredItems)),
      ],
    );
  }

  Widget _buildBody(List<NavigationItem> filteredItems) {
    if (_selectedIndex >= filteredItems.length) {
      return const Center(child: Text('Seleccione una opción'));
    }

    final selectedItem = filteredItems[_selectedIndex];

    switch (selectedItem.name) {
      case AppStrings.dashboard:
        return const DashboardScreen();
      case AppStrings.createReport:
        return CreateReport(user: user);
      case AppStrings.reports:
        return AllReports(user: user!);
      case AppStrings.registerCustomer:
        return CreateCustomer();
      case AppStrings.customers:
        return AllCustomers();
      case AppStrings.registerPurchase:
        return RegisterPurchase();
      case AppStrings.purchases:
        return AllExpenses();
      default:
        return Center(child: Text('Pantalla: ${selectedItem.name}'));
    }
  }

  void _navigateTo(NavigationItem item) {
    final isDesktop = MediaQuery.of(context).size.width > 850;

    if (!isDesktop) {
      if (item.name == AppStrings.dashboard) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AllExpenses()),
        );
      }
    }
  }
}
