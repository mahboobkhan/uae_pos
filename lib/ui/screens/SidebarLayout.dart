import 'dart:convert';

import 'package:abc_consultant/providers/signup_provider.dart';
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
import 'package:abc_consultant/ui/screens/login%20screens/log_screen.dart';
import 'package:abc_consultant/ui/screens/office/dynamic_atttribute_addition.dart';
import 'package:abc_consultant/ui/screens/office/fixed_office_expense.dart';
import 'package:abc_consultant/ui/screens/office/office_expense_screen.dart';
import 'package:abc_consultant/ui/screens/office/office_maintainance_expanse.dart';
import 'package:abc_consultant/ui/screens/office/office_miscellaneous.dart';
import 'package:abc_consultant/ui/screens/office/office_supplies_expanse.dart';
import 'package:abc_consultant/ui/screens/projects/create_orders.dart';
import 'package:abc_consultant/ui/screens/projects/project_screen.dart';
import 'package:abc_consultant/ui/screens/projects/service_categories.dart';
import 'package:abc_consultant/ui/screens/projects/short_service_screen.dart';
import 'package:abc_consultant/ui/screens/setting/preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_colors.dart';
import '../Model/NavItem.dart';
import '../dialogs/custom_fields.dart';
import '../dialogs/profile_dialog.dart';
import '../utils/utils.dart';
import 'dashboard/Dashboard.dart';
import 'links/links_screen.dart';

class SidebarLayout extends StatefulWidget {
  final NavItem? initialItem;
  final int? initialSubmenuIndex;
  final bool showPinDialog;

  SidebarLayout({super.key, this.initialItem, this.initialSubmenuIndex, this.showPinDialog = true});

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  int screen = 0;

  bool isExpanded = true;
  NavItem selectedItem = NavItem.dashboard;

  int _selectedSidebarIndex = 0;
  int _selectedSubmenuIndex = 0;

