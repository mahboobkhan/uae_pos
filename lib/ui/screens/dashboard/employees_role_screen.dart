import 'package:abc_consultant/providers/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../employee/EmployeeProvider.dart';
import '../../../employee/employee_models.dart';
import '../../../utils/app_colors.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../utils/utils.dart';

class EmployeesRoleScreen extends StatefulWidget {
  const EmployeesRoleScreen({super.key});

  @override
  State<EmployeesRoleScreen> createState() => _EmployeesRoleScreenState();
}

class _EmployeesRoleScreenState extends State<EmployeesRoleScreen> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String? selectedService;

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  bool _isHovering = false;

  final List<String> categories = ['All', 'Active', 'Blocked'];
  String? selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<EmployeeProvider>(context, listen: false).getFullData());
  }

  // Get filtered employees based on selected filters
  List<Employee> getFilteredEmployees(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return [];
    }

    return provider.employees!.where((employee) {
      // Exclude Admin designation from list
      if (employee.empDesignation == 'Admin') {
        return false;
      }
      // Filter by employee status (Active/Blocked)
      if (selectedCategory == 'Active' && employee.isUserActive != 1) {
        return false;
      }
      if (selectedCategory == 'Blocked' && employee.isUserActive != 0) {
        return false;
      }

      return true;
    }).toList();
  }

  List<String> getUniqueDesignations(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return ['All'];
    }

    final designations =
        provider.employees!
            .map((e) => e.empDesignation)
            .where((designation) => designation.isNotEmpty)
            .toSet()
            .toList();

    return ['All', ...designations];
  }

  @override
  Widget build(BuildContext context) {
    //  final designation = context.watch<DesignationProvider>().getDesignation();
    //  final provider = Provider.of<SignupProvider>(context);
    return SafeArea(
      child: Consumer<EmployeeProvider>(
        builder: (ctx, employeeProvider, _) {
          if (employeeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (employeeProvider.error != null) {
            return Center(child: Text("Error: ${employeeProvider.error}"));
          }

          if (employeeProvider.data == null) {
            return const Center(child: Text("No data available."));
          }
          // Get filtered employees based on selected filters
          final filteredEmployees = getFilteredEmployees(employeeProvider);

          // Debug: Print filter information
          print("=== FILTER DEBUG ===");
          print("Selected Category: $selectedCategory");
          print("Total Employees: ${employeeProvider.employees?.length ?? 0}");
          print("Filtered Employees: ${filteredEmployees.length}");
          print("Active Employees: ${employeeProvider.employees?.where((e) => e.isUserActive == 1).length ?? 0}");
          print("Blocked Employees: ${employeeProvider.employees?.where((e) => e.isUserActive == 0).length ?? 0}");

          if (filteredEmployees.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No employees match the selected filters',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try changing your filter criteria or clear the filter',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedCategory = 'All';
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Show All Employees'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHovering = true),
                      onExit: (_) => setState(() => _isHovering = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow:
                              _isHovering
                                  ? [
                                    BoxShadow(
                                      color: Colors.blue,
                                      blurRadius: 3,
                                      spreadRadius: 0.1,
                                      offset: Offset(0, 1),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CustomDropdown(
                                      selectedValue: selectedCategory,
                                      hintText: "Status",
                                      items: categories,
                                      onChanged: (newValue) {
                                        setState(() => selectedCategory = newValue!);
                                        print("Filter changed to: $newValue");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Filter summary
                    /*
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Showing ${filteredEmployees.length} of ${employeeProvider.employees?.length ?? 0} employees",
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (selectedCategory != 'All')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: selectedCategory == 'Active' ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedCategory == 'Active' ? Colors.green.shade300 : Colors.red.shade300,
                                ),
                              ),
                              child: Text(
                                selectedCategory == 'Active' ? '🟢 Active Users' : '🔴 Blocked Users',
                                style: TextStyle(
                                  color: selectedCategory == 'Active' ? Colors.green.shade800 : Colors.red.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
*/
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbVisibility: MaterialStateProperty.all(true),
                            thumbColor: MaterialStateProperty.all(Colors.grey),
                            thickness: MaterialStateProperty.all(8),
                            radius: const Radius.circular(4),
                          ),
                          child: Scrollbar(
                            controller: _verticalController,
                            thumbVisibility: true,
                            child: Scrollbar(
                              controller: _horizontalController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalController,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  controller: _verticalController,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(minWidth: 1150),
                                    child: Table(
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(2),
                                        // 3: FlexColumnWidth(2),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(color: Colors.red.shade50),
                                          children: [
                                            _buildHeader("Name"),
                                            _buildHeader("Desigination"),
                                            _buildHeader("Access"),
                                            _buildHeader("Status"),
                                            // _buildHeader("Profile"),
                                          ],
                                        ),
                                        for (var singleEmployee in filteredEmployees.asMap().entries)
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color:
                                                  singleEmployee.key.isEven
                                                      ? Colors.grey.shade200
                                                      : Colors.grey.shade100,
                                            ),
                                            children: [
                                              _buildCell3(
                                                singleEmployee.value.employeeName,
                                                singleEmployee.value.userId,
                                                copyable: true,
                                              ),
                                              _buildCell1(
                                                singleEmployee.value.empDesignation.isEmpty
                                                    ? "N/A"
                                                    : singleEmployee.value.empDesignation,
                                              ),

                                              _buildCell(
                                                singleEmployee.value.allDesignations,
                                                singleEmployee.value.employeeType.isEmpty ? "Role" : "Access",
                                                singleEmployee.value.empDesignation,
                                                singleEmployee.value.employeeName,
                                                singleEmployee.value.access,
                                              ),
                                              _buildActionCell2(
                                                onEdit: () {},
                                                onDelete: () {},
                                                employee: singleEmployee.value,
                                              ),

                                              /*_buildActionCell(
                                                onDraft: () async {
                                                  print(singleEmployee);
                                                  final result =
                                                      await EmployeeProfileDialog(
                                                        context,
                                                        singleEmployee,
                                                        employeeProvider.data,
                                                        //  bankAccount,
                                                      );
                                                  if (result != null) {
                                                    // Optionally update UI or local state with returned values
                                                    // For example, you could show a toast/snackbar or trigger a refresh
                                                    // setState(() {});
                                                  }
                                                },
                                              ),*/
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Text(
          text,
          style: const TextStyle(color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCell(
    List<Designation> designation,
    String text,
    String userDesignation,
    String userName,
    UserAccess? access,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                // _showLockUnlockDialog(context);
                showAccessDialog(context, userName, userDesignation, designation, access!.toJson());
              },
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue, // clickable style
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell3(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54)),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "$text2"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void showAccessDialog(
    BuildContext context,
    String userName,
    String userDesignation,
    List<Designation> designation,
    Map<String, dynamic> apiUserAccess,
  ) {
    final cols = _buildDbCols();
    final userAccess = _fillMissing(_normalizeKeys(apiUserAccess), cols);
    final String userId = (userAccess['user_id'] ?? '').toString();

    // Local UI state
    final moduleState = <String, bool>{};
    final submenuState = <String, bool>{};

    // Seed from DB
    for (final item in sidebarItemsAccess) {
      moduleState[item.accessKey] = _toBool(userAccess[item.accessKey]);
      for (final key in item.submenuKeys) {
        submenuState[key] = _toBool(userAccess[key]);
      }
    }
    // If any submenu is ON, ensure parent is ON
    for (final item in sidebarItemsAccess) {
      if (item.submenuKeys.any((k) => submenuState[k] == true)) {
        moduleState[item.accessKey] = true;
      }
    }

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setState) {
              selectedService = userDesignation;
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title: Text('Manage Access For $userName', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800)),
                content: SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: sidebarItemsAccess.length,
                        itemBuilder: (_, i) {
                          final item = sidebarItemsAccess[i];
                          final parentOn = moduleState[item.accessKey] ?? false;
                          return ExpansionTile(
                            title: Row(
                              children: [
                                Icon(item.icon, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Transform.scale(
                                  scale: 0.5,
                                  child: Switch(
                                    value: parentOn,
                                    onChanged: (val) {
                                      setState(() {
                                        moduleState[item.accessKey] = val;
                                        if (!val) {
                                          for (final k in item.submenuKeys) {
                                            submenuState[k] = false;
                                          }
                                        }
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: Colors.green,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            children: List.generate(item.submenuKeys.length, (j) {
                              final subKey = item.submenuKeys[j];
                              final subOn = submenuState[subKey] ?? false;
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.only(left: 32, right: 8),
                                title: Text(item.submenus[j]),
                                trailing: Transform.scale(
                                  scale: 0.5,
                                  child: Switch(
                                    value: subOn,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val && !(moduleState[item.accessKey] ?? false)) {
                                          moduleState[item.accessKey] = true;
                                        }
                                        submenuState[subKey] = val;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: Colors.green,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.red,
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close', style: TextStyle(color: Colors.grey)),
                  ),
                  CustomButton(
                    text: 'Submit',
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      final payload = <String, dynamic>{for (final c in cols) c: 0};
                      for (final item in sidebarItemsAccess) {
                        final pOn = moduleState[item.accessKey] ?? false;
                        payload[item.accessKey] = pOn ? 1 : 0;
                        for (final k in item.submenuKeys) {
                          final sOn = submenuState[k] ?? false;
                          payload[k] = pOn ? (sOn ? 1 : 0) : 0;
                        }
                      }
                      final signup = context.read<SignupProvider>();
                      await signup.updateUserAccess(userId: userId, accessData: payload, context: context);
                      await Provider.of<EmployeeProvider>(context, listen: false).getFullData();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildActionCell({VoidCallback? onDraft}) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.people_outline, size: 23, color: Colors.blue), onPressed: onDraft ?? () {}),
      ],
    );
  }

  Widget _buildActionCell2({VoidCallback? onEdit, VoidCallback? onDelete, required Employee employee}) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            employee.isUserActive == 1 ? Icons.check_circle : Icons.block,
            size: 20,
            color: employee.isUserActive == 1 ? Colors.green : Colors.red,
          ),
          onPressed: onEdit ?? () {},
        ),
      ],
    );
  }

  Widget _buildCell1(String text, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(text, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> _normalizeKeys(Map<String, dynamic> raw) {
    final out = <String, dynamic>{};
    raw.forEach((k, v) => out[aliases[k] ?? k] = v);
    return out;
  }

  bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v.toInt() == 1;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == '1' || s == 'true' || s == 'yes';
    }
    return false;
  }

  Map<String, dynamic> _fillMissing(Map<String, dynamic> m, List<String> cols) {
    final out = Map<String, dynamic>.from(m);
    for (final c in cols) {
      out.putIfAbsent(c, () => 0);
    }
    return out;
  }

  List<String> _buildDbCols() {
    final s = <String>{};
    for (final it in sidebarItemsAccess) {
      s.add(it.accessKey);
      s.addAll(it.submenuKeys);
    }
    return s.toList();
  }
}
