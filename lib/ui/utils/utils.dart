import 'package:flutter/material.dart';

import '../Model/SidebarItem.dart';

final List<SidebarItem> sidebarItems = [
  SidebarItem(
    icon: Icons.dashboard_outlined,
    title: 'Dashboard',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock,Icons.lock],
    submenus: ['ABC','Employees Role'],
  ),
  SidebarItem(
    icon: Icons.home_repair_service_outlined,
    title: 'Projects',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock, Icons.lock, Icons.lock],
    submenus: ['Short Service', 'Create Orders', 'Service Category'],
  ),
  SidebarItem(
    icon: Icons.people_alt_outlined,
    title: 'Clients',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock, Icons.lock, Icons.lock],
    submenus: ['Company', 'Individuals', 'Finance History'],
  ),
  SidebarItem(
    icon: Icons.person_pin_outlined,
    title: 'Employees',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock, Icons.lock],
    submenus: ['Finance', 'Bank Detail'],
  ),
  SidebarItem(
    icon: Icons.attach_money,
    title: 'Banking',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock, Icons.lock],
    submenus: ['Add payment method', 'Statement History'],
  ),
  SidebarItem(
    icon: Icons.auto_graph_sharp,
    title: 'Office Expenses',
    trailingIcon: Icons.lock,

    submenus: [
      'Fixed office expanse',
      'Office maintenance',
      'Office Supplies',
      'Miscellaneous',
      'Others',
    ],
    submenuIcons: [Icons.lock, Icons.lock, Icons.lock, Icons.lock, Icons.lock],
  ),
  SidebarItem(
    icon: Icons.notification_add_outlined,
    title: 'Notifications',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock, Icons.lock, Icons.lock],
    submenus: ['Inbox', 'System', 'Push'],
  ),
  SidebarItem(
    icon: Icons.file_download_done_sharp,
    title: 'Files Cash Flow',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock, Icons.lock],
    submenus: ['Download', 'Upload'],
  ),
  SidebarItem(
    icon: Icons.settings_outlined,
    title: 'Settings',
    trailingIcon: Icons.lock,
    submenuIcons: [Icons.lock, Icons.lock, Icons.lock],
    submenus: ['Preferences', 'Account', 'Security'],
  ),
];
