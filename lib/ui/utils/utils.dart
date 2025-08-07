import 'package:flutter/material.dart';

import '../Model/SidebarItem.dart';

final List<SidebarItem> sidebarItems = [
  SidebarItem(
    icon: Icons.dashboard_outlined,
    title: 'Dashboard',
    accessKey: 'dashboard',
    submenus: ['ABC','Employees Role'],
    submenuKeys: ['abc','employees_role']
  ),
  SidebarItem(
    icon: Icons.home_repair_service_outlined,
    title: 'Projects',
    accessKey: 'projects',
    submenus: ['Short Service', 'Create Orders', 'Service Category'],
    submenuKeys: ['short_service', 'create_orders','service_category']
  ),
  SidebarItem(
    icon: Icons.people_alt_outlined,
    title: 'Clients',
    accessKey: 'clients',
    submenuKeys: ['company', 'individuals', 'finance_history'],
    submenus: ['Company', 'Individuals', 'Finance History'],
  ),
  SidebarItem(
    icon: Icons.person_pin_outlined,
    title: 'Employees',
    accessKey: 'employees',
    submenuKeys: ['finance','bank_detail'],
    submenus: ['Finance History', 'Bank Detail'],
  ),
  SidebarItem(
    icon: Icons.attach_money,
    title: 'Banking',
    accessKey: 'banking',  submenuKeys: ['add_payment_method', 'statement_history'],
    submenus: ['Add payment method', 'Statement History'],
  ),
  SidebarItem(
    icon: Icons.auto_graph_sharp,
    title: 'Office Expenses',
    submenuKeys: [
      'fixed_office_expanse',
      'office_maintenance',
      'office_supplies',
      'miscellaneous',
      'others'
    ],
    accessKey: 'office_expenses',

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
    submenuKeys: ['inbox', 'system', 'push'],
    accessKey: 'notifications',

    submenus: ['Inbox', 'System', 'Push'],
  ),
  SidebarItem(
    icon: Icons.file_download_done_sharp,
    title: 'Files Cash Flow',
    submenuKeys: ['download', 'upload'],
    accessKey: 'files_cash_flow',

    submenus: ['Download', 'Upload'],
  ),
  SidebarItem(
    icon: Icons.settings_outlined,
    title: 'Settings',
    accessKey: 'settings',
    submenuKeys: ['preferences', 'account', 'security'],
    submenus: ['Preferences', 'Account', 'Security'],
  ),
];



final List<SidebarItem> sidebarItemsAccess = [
  SidebarItem(
    icon: Icons.dashboard_outlined,
    title: 'Dashboard',
    accessKey: 'dashboard',
    submenus: ['ABC','Employees Role'],
    submenuKeys: ['abc','employees_role']
  ),
  SidebarItem(
    icon: Icons.home_repair_service_outlined,
    title: 'Projects',
    accessKey: 'projects',
    submenus: ['Short Service', 'Create Orders', 'Service Category'],
    submenuKeys: ['short_service', 'create_orders','service_category']
  ),
  SidebarItem(
    icon: Icons.people_alt_outlined,
    title: 'Clients',
    accessKey: 'clients',
    submenuKeys: ['company', 'individuals', 'finance_history'],
    submenus: ['Company', 'Individuals', 'Finance History'],
  ),
  SidebarItem(
    icon: Icons.person_pin_outlined,
    title: 'Employees',
    accessKey: 'employees',
    submenuKeys: ['finance','bank_detail'],
    submenus: ['Finance History', 'Bank Detail'],
  ),
  SidebarItem(
    icon: Icons.attach_money,
    title: 'Banking',
    accessKey: 'banking',  submenuKeys: ['add_payment_method', 'statement_history'],
    submenus: ['Add payment method', 'Statement History'],
  ),
  SidebarItem(
    icon: Icons.auto_graph_sharp,
    title: 'Office Expenses',
    submenuKeys: [
      'fixed_office_expanse',
      'office_maintenance',
      'office_supplies',
      'miscellaneous',
      'others'
    ],
    accessKey: 'office_expenses',


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
    submenuKeys: ['inbox', 'system', 'push'],
    accessKey: 'notifications',

    submenus: ['Inbox', 'System', 'Push'],
  ),
  SidebarItem(
    icon: Icons.file_download_done_sharp,
    title: 'Files Cash Flow',
    submenuKeys: ['download', 'upload'],
    accessKey: 'files_cash_flow',

    submenus: ['Download', 'Upload'],
  ),
  SidebarItem(
    icon: Icons.settings_outlined,
    title: 'Settings',
    accessKey: 'settings',
    submenuKeys: ['preferences', 'account', 'security'],
    submenus: ['Preferences', 'Account', 'Security'],
  ),
];
