import 'package:flutter/material.dart';
import 'package:tjm_business_platform/data/state/role/role.dart';

class AppDestinationItem {
  const AppDestinationItem(this.label, this.icon, this.selectedIcon, this.asignedForRole);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final List<Role> asignedForRole;
}
