import 'package:flutter/material.dart';
class SidebarItem {
  final IconData icon;
  final String title;
  final String accessKey;
  final List<String> submenus;
  final List<String> submenuKeys;
// Add these:
  bool? isLocked; // For main menu toggle
  List<bool>? submenuLockStates; // For submenus toggle
  SidebarItem({
    required this.icon,
    required this.title,
    required this.accessKey,
    this.submenus = const [],
    this.submenuKeys = const [],
  });
}
