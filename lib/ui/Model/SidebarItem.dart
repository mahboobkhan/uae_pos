import 'package:flutter/cupertino.dart';

class SidebarItem {
  final IconData icon;
  final String title;
  final List<String> submenus;

  SidebarItem({
    required this.icon,
    required this.title,
    this.submenus = const [],
  });
}
