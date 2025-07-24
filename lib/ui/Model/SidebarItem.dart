import 'package:flutter/material.dart';
class SidebarItem {
  final IconData icon;
  final String title;
  final IconData? trailingIcon;
  final List<String> submenus;
  final List<IconData>? submenuIcons;
// Add these:
  bool? isLocked; // For main menu toggle
  List<bool>? submenuLockStates; // For submenus toggle
  SidebarItem({
    required this.icon,
    required this.title,
    this.trailingIcon,
    this.submenus = const [],
    this.submenuIcons, // <-- NEW
  });
}
