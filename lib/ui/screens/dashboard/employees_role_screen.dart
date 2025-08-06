import 'package:abc_consultant/providers/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../employee/EmployeeProvider.dart';
import '../../../employee/employee_models.dart';
import '../../../providers/desigination_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../dialogs/date_picker.dart';
import '../../dialogs/employe_profile.dart';
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
  String? selectedCategory;

  final List<String> categories1 = [
    'No Tags',
    'Tag 001',
    'Tag 002',
    'Sample Tag',
  ];
  String? selectedCategory1;

  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;

  final List<String> categories3 = [
    'All',
    'Toady',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];
  String? selectedCategory3;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<EmployeeProvider>(context, listen: false).getFullData(),
    );
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
                                        setState(
                                          () => selectedCategory = newValue!,
                                        );
                                      },
                                    ),
                                    CustomDropdown(
                                      selectedValue: selectedCategory1,
                                      hintText: "Select Tags",
                                      items: categories1,
                                      onChanged: (newValue) {
                                        setState(
                                          () => selectedCategory1 = newValue!,
                                        );
                                      },
                                    ),
                                    CustomDropdown(
                                      selectedValue: selectedCategory2,
                                      hintText: "Payment Status",
                                      items: categories2,
                                      onChanged: (newValue) {
                                        setState(
                                          () => selectedCategory2 = newValue!,
                                        );
                                      },
                                    ),
                                    CustomDropdown(
                                      selectedValue: selectedCategory3,
                                      hintText: "Dates",
                                      items: categories3,
                                      onChanged: (newValue) async {
                                        if (newValue == 'Custom Range') {
                                          final selectedRange =
                                              await showDateRangePickerDialog(
                                                context,
                                              );

                                          if (selectedRange != null) {
                                            final start =
                                                selectedRange.startDate ??
                                                DateTime.now();
                                            final end =
                                                selectedRange.endDate ?? start;

                                            final formattedRange =
                                                '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';

                                            setState(() {
                                              selectedCategory3 =
                                                  formattedRange;
                                            });
                                          }
                                        } else {
                                          setState(
                                            () => selectedCategory3 = newValue!,
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.calendar_month,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: 700,
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
                                    constraints: const BoxConstraints(
                                      minWidth: 1150,
                                    ),
                                    child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(2),
                                        3: FlexColumnWidth(2),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                          ),
                                          children: [
                                            _buildHeader("Name"),
                                            _buildHeader("Desigination"),
                                            _buildHeader("Role"),
                                            _buildHeader("Access"),
                                          ],
                                        ),
                                        for (var singleEmployee
                                            in (employeeProvider
                                                        .data
                                                        ?.employees ??
                                                    [])
                                                .asMap()
                                                .entries)
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color:
                                                  singleEmployee.key.isEven
                                                      ? Colors.grey.shade200
                                                      : Colors.grey.shade100,
                                            ),
                                            children: [
                                              _buildCell3(
                                                singleEmployee
                                                    .value
                                                    .employeeName,
                                                singleEmployee.value.userId,
                                                copyable: true,
                                              ),
                                              _buildCell1(
                                                singleEmployee
                                                        .value
                                                        .empDesignation
                                                        .isEmpty
                                                    ? "N/A"
                                                    : singleEmployee
                                                        .value
                                                        .empDesignation,
                                              ),
                                              _buildCell(
                                                singleEmployee
                                                    .value
                                                    .allDesignations,
                                                singleEmployee
                                                        .value
                                                        .employeeType
                                                        .isEmpty
                                                    ? "N/A"
                                                    : singleEmployee
                                                        .value
                                                        .employeeType,
                                                singleEmployee
                                                    .value
                                                    .employeeName,
                                                singleEmployee.value.access,
                                              ),
                                              _buildActionCell(
                                                onEdit: () {},
                                                onDelete: () {},
                                                onDraft: () {
                                                  print(singleEmployee);
                                                  EmployeeProfileDialog(
                                                    context,
                                                    singleEmployee,
                                                  );
                                                },
                                              ),
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
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCell(
    List<Designation> designation,
    String text,
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
                showAccessDialog(
                  context,
                  designation,
                  userName,
                  access!.toJson(),
                );
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
              Text(
                text2,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
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
    List<Designation> designation,
    String userName,
    Map<String, dynamic> userAccess,
  ) {
    for (var item in sidebarItemsAccess) {
      item.isLocked = (userAccess[item.accessKey] ?? 0) == 0;

      item.submenuLockStates =
          item.submenuKeys.map((key) => (userAccess[key] ?? 0) == 0).toList();
    }

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Manage Access For $userName"),
                  SizedBox(height: 12),
                  SizedBox(
                    width: 230,
                    child: CustomDropdownWithRightAdd(
                      label: "Assign Designation ",
                      value: selectedService,
                      items: designation,
                      onChanged: (val) => selectedService = val,
                      onAddPressed: () {
                        showInstituteManagementDialog2(context);
                      },
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sidebarItemsAccess.length,
                  itemBuilder: (context, index) {
                    final item = sidebarItemsAccess[index];
                    return ExpansionTile(
                      title: Row(
                        children: [
                          Icon(item.icon, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: 0.5,
                            child: Switch(
                              value: !(item.isLocked ?? true),
                              onChanged: (val) {
                                setState(() {
                                  item.isLocked = !val;
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
                      children: List.generate(item.submenus.length, (subIndex) {
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(
                            left: 32,
                            right: 8,
                          ),
                          title: Text(
                            item.submenus[subIndex],
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Transform.scale(
                            scale: 0.5,
                            child: Switch(
                              value: !item.submenuLockStates![subIndex],
                              onChanged: (val) {
                                setState(() {
                                  item.submenuLockStates![subIndex] = !val;
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
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CustomButton(
                  backgroundColor: Colors.green,
                  text: "Submit",
                  onPressed: () async {
                    final accessMap = <String, bool>{};

                    for (var item in sidebarItemsAccess) {
                      accessMap[item.accessKey] = !(item.isLocked ?? true);
                      for (int i = 0; i < item.submenuKeys.length; i++) {
                        accessMap[item.submenuKeys[i]] =
                            !item.submenuLockStates![i];
                      }
                    }

                    final accessProvider = Provider.of<SignupProvider>(
                      context,
                      listen: false,
                    );
                    final result = await accessProvider.updateUserAccess(
                      userId: userAccess['user_id'],
                      accessData: accessMap,
                      context: context,
                    );

                    if (result) Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onDraft,
  }) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.block, size: 20, color: Colors.red),
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.check_circle, size: 20, color: Colors.green),
          onPressed: onDelete ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.person, size: 23, color: Colors.blue),
          onPressed: onDraft ?? () {},
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
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
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

  void showInstituteManagementDialog2(BuildContext context) {
    final List<String> institutes = [];
    final TextEditingController addController = TextEditingController();
    final TextEditingController editController = TextEditingController();
    int? editingIndex;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Slightly smaller radius
              ),
              contentPadding: const EdgeInsets.all(12), // Reduced padding
              insetPadding: const EdgeInsets.all(20), // Space around dialog
              content: SizedBox(
                width: 363,
                height: 305,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Compact header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Services',
                          style: TextStyle(
                            fontSize: 16, // Smaller font
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.red,
                          ),
                          // Smaller icon
                          padding: EdgeInsets.zero,
                          // Remove default padding
                          constraints: const BoxConstraints(),
                          // Remove minimum size
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Compact input field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // align top
                      children: [
                        // TextField
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: addController,
                              cursorColor: Colors.blue,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: "Add institute...",
                                border: InputBorder.none,
                                // remove double border
                                isDense: true,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Add Button
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              if (addController.text.trim().isNotEmpty) {
                                setState(() {
                                  institutes.add(addController.text.trim());
                                  addController.clear();
                                });
                              }
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Compact list
                    Expanded(
                      child:
                          institutes.isEmpty
                              ? const Center(
                                child: Text(
                                  'No institutes',
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
                              : ListView.builder(
                                shrinkWrap: true,
                                itemCount: institutes.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      // Makes tiles more compact
                                      visualDensity: VisualDensity.compact,
                                      // Even more compact
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                      title: Text(
                                        institutes[index],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      trailing: SizedBox(
                                        width:
                                            80, // Constrained width for buttons
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                              padding: EdgeInsets.zero,
                                              onPressed:
                                                  () => _showEditDialog(
                                                    context,
                                                    setState,
                                                    institutes,
                                                    index,
                                                    editController,
                                                  ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                setState(() {
                                                  institutes.removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    StateSetter setState,
    List<String> institutes,
    int index,
    TextEditingController editController,
  ) {
    editController.text = institutes[index];
    showDialog(
      context: context,
      builder: (editContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: 250, // Smaller width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: Colors.blue,
                  controller: editController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                    ),
                    labelText: 'Edit institute',
                    labelStyle: TextStyle(color: Colors.blue),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(editContext),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        if (editController.text.trim().isNotEmpty) {
                          setState(() {
                            institutes[index] = editController.text.trim();
                          });
                          Navigator.pop(editContext);
                        }
                      },
                      text: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
