import 'package:abc_consultant/ui/screens/banking/bank_payment_screen.dart';
import 'package:abc_consultant/ui/screens/banking/banking_screen.dart';
import 'package:abc_consultant/ui/screens/banking/statement_screen.dart';
import 'package:abc_consultant/ui/screens/client_screen/client_main.dart';
import 'package:abc_consultant/ui/screens/client_screen/company_screen.dart';
import 'package:abc_consultant/ui/screens/client_screen/finance_screen.dart';
import 'package:abc_consultant/ui/screens/client_screen/individual_screen.dart';
import 'package:abc_consultant/ui/screens/dashboard/abc_screen.dart';
import 'package:abc_consultant/ui/screens/dashboard/employees_role_screen.dart';
import 'package:abc_consultant/ui/screens/employee/bank_detail_screen.dart';
import 'package:abc_consultant/ui/screens/employee/employee_finance.dart';
import 'package:abc_consultant/ui/screens/employee/employee_screen.dart';
import 'package:abc_consultant/ui/screens/office/dynamic_atttribute_addition.dart';
import 'package:abc_consultant/ui/screens/office/fixed_office_expense.dart';
import 'package:abc_consultant/ui/screens/office/office_expense_screen.dart';
import 'package:abc_consultant/ui/screens/office/office_maintainance_expanse.dart';
import 'package:abc_consultant/ui/screens/office/office_miscellaneous.dart';
import 'package:abc_consultant/ui/screens/office/office_supplies_expanse.dart';
import 'package:abc_consultant/ui/screens/projects/create_orders.dart';
import 'package:abc_consultant/ui/screens/projects/project_screen.dart';
import 'package:abc_consultant/ui/screens/projects/create_order_dialog.dart';
import 'package:abc_consultant/ui/screens/projects/service_categories.dart';
import 'package:abc_consultant/ui/screens/projects/short_service_screen.dart';
import 'package:abc_consultant/ui/screens/setting/preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Model/NavItem.dart';
import '../dialogs/custom_dialoges.dart';
import '../utils/utils.dart';
import 'dashboard/Dashboard.dart';

class SidebarLayout extends StatefulWidget {
  SidebarLayout({super.key});

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  bool isExpanded = true;
  NavItem selectedItem = NavItem.banking;

  int _selectedSidebarIndex = 4;
  int _selectedSubmenuIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
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
                      ),
                      const SizedBox(width: 8),
                      Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // User info right side
                GestureDetector(
                  onTap: (){
                    showProfileDialog(context); // This is correct
                  },
                  child: Card(
                    elevation: 8,
                    shape: const CircleBorder(),
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),

              ],
            ),
          ),

          // Content Row
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child:
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isExpanded ? 230 : 86,
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
                                              if (item.trailingIcon != null)
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Icon(
                                                    item.trailingIcon,
                                                    size: 16,
                                                    color:  Colors.red ,
                                                  ),
                                                ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isSelected && isExpanded)
                                      ...List.generate(item.submenus.length, (i) {
                                        final submenu = item.submenus[i];
                                        final submenuSelected = _selectedSubmenuIndex == i;
                                        final submenuIcon = (item.submenuIcons!.length > i) ? item.submenuIcons![i] : null;

                                        return Padding(
                                          padding: const EdgeInsets.only(left: 40, top: 4, bottom: 4, right: 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() => _selectedSubmenuIndex = i);
                                            },
                                            child: Container(
                                              height: 40,
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  // Submenu title
                                                  Expanded(
                                                    child: Text(
                                                      submenu,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: submenuSelected ? Colors.red : Colors.black,
                                                        fontWeight: submenuSelected ? FontWeight.bold : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),

                                                  // Lock icon aligned to far right
                                                  if (submenuIcon != null)
                                                    Icon(
                                                      submenuIcon,
                                                      size: 16,
                                                      color: Colors.red,
                                                    ),
                                                ],
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
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.logout),
                      ),
                    )

                  ],
                ),
/*
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isExpanded ? 230 : 86,
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
                                          if (item.trailingIcon != null)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Icon(
                                                item.trailingIcon,
                                                size: 16,
                                                color:  Colors.red ,
                                              ),
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                if (isSelected && isExpanded)
                                  ...List.generate(item.submenus.length, (i) {
                                    final submenu = item.submenus[i];
                                    final submenuSelected = _selectedSubmenuIndex == i;
                                    final submenuIcon = (item.submenuIcons!.length > i) ? item.submenuIcons![i] : null;

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 40, top: 4, bottom: 4, right: 16),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => _selectedSubmenuIndex = i);
                                        },
                                        child: Container(
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              // Submenu title
                                              Expanded(
                                                child: Text(
                                                  submenu,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: submenuSelected ? Colors.red : Colors.black,
                                                    fontWeight: submenuSelected ? FontWeight.bold : FontWeight.normal,
                                                  ),
                                                ),
                                              ),

                                              // Lock icon aligned to far right
                                              if (submenuIcon != null)
                                                Icon(
                                                  submenuIcon,
                                                  size: 16,
                                                  color: Colors.red,
                                                ),
                                            ],
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
*/
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
          /*Container(
            color: Colors.white,
            width: double.infinity,
            child:Row(
              children: [
                // Expanded center with text
                Expanded(
                  child: Center(
                    child: Text(
                      '© 2025 Your Company Name',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
                // Icon on the far right
               *//* GestureDetector(
                  onTap: (){
                    showProfileDialog(context); // This is correct
                  },
                  child: Card(
                    elevation: 8,
                    shape: const CircleBorder(),
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 12,)*//*
              ],
            ),
          ),*/
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
      case NavItem.projects:
        return Center(
          child: ProjectScreen(
            onNavigateToCreateOrder: () {
              setState(() {
                selectedItem = NavItem.projects;
                _selectedSubmenuIndex = 2;
              });
            },
          ),
        );
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
          case 'ABC':
            return const  Center(child: AbcScreen());
          case 'Employees Role':
            return const  Center(child: EmployeesRoleScreen());
        }
        break;
      case NavItem.projects:
        switch (submenu) {
          case 'Short Service':
            return const Center(child: ShortServiceScreen());
          case 'Create Orders':
            return const Center(child: CreateOrders());
          case 'Service Category':
            return const Center(child:ServiceCategories());
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
            return const Center(child: EmployeeFinance());
          case 'Bank Detail':
            return const Center(child: BankDetailScreen());
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
            return const Center(child: FixedOfficeExpense());
          case 'Office maintenance':
            return const Center(child: MaintainanceOfficeExpense());
          case 'Office Supplies':
            return const Center(child: OfficeSuppliesExpanse());
          case 'Miscellaneous':
            return const Center(child: OfficeMiscellaneous());
          case 'Others':
            return const Center(child: DynamicAttributeAddition());
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