  @override
  void initState() {
    super.initState();

    _loadUserIdAndFetchAccess();
    
    // Show PIN verification dialog after the screen loads (if enabled)
    if (widget.showPinDialog == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPinVerificationDialog();
      });
    }

    // Initialize selected item/submenu from constructor, if provided
    if (widget.initialItem != null) {
      selectedItem = widget.initialItem!;
      _selectedSidebarIndex = selectedItem.index;
    }
    if (widget.initialSubmenuIndex != null) {
      _selectedSubmenuIndex = widget.initialSubmenuIndex!;
    } else {
      _selectedSubmenuIndex = -1;
    }
  }

  Future<void> _loadUserIdAndFetchAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('user_id');

    if (storedUserId != null && storedUserId.isNotEmpty) {
      final accessProvider = Provider.of<SignupProvider>(context, listen: false);

      await accessProvider.fetchUserAccess(storedUserId);

      updateSidebarAccess(accessProvider.accessMap);

      setState(() {}); // rebuild sidebar with updated lock states
    } else {
      debugPrint("⚠ No user_id found in SharedPreferences");
    }
  }

  void updateSidebarAccess(Map<String, bool> accessMap) {
    for (final item in sidebarItems) {
      item.isLocked = !(accessMap[item.accessKey] ?? false);

      item.submenuLockStates = item.submenuKeys.map((key) => !(accessMap[key] ?? false)).toList();
    }
  }

  void loadAccessFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final accessString = prefs.getString('access');

    if (accessString != null) {
      final access = jsonDecode(accessString);
      print('Access object: $access');

      // Example: print specific keys if it's a Map
      if (access is Map<String, dynamic>) {}
    } else {
      print('No access key found in SharedPreferences');
    }
  }

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
                    SvgPicture.asset('assets/images/home/ic_yahya_chodrary.svg', height: 35),
                    SizedBox(height: 2),
                  ],
                ),
                const SizedBox(width: 24),
                // Centered Search bar with button
                Spacer(),
                /*Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     *//* Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                        elevation: 4,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30)),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),*//*
                    ],
                  ),
                ),*/
                // User info right side
                GestureDetector(
                  onTap: () {
                    showProfileDialog(context); // This is correct
                  },
                  child: Card(
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.redColor,
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
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isExpanded ? 230 : 86,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(isExpanded ? Icons.arrow_back_ios : Icons.menu),
                                onPressed: () => setState(() => isExpanded = !isExpanded),
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
                                            _selectedSidebarIndex = (_selectedSidebarIndex == index) ? -1 : index;
                                            _selectedSubmenuIndex = -1;
                                            selectedItem = NavItem.values[index];
                                          });
                                        },
                                        child: Container(
                                          color: isSelected ? Colors.red.shade50 : Colors.transparent,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                          child: Row(
                                            children: [
                                              Icon(item.icon, color: isSelected ? AppColors.redColor : Colors.black, size: 18),
                                              if (isExpanded) ...[
                                                const SizedBox(width: 20),
                                                Expanded(
                                                  child: Text(
                                                    item.title,
                                                    style: TextStyle(
                                                      color: isSelected ? AppColors.redColor : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                                if (item.submenus.isNotEmpty)
                                                  Icon(
                                                    isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                // Show lock only if locked
                                               /* if (item.isLocked == true)
                                                  const Icon(Icons.lock, size: 16, color: AppColors.redColor),
                                              */],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isSelected && isExpanded)
                                        ...List.generate(item.submenus.length, (i) {
                                          final submenu = item.submenus[i];
                                          final submenuSelected = _selectedSubmenuIndex == i;
                                          final isSubmenuLocked =
                                              item.submenuLockStates != null && item.submenuLockStates!.length > i
                                                  ? item.submenuLockStates![i]
                                                  : false;

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
                                                          color: submenuSelected ? AppColors.redColor : Colors.black,
                                                          fontWeight:
                                                              submenuSelected ? FontWeight.bold : FontWeight.normal,
                                                        ),
                                                      ),
                                                    ),

                                                    // Lock icon aligned to far right
                                                    // Lock icon for submenu
                                                    if (isSubmenuLocked)
                                                      const Icon(Icons.lock, size: 16, color: AppColors.redColor),
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
                    HoverLogoutButton(
                      width: 40,
                      height: 40,
                      iconSize: 25,
                      defaultColor: Colors.green,
                      hoverColor: AppColors.redColor,
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogScreen()));
                      },
                    ),
                  ],
                ),
                Expanded(child: Container(color: Colors.grey.shade100, child: _buildScreenFor(selectedItem))),
              ],
            ),
          ),

          // Bottom Footer
        ],
      ),
    );
  }

  Widget _buildScreenFor(NavItem item) {
    if (_selectedSubmenuIndex != -1) {
      final submenu = sidebarItems[item.index].submenus[_selectedSubmenuIndex];
      final isLocked = sidebarItems[item.index].submenuLockStates?[_selectedSubmenuIndex] ?? true;

      if (isLocked) {
        return const AbcScreen();
      }

      return _buildSubmenuScreen(item, submenu);
    }

    // For main menu access check
    final isLocked = sidebarItems[item.index].isLocked ?? true;
    if (isLocked) {
      return const AbcScreen();
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
        return const Center(child: PreferencesScreen());
      case NavItem.links:
        return const Center(child: Text('Links Screen'));
      case NavItem.settings:
        return const Center(child: Text('Settings Screen'));
    }
  }

  Widget _buildSubmenuScreen(NavItem parent, String submenu) {
    switch (parent) {
      case NavItem.dashboard:
        switch (submenu) {
          case 'ABC':
            return const Center(child: AbcScreen());
          case 'Employees Role':
            return const Center(child: EmployeesRoleScreen());
        }
        break;
      case NavItem.projects:
        switch (submenu) {
          case 'Short Service':
            return const Center(child: ShortServiceScreen());
          case 'Create Orders':
            return const Center(child: CreateOrders());
          case 'Service Category':
            return const Center(child: ServiceCategories());
        }
        break;
      case NavItem.clients:
        switch (submenu) {
          case 'Establishment':
            return const Center(child: CompanyScreen());
          case 'Individuals':
            return const Center(child: IndividualScreen());
          case 'Finance History':
            return const Center(child: FinanceScreen());
        }
        break;
      case NavItem.employees:
        switch (submenu) {
          case 'Finance History':
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
            return const Center(child: LinksScreen());
          case 'Upload':
            return const Center(child: Text('Files > Upload'));
        }
        break;
      case NavItem.links:
        break;
      case NavItem.settings:
        switch (submenu) {
          case 'Preferences':
            return const Center(child: Text('Settings > Preferences'));
          case 'Account':
            return const Center(child: Text('Settings > Account'));
          case 'Security':
            return const Center(child: Text('Settings > Security'));
        }
        break;
    }
    return const Center(child: Text('Unknown Submenu'));
  }

  /// Show PIN verification dialog on home screen
  Future<void> _showPinVerificationDialog() async {
    final TextEditingController verificationController = TextEditingController();

    // Get the saved PIN from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('pin') ?? '1234'; // Default fallback

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Home Screen Verification",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please enter your 4-digit PIN to access the home screen",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: verificationController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, letterSpacing: 8),
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                    hintText: '',
                    border: OutlineInputBorder(),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 4) {
                      // Auto-verify when 4 digits are entered
                      if (value == savedPin) {
                        Navigator.of(context).pop();
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("PIN verified successfully! Welcome to home screen."),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid PIN. Please try again."),
                            backgroundColor: AppColors.redColor,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        verificationController.clear();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Go back to login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogScreen()),
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                final enteredCode = verificationController.text.trim();
                if (enteredCode == savedPin) {
                  Navigator.of(context).pop();
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("PIN verified successfully! Welcome to home screen."),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid PIN. Please try again."),
                      backgroundColor: AppColors.redColor,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  verificationController.clear();
                }
              },
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
