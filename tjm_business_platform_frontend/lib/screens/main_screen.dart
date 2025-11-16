import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_settings.dart';
import 'package:tjm_business_platform/core/model/app_destination_item.dart';
import 'package:tjm_business_platform/core/strings.dart';
import 'package:tjm_business_platform/data/model/user.dart';
import 'package:tjm_business_platform/data/provider.dart';
import 'package:tjm_business_platform/data/state/role/role.dart';
import 'package:tjm_business_platform/screens/destinations/destinations_provider.dart';
import 'package:tjm_business_platform/screens/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Provider provider = Provider();
  int screenIndex = 0;
  List<Role> asignedRole = [Role.admin];

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  List<NavigationRailDestination> getNavItems() {
    final userRoles = provider.getCurrentRole();

    final filteredItems = DestinationsProvider.destinations().where(
      (dest) => dest.asignedForRole.any((role) => userRoles.contains(role)),
    );

    return filteredItems.map((AppDestinationItem destination) {
      return NavigationRailDestination(
        label: Text(destination.label, textAlign: TextAlign.center),
        icon: destination.icon,
        selectedIcon: destination.selectedIcon,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    PlatformUser user = Provider().getUserData();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          "${user.name} - ${user.email}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  provider.logout();
                },
                child: Text(AppStrings.logOut),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            appNavigationRail(),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DestinationsProvider.setView(screenIndex, provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding appNavigationRail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: NavigationRail(
        labelType: AppSettings.labelType,
        destinations: getNavItems(),
        selectedIndex: screenIndex,
        useIndicator: true,
        onDestinationSelected: (int index) {
          handleScreenChanged(index);
        },
      ),
    );
  }
}
