import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../employee/EmployeeProvider.dart';
import '../../../employee/employee_models.dart';
import '../../../utils/clipboard_utils.dart';
import '../../dialogs/custom_dialoges.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class BankDetailScreen extends StatefulWidget {
  const BankDetailScreen({super.key});

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  String? selectedCategory = 'All';
  String? selectedCategory1 = 'All';
  String? selectedCategory2;
  bool _isHovering = false;
  String? _currentUserId;

  // Get unique employee types from the data
  List<String> getUniqueEmployeeTypes(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return ['All'];
    }

    final types =
        provider.employees!
            .map((e) => e.employeeType)
            .where((type) => type.isNotEmpty)
            .toSet()
            .toList();

    return ['All', ...types];
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
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    setState(() {
      _currentUserId = userId;
    });

    // Use post-frame callback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId != null && userId.isNotEmpty) {
        final employeeProvider = Provider.of<EmployeeProvider>(
          context,
          listen: false,
        );
        employeeProvider.getFullData();
      } else {
        print(
          '🔑 Post-frame callback: No user ID available, skipping data fetch',
        );
      }
    });
  }

  String _formatDateForDisplay(String apiDate) {
    try {
      if (apiDate.isEmpty) return 'N/A';
      final parsedDate = DateTime.parse(apiDate);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }

  List<Employee> getFilteredEmployees(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return [];
    }

    // If no current user ID, show all employees (for admin view)
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      return provider.employees!.where((employee) {
        // Apply filters if needed
        if (selectedCategory != 'All' &&
            employee.employeeType != selectedCategory) {
          return false;
        }

        if (selectedCategory1 != 'All' &&
            employee.empDesignation != selectedCategory1) {
          return false;
        }
        return true;
      }).toList();
    }

    // Filter by current user ID and other filters
    final filtered =
        provider.employees!.where((employee) {
          print(
            '🔍 Checking employee: ${employee.employeeName} (userId: ${employee.userId})',
          );

          // First filter by current user ID
          if (employee.userId != _currentUserId) {
            print(
              '🔍 Employee ${employee.employeeName} userId mismatch: ${employee.userId} != $_currentUserId',
            );
            return false;
          }

          print('🔍 Employee ${employee.employeeName} userId matches!');

          // Then apply other filters if needed
          if (selectedCategory != 'All' &&
              employee.employeeType != selectedCategory) {
            return false;
          }

          if (selectedCategory1 != 'All' &&
              employee.empDesignation != selectedCategory1) {
            return false;
          }

          return true;
        }).toList();

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<EmployeeProvider>(
        builder: (ctx, employeeProvider, _) {
          if (employeeProvider.isLoading) {
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading bank details...'),
                  ],
                ),
              ),
            );
          }

          if (employeeProvider.error != null) {
            print('🏗️ Showing error state: ${employeeProvider.error}');
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${employeeProvider.error}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => employeeProvider.getFullData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (employeeProvider.employees == null ||
              employeeProvider.employees!.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No employee data found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your connection and try again',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => employeeProvider.getFullData(),
                      child: const Text('Refresh Data'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Get filtered employees based on selected filters
          final filteredEmployees = getFilteredEmployees(employeeProvider);

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  /*
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Bank Details',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'View and manage your bank account information',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => employeeProvider.getFullData(),
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Refresh Data',
                            ),
                          ],
                        ),
                        // Debug Information (remove in production)
                        if (true) // Set to false to hide debug info
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(color: Colors.blue.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Debug Info:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Current User ID: ${_currentUserId ?? "Not set"}',
                                ),
                                Text(
                                  'Total Employees: ${employeeProvider.employees?.length ?? 0}',
                                ),
                                Text(
                                  'Filtered Employees: ${filteredEmployees.length}',
                                ),
                                Text('Selected Category: $selectedCategory'),
                                Text('Selected Category1: $selectedCategory1'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
*/
                  // Filters Section
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
                                    blurRadius: 4,
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
                                    hintText: "Employee Type",
                                    items: getUniqueEmployeeTypes(
                                      employeeProvider,
                                    ),
                                    onChanged: (newValue) {
                                      setState(
                                        () => selectedCategory = newValue!,
                                      );
                                    },
                                  ),
                                  CustomDropdown(
                                    selectedValue: selectedCategory1,
                                    hintText: "Designation",
                                    items: getUniqueDesignations(
                                      employeeProvider,
                                    ),
                                    onChanged: (newValue) {
                                      setState(
                                        () => selectedCategory1 = newValue!,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Card(
                                elevation: 8,
                                color: Colors.blue,
                                shape: const CircleBorder(),
                                child: Builder(
                                  builder:
                                      (context) => Tooltip(
                                        message: 'Add New Bank Account',
                                        waitDuration: const Duration(
                                          milliseconds: 2,
                                        ),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: 400,
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
                                    minWidth: 1200,
                                  ),
                                  child: Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(1.0),
                                      // Date & Time
                                      1: FlexColumnWidth(1.2),
                                      // Bank Name
                                      2: FlexColumnWidth(1.0),
                                      // Branch Code
                                      3: FlexColumnWidth(1.5),
                                      // Account Number/IBAN
                                      4: FlexColumnWidth(1.0),
                                      // Account Title
                                      5: FlexColumnWidth(1.2),
                                      // Contact & Email
                                      6: FlexColumnWidth(1.2),
                                      // Contact & Email
                                    },
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                        ),
                                        children: [
                                          _buildHeader("Date"),
                                          _buildHeader("Account Title"),
                                          _buildHeader("Bank Name"),
                                          _buildHeader("Account Detail"),
                                          _buildHeader("Contact Detail"),
                                          _buildHeader("Note"),
                                          _buildHeader("Actions"),
                                        ],
                                      ),
                                      ...filteredEmployees.expand((employee) {
                                        final index = filteredEmployees.indexOf(
                                          employee,
                                        );

                                        // If employee has no bank accounts, show one row with N/A
                                        if (employee.allBankAccounts.isEmpty) {
                                          return [
                                            TableRow(
                                              decoration: BoxDecoration(
                                                color:
                                                    index.isEven
                                                        ? Colors.grey.shade200
                                                        : Colors.grey.shade100,
                                              ),
                                              children: [
                                                _buildCell2(
                                                  _formatDateForDisplay(
                                                    employee.lastUpdatedDate,
                                                  ),
                                                  '',
                                                  centerText2: true,
                                                ),
                                                _buildCell("N/A"),
                                                _buildCell("N/A"),
                                                _buildCell("No Bank Account"),
                                                _buildCell3("N/A", "N/A"),
                                                _buildCell("N/A"),
                                                _buildActionCell(
                                                  onEdit: () {},
                                                  onDelete: () {},
                                                ),
                                              ],
                                            ),
                                          ];
                                        }
                                        // Show one row for each bank account
                                        return employee.allBankAccounts.map((
                                          bankAccount,
                                        ) {
                                          return TableRow(
                                            decoration: BoxDecoration(
                                              color:
                                                  index.isEven
                                                      ? Colors.grey.shade200
                                                      : Colors.grey.shade100,
                                            ),
                                            children: [
                                              _buildCell2(
                                                _formatDateForDisplay(
                                                  employee.lastUpdatedDate,
                                                ),
                                                '',
                                                centerText2: true,
                                              ),
                                              _buildCell(
                                                bankAccount.titleName.isNotEmpty
                                                    ? bankAccount.titleName
                                                    : "N/A",
                                              ),
                                              _buildCell(bankAccount.bankName),
                                              _buildCell(
                                                bankAccount
                                                        .bankAccountNumber
                                                        .isNotEmpty
                                                    ? bankAccount
                                                        .bankAccountNumber
                                                    : bankAccount
                                                        .ibanNumber
                                                        .isNotEmpty
                                                    ? bankAccount.ibanNumber
                                                    : "N/A",
                                                copyable: true,
                                              ),

                                              _buildCell3(
                                                bankAccount
                                                        .contactNumber
                                                        .isNotEmpty
                                                    ? bankAccount.contactNumber
                                                    : "N/A",
                                                bankAccount.emailId.isNotEmpty
                                                    ? bankAccount.emailId
                                                    : "N/A",
                                              ),
                                              _buildCell(
                                                bankAccount
                                                        .bankAddress
                                                        .isNotEmpty
                                                    ? bankAccount.bankAddress
                                                    : "N/A",
                                              ),
                                              _buildActionCell(
                                                onEdit: () {},
                                                onDelete: () {},
                                              ),
                                            ],
                                          );
                                        });
                                      }),
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

  Widget _buildCell3(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text1, style: const TextStyle(fontSize: 12)),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    ClipboardUtils.copyToClipboard(
                      text1,
                      context,
                      message: 'Text 1 copied',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
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
                    ClipboardUtils.copyToClipboard(
                      text2,
                      context,
                      message: 'Text 2 copied',
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

  Widget _buildCell(String text, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.red),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.share, size: 20, color: Colors.blue),
          tooltip: 'Share',
          onPressed: onDelete ?? () {},
        ),
        /*IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: Colors.red,
          ),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),*/
      ],
    );
  }

  Widget _buildCell2(
    String text1,
    String text2, {
    bool copyable = false,
    bool centerText2 = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: const TextStyle(fontSize: 12)),
          centerText2
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      text2,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: "$text1\n$text2"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.copy,
                          size: 14,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                ],
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      text2,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: "$text1\n$text2"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.copy,
                          size: 8,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                ],
              ),
        ],
      ),
    );
  }
}
