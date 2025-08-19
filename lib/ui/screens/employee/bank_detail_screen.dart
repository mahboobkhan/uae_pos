import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../employee/EmployeeProvider.dart';
import '../../../employee/employee_models.dart';
import '../../../utils/clipboard_utils.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../../providers/update_ban_account_provider.dart';
import '../../../utils/request_state.dart';

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
/*
  List<Employee> getFilteredEmployees(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return [];
    }

    // ✅ Always use all employees (ignore current user id)
    return provider.employees!.where((employee) {
      // Apply Employee Type filter
      if (selectedCategory != 'All' &&
          employee.employeeType != selectedCategory) {
        return false;
      }

      // Apply Designation filter
      if (selectedCategory1 != 'All' &&
          employee.empDesignation != selectedCategory1) {
        return false;
      }

      return true;
    }).toList();
  }
*/


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
          final filteredEmployees = getFilteredEmployees(employeeProvider);
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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
                                    items: getUniqueEmployeeTypes(employeeProvider),

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
                                    columnWidths:  {
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

                                      // Data Rows
                                      ...() {
                                        int rowIndex = 0;
                                        return filteredEmployees.expand((employee) {
                                          print(" Filterssss ${employee.employeeType}");
                                          return employee.allBankAccounts.map((bankAccount) {
                                            final currentIndex = rowIndex++; // har row ka unique index

                                            return TableRow(
                                              decoration: BoxDecoration(
                                                color: currentIndex.isEven
                                                    ? Colors.grey.shade200
                                                    : Colors.grey.shade100,
                                              ),
                                              children: [
                                                _buildCell2(
                                                  _formatDateForDisplay(employee.lastUpdatedDate),
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
                                                  bankAccount.bankAccountNumber.isNotEmpty
                                                      ? bankAccount.bankAccountNumber
                                                      : bankAccount.ibanNumber.isNotEmpty
                                                      ? bankAccount.ibanNumber
                                                      : "N/A",
                                                  copyable: true,
                                                ),
                                                _buildCell3(
                                                  bankAccount.contactNumber.isNotEmpty
                                                      ? bankAccount.contactNumber
                                                      : "N/A",
                                                  bankAccount.emailId.isNotEmpty
                                                      ? bankAccount.emailId
                                                      : "N/A",
                                                ),
                                                _buildCell(
                                                  bankAccount.additionalNote.isNotEmpty
                                                      ? bankAccount.additionalNote
                                                      : "N/A",
                                                ),
                                                _buildActionCell(
                                                  onEdit: () => _showEditDialog(context, bankAccount, employee),
                                                  onDelete: () {},
                                                ),
                                              ],
                                            );
                                          });
                                        }).toList();
                                      }(),
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

  void _showEditDialog(BuildContext context, BankAccount bankAccount, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BankAccountEditDialog(
          bankAccount: bankAccount,
          employee: employee,
          onSave: (updatedBankAccount) async {
            final provider = Provider.of<UpdateUserBankAccountProvider>(
              context,
              listen: false
            );

            // Create the request
            final request = UpdateUserBankAccountRequest(
              bankAccountId: updatedBankAccount.id,
              userId: updatedBankAccount.userId,
              bankName: updatedBankAccount.bankName,
              branchCode: updatedBankAccount.branchCode,
              bankAddress: updatedBankAccount.bankAddress,
              titleName: updatedBankAccount.titleName,
              bankAccountNumber: updatedBankAccount.bankAccountNumber,
              ibanNumber: updatedBankAccount.ibanNumber,
              contactNumber: updatedBankAccount.contactNumber,
              emailId: updatedBankAccount.emailId,
              additionalNote: updatedBankAccount.additionalNote,
            );

            // Call the provider to update
            await provider.updateBankAccount(request);

            // Check the result
            if (provider.state == RequestState.success) {
              // Close the dialog
              Navigator.of(context).pop();
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bank account updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Refresh the employee data to show updated information
              final employeeProvider = Provider.of<EmployeeProvider>(
                context,
                listen: false
              );
              employeeProvider.getFullData();
            } else {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${provider.errorMessage ?? "Failed to update bank account"}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
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

class BankAccountEditDialog extends StatefulWidget {
  final BankAccount bankAccount;
  final Employee employee;
  final Function(BankAccount) onSave;

  const BankAccountEditDialog({
    Key? key,
    required this.bankAccount,
    required this.employee,
    required this.onSave,
  }) : super(key: key);

  @override
  State<BankAccountEditDialog> createState() => _BankAccountEditDialogState();
}

class _BankAccountEditDialogState extends State<BankAccountEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleNameController;
  late TextEditingController _bankNameController;
  late TextEditingController _branchCodeController;
  late TextEditingController _bankAccountNumberController;
  late TextEditingController _ibanNumberController;
  late TextEditingController _contactNumberController;
  late TextEditingController _emailIdController;
  late TextEditingController _bankAddressController;
  late TextEditingController _additionalNoteController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    _titleNameController = TextEditingController(text: widget.bankAccount.titleName);
    _bankNameController = TextEditingController(text: widget.bankAccount.bankName);
    _branchCodeController = TextEditingController(text: widget.bankAccount.branchCode);
    _bankAccountNumberController = TextEditingController(text: widget.bankAccount.bankAccountNumber);
    _ibanNumberController = TextEditingController(text: widget.bankAccount.ibanNumber);
    _contactNumberController = TextEditingController(text: widget.bankAccount.contactNumber);
    _emailIdController = TextEditingController(text: widget.bankAccount.emailId);
    _bankAddressController = TextEditingController(text: widget.bankAccount.bankAddress);
    _additionalNoteController = TextEditingController(text: widget.bankAccount.additionalNote);
  }

  @override
  void dispose() {
    _titleNameController.dispose();
    _bankNameController.dispose();
    _branchCodeController.dispose();
    _bankAccountNumberController.dispose();
    _ibanNumberController.dispose();
    _contactNumberController.dispose();
    _emailIdController.dispose();
    _bankAddressController.dispose();
    _additionalNoteController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Create updated bank account
      final updatedBankAccount = BankAccount(
        id: widget.bankAccount.id,
        userId: widget.bankAccount.userId,
        titleName: _titleNameController.text.trim(),
        bankName: _bankNameController.text.trim(),
        branchCode: _branchCodeController.text.trim(),
        bankAccountNumber: _bankAccountNumberController.text.trim(),
        ibanNumber: _ibanNumberController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        emailId: _emailIdController.text.trim(),
        bankAddress: _bankAddressController.text.trim(),
        additionalNote: _additionalNoteController.text.trim(),
        createdBy: widget.bankAccount.createdBy, // Keep existing created by
        createdDate: widget.bankAccount.createdDate,
      );

      // Call the onSave callback
      await widget.onSave(updatedBankAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return Icon(
                        isLoading ? Icons.hourglass_empty : Icons.edit,
                        color: isLoading ? Colors.orange.shade700 : Colors.red.shade700,
                        size: 24,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<UpdateUserBankAccountProvider>(
                          builder: (context, provider, child) {
                            final isLoading = provider.state == RequestState.loading;
                            return Text(
                              isLoading ? 'Updating Bank Account...' : 'Edit Bank Account',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isLoading ? Colors.orange.shade700 : Colors.red.shade700,
                              ),
                            );
                          },
                        ),
                        Text(
                          'Employee: ${widget.employee.employeeName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return IconButton(
                        onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: isLoading ? Colors.grey : null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // First row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _titleNameController,
                              label: 'Account Title',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Account title is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _bankNameController,
                              label: 'Bank Name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Bank name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Second row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _branchCodeController,
                              label: 'Branch Code',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _bankAccountNumberController,
                              label: 'Account Number',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Third row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _ibanNumberController,
                              label: 'IBAN Number',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _contactNumberController,
                              label: 'Contact Number',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Fourth row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _emailIdController,
                              label: 'Email ID',
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(), // Empty container for spacing
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Fifth row
                      _buildTextField(
                        controller: _bankAddressController,
                        label: 'Bank Address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      // Sixth row
                      _buildTextField(
                        controller: _additionalNoteController,
                        label: 'Additional Note',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),



                      // Fourth row
                      _buildTextField(
                        controller: _bankAddressController,
                        label: 'Bank Address',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer with buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return TextButton(
                        onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                        child: Text(
                          isLoading ? 'Please wait...' : 'Cancel',
                          style: TextStyle(
                            color: isLoading ? Colors.grey : null,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return ElevatedButton(
                        onPressed: isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Updating...'),
                                ],
                              )
                            : const Text('Save Changes'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Consumer<UpdateUserBankAccountProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.state == RequestState.loading;
        
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          enabled: !isLoading,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: isLoading,
            fillColor: isLoading ? Colors.grey.shade100 : null,
          ),
        );
      },
    );
  }
}
