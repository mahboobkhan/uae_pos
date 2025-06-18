import 'package:abc_consultant/ui/screens/banking/bank_payment_screen.dart';
import 'package:abc_consultant/ui/screens/banking/banking_screen.dart';
import 'package:abc_consultant/ui/screens/banking/statement_screen.dart';
import 'package:abc_consultant/ui/screens/client_screen/company_screen.dart';
import 'package:abc_consultant/ui/screens/client_screen/finance_screen.dart';
import 'package:abc_consultant/ui/screens/client_screen/individual_screen.dart';
import 'package:abc_consultant/ui/screens/employee/employee_screen.dart';
import 'package:abc_consultant/ui/screens/office/office_expense_screen.dart';
import 'package:abc_consultant/ui/screens/client_screen/client_main.dart';
import 'package:abc_consultant/ui/screens/services/create_orders.dart';
import 'package:abc_consultant/ui/screens/services/projects_screen.dart';
import 'package:abc_consultant/ui/screens/services/services_screen.dart';
import 'package:abc_consultant/ui/screens/setting/preferences_screen.dart';
import 'package:flutter/material.dart';
import '../Model/NavItem.dart';
import '../utils/utils.dart';
import 'dashboard/Dashboard.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SidebarLayout extends StatefulWidget {
  SidebarLayout({super.key});

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  bool isExpanded = true;
  NavItem selectedItem = NavItem.services;

  int _selectedSidebarIndex = -1;
  int _selectedSubmenuIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Header
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                // Brand icon with name below
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/home/ic_yahya_chodrary.svg',
                      height: 35,
                    ),
                    SizedBox(height: 2),
                  ],
                ),
                const SizedBox(width: 24),
                // Centered Search bar with button
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        child: const TextField(
                          textAlign: TextAlign.left, // horizontal alignment
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // User info right side
                Row(
                  children: const [
                    Text('Profile', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Row
          Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isExpanded ? 230 : 70,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            isExpanded ? Icons.arrow_back_ios : Icons.menu,
                          ),
                          onPressed:
                              () => setState(() => isExpanded = !isExpanded),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: sidebarItems.length,
                          itemBuilder: (context, index) {
                            final item = sidebarItems[index];
                            final isSelected = _selectedSidebarIndex == index;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedSidebarIndex =
                                          (_selectedSidebarIndex == index)
                                              ? -1
                                              : index;
                                      _selectedSubmenuIndex = -1;
                                      selectedItem = NavItem.values[index];
                                    });
                                  },
                                  child: Container(
                                    color:
                                        isSelected
                                            ? Colors.red.shade50
                                            : Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          item.icon,
                                          color:
                                              isSelected
                                                  ? Colors.red
                                                  : Colors.black,
                                          size: 18,
                                        ),
                                        if (isExpanded) ...[
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: TextStyle(
                                                color:
                                                    isSelected
                                                        ? Colors.red
                                                        : Colors.black,
                                                fontSize: 12,
                                                fontWeight:
                                                    isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          if (item.submenus.isNotEmpty)
                                            Icon(
                                              isSelected
                                                  ? Icons.keyboard_arrow_down
                                                  : Icons.keyboard_arrow_right,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                if (isSelected && isExpanded)
                                  ...List.generate(item.submenus.length, (i) {
                                    final submenu = item.submenus[i];
                                    final submenuSelected =
                                        _selectedSubmenuIndex == i;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 40,
                                        top: 4,
                                        bottom: 4,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(
                                            () => _selectedSubmenuIndex = i,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          child: Text(
                                            submenu,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  submenuSelected
                                                      ? Colors.red
                                                      : Colors.black,
                                              fontWeight:
                                                  submenuSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                    child: _buildScreenFor(selectedItem),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Footer
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.white,
            alignment: Alignment.center,
            child: const Text(
              '© 2025 Your Company Name',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenFor(NavItem item) {
    if (_selectedSubmenuIndex != -1) {
      final submenu = sidebarItems[item.index].submenus[_selectedSubmenuIndex];
      return _buildSubmenuScreen(item, submenu);
    }

    switch (item) {
      case NavItem.dashboard:
        return Center(child: DashboardScreen());
      case NavItem.services:
        return Center(child: ServicesScreen());
      case NavItem.clients:
        return Center(child: ClientMain());
      case NavItem.employees:
        return Center(child: EmployeeScreen());
      case NavItem.banking:
        return Center(child: BankingScreen());
      case NavItem.expenses:
        return Center(child: OfficeExpenseScreen());
      case NavItem.notifications:
        return const Center(child: Text('Notifications Screen'));
      case NavItem.files:
        return const Center(child: Text('Files Screen'));
      case NavItem.settings:
        return const Center(child: Text('Settings Screen'));
    }
  }

  Widget _buildSubmenuScreen(NavItem parent, String submenu) {
    switch (parent) {
      case NavItem.dashboard:
        switch (submenu) {
          case 'Overview':
            return const Center(child: Text('Dashboard > Overview'));
          case 'Stats':
            return const Center(child: Text('Dashboard > Stats'));
        }
        break;
      case NavItem.services:
        switch (submenu) {
          case 'Short Service':
            return const Center(child: Text('Services > Short Service'));
          case 'Projects':
            return const Center(child: ProjectsScreen());
          case 'Create Orders':
            return const Center(child: CreateOrders());
        }
        break;
      case NavItem.clients:
        switch (submenu) {
          case 'Company':
            return const Center(child: CompanyScreen());
          case 'Individuals':
            return const Center(child: IndividualScreen());
          case 'Finance History':
            return const Center(child: FinanceScreen());
        }
        break;
      case NavItem.employees:
        switch (submenu) {
          case 'Finance':
            return const Center(child: Text('Employees > Finance'));
          case 'Bank Detail':
            return const Center(child: Text('Employees > Bank Detail'));
        }
        break;
      case NavItem.banking:
        switch (submenu) {
          case 'Add payment method':
            return Center(child: BankPaymentScreen());
          case 'Statement History':
            return const Center(child: StatementScreen());
        }
        break;
      case NavItem.expenses:
        switch (submenu) {
          case 'Fixed office expanse':
            return const Center(child: Text('Expenses > Fixed office expanse'));
          case 'Office maintenance':
            return const Center(child: Text('Expenses > Office maintenance'));
          case 'Office Supplies':
            return const Center(child: Text('Expenses > Office Supplies'));
          case 'Miscellaneous':
            return const Center(child: Text('Expenses > Miscellaneous'));
          case 'Others':
            return const Center(child: Text('Expenses > Others'));
        }
        break;
      case NavItem.notifications:
        switch (submenu) {
          case 'Inbox':
            return const Center(child: Text('Notifications > Inbox'));
          case 'System':
            return const Center(child: Text('Notifications > System'));
          case 'Push':
            return const Center(child: Text('Notifications > Push'));
        }
        break;
      case NavItem.files:
        switch (submenu) {
          case 'Download':
            return const Center(child: Text('Files > Download'));
          case 'Upload':
            return const Center(child: Text('Files > Upload'));
        }
        break;
      case NavItem.settings:
        switch (submenu) {
          case 'Preferences':
            return const Center(child: PreferencesScreen());
          case 'Account':
            return const Center(child: Text('Settings > Account'));
          case 'Security':
            return const Center(child: Text('Settings > Security'));
        }
        break;
    }
    return const Center(child: Text('Unknown Submenu'));
  }
}
