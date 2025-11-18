import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/ui/model/dashboard_data_model.dart';
import 'package:tjm_business_platform/ui/navigation/navigation_item.dart';
import 'package:tjm_business_platform/ui/navigation/navigation_items_provider.dart';
import 'package:tjm_business_platform/ui/screens/create_report.dart';
import 'package:tjm_business_platform/ui/screens/dashboard_screen.dart';
import 'package:tjm_business_platform/ui/screens/login_screen.dart';
import 'package:tjm_business_platform/ui/utils/get_role.dart';
import 'package:tjm_business_platform/ui/utils/greet_by_hour.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/core/role.dart';
import 'package:tjm_business_platform_logic/domain/auth.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int screenIndex = 0;
  final Data data = Data();
  final Auth auth = Auth();

  List<Role> assignedRoles = [];
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
    var totalIncome = await data.getTotalIncome();
    var totalExpenses = await data.getTotalExpenses();
    var netProfit = await data.getNetProfit();
    var totalReports = await data.getAllReports();
    var totalCustomers = await data.getAllCustomers();
    var totalRep = totalReports.length;
    var totalCust = totalCustomers.length;

    final dashbData = DashboardDataModel(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netProfit: netProfit,
      totalReports: totalRep,
      totalCustomers: totalCust,
    );

    setState(() {
      dashboardData = dashbData;
    });
  }

  Future<void> _loadUserProfile() async {
    setState(() => isLoading = true);
    try {
      final profile = await auth.getUserProfile();
      if (!mounted) return;

      if (profile == null) {
        setState(() {
          isLoading = false;
          errorMessage = AppStrings.userNotFound;
        });
        return;
      }

      setState(() {
        user = profile;
        assignedRoles = [profile.userRole];
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
    List<NavigationItem> items = NavigationItemsProvider.items();
    final userRole = user!.userRole;

    final filteredItems = items.where((item) {
      return item.roles.contains(userRole);
    }).toList();

    if (isLoading) {
      return Scaffold(body: Center(child: Text(AppStrings.loading)));
    }
    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          user!.email,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 4,
              ),
              child: Text(
                "${greetByHour()} ${user!.name} ${user!.lastName}!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 4,
                bottom: 16,
              ),
              child: Text(
                getRole(user!.userRole),
                style: TextStyle(fontSize: 14),
              ),
            ),
            ...filteredItems.map((item) {
              return ListTile(
                leading: Icon(item.icon),
                title: Text(item.name),
                onTap: () {
                  if (item.name == AppStrings.dashboard) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DashboardScreen(data: dashboardData),
                      ),
                    );
                  } else if (item.name == AppStrings.createReport) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateReport(user: user),
                      ),
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
