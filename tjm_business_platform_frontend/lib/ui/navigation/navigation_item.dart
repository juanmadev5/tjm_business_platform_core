import 'package:flutter/material.dart';
import 'package:tjm_business_platform_logic/core/role.dart';

class NavigationItem {
  final String name;
  final IconData icon;
  final List<Role> roles;

  NavigationItem({required this.name, required this.icon, required this.roles});
}
