import 'package:flutter/material.dart';

import '../Model/SidebarItem.dart';

final List<SidebarItem> sidebarItems = [
  SidebarItem(
    icon: Icons.dashboard_outlined,
    title: 'Dashboard',
    submenus: ['Overview', 'Stats'],
  ),
  SidebarItem(
    icon: Icons.home_repair_service_outlined,
    title: 'Services',
    submenus: ['Short Service', 'Projects', 'Create Orders'],
  ),
  SidebarItem(
    icon: Icons.people_alt_outlined,
    title: 'Clients',
    submenus: ['Company', 'Individuals', 'Finance History'],
  ),
  SidebarItem(
    icon: Icons.person_pin_outlined,
    title: 'Employees',
    submenus: ['Finance', 'Bank Detail'],
  ),
  SidebarItem(
    icon: Icons.attach_money,
    title: 'Banking',
    submenus: ['Add payment method', 'Statement History'],
  ),
  SidebarItem(
    icon: Icons.auto_graph_sharp,
    title: 'Office Expenses',
    submenus: [
      'Fixed office expanse',
      'Office maintenance',
      'Office Supplies',
      'Miscellaneous',
      'Others',
    ],
  ),
  SidebarItem(
    icon: Icons.notification_add_outlined,
    title: 'Notifications',
    submenus: ['Inbox', 'System', 'Push'],
  ),
  SidebarItem(
    icon: Icons.file_download_done_sharp,
    title: 'Files Cash Flow',
    submenus: ['Download', 'Upload'],
  ),
  SidebarItem(
    icon: Icons.settings_outlined,
    title: 'Settings',
    submenus: ['Preferences', 'Account', 'Security'],
  ),
];
