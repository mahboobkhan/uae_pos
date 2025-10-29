import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../employee/EmployeeProvider.dart';
import '../../../employee/employee_models.dart';
import '../../../providers/update_ban_account_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/clipboard_utils.dart';
import '../../../utils/request_state.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/edit_dialog.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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
  bool _isHovering = false;

  // Get unique employee types from the data
  List<String> getUniqueEmployeeTypes(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      print('List of types ${'getUniqueEmployeeTypes'}');

      return ['All'];
    }

    final types = provider.employees!.map((e) => e.employeeType).where((type) => type.isNotEmpty).toSet().toList();
    print("Employee Types: $types");

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
    print("designations: $designations");
    return ['All', ...designations];
  }

  List<Employee> getFilteredEmployees(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return [];
    }

    return provider.employees!.where((employee) {
      // Apply Employee Type filter
      if (selectedCategory != 'All' && employee.employeeType != selectedCategory) {
        return false;
      }

      // Apply Designation filter
      if (selectedCategory1 != 'All' && employee.empDesignation != selectedCategory1) {
        return false;
      }

      return true;
    }).toList();
  }

  // Get filtered bank accounts based on selected filters
  List<BankAccount> getFilteredBankAccounts(EmployeeProvider provider) {
    if (provider.allUserBankAccounts == null || provider.allUserBankAccounts!.isEmpty) {
      return [];
    }

    // Get filtered employee IDs first
    final filteredEmployeeIds = getFilteredEmployees(provider).map((e) => e.userId).toSet();

    // Filter bank accounts based on employee IDs
    return provider.allUserBankAccounts!.where((bankAccount) {
      return filteredEmployeeIds.contains(bankAccount.userId);
    }).toList();
  }

  // Get employee details for a bank account
  Employee? getEmployeeForBankAccount(EmployeeProvider provider, BankAccount bankAccount) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return null;
    }

    try {
      return provider.employees!.firstWhere(
        (employee) => employee.userId == bankAccount.userId,
        orElse: () => null as dynamic,
      );
    } catch (e) {
      return null;
    }
  }

  // Helper method to show "N/A" for empty values
  String _getDisplayValue(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'N/A';
    }
    return value;
  }

  // Helper method to check if a bank account has any meaningful data
  bool _hasBankAccountData(BankAccount bankAccount) {
    return bankAccount.bankName.isNotEmpty ||
        bankAccount.bankAccountNumber.isNotEmpty ||
        bankAccount.titleName.isNotEmpty ||
        bankAccount.contactNumber.isNotEmpty ||
        bankAccount.emailId.isNotEmpty;
  }

  // Show edit bank account dialog
  void _showEditBankAccountDialog(BuildContext context, BankAccount bankAccount, EmployeeProvider employeeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BankAccountEditDialog(
          data: employeeProvider.data,
          bankAccount: bankAccount,
          onSave: (updatedBankAccount) async {
            // Close the dialog
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 16),
                    Text('Updating bank account...'),
                  ],
                ),
                duration: Duration(seconds: 2),
              ),
            );

            try {
              // Update the bank account using the provider
              final updateProvider = Provider.of<UpdateUserBankAccountProvider>(context, listen: false);

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

              await updateProvider.updateBankAccount(request);

              if (updateProvider.state == RequestState.success) {
                // Refresh the employee data to get updated bank accounts
                await employeeProvider.getFullData();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bank account updated successfully!'), backgroundColor: Colors.green),
                );
              } else {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${updateProvider.errorMessage ?? 'Unknown error'}'),
                    backgroundColor: AppColors.redColor,
                  ),
                );
              }
            } catch (e) {
              // Show error message
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.redColor));
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Load employee data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).getFullData();
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

  @override
  Widget build(BuildContext context) {
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
                          ? [BoxShadow(color: Colors.blue, blurRadius: 4, spreadRadius: 0.1, offset: Offset(0, 1))]
                          : [],
                ),
                child: Consumer<EmployeeProvider>(
                  builder: (context, employeeProvider, child) {
                    return Row(
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
                                    setState(() => selectedCategory = newValue!);
                                  },
                                ),
                                CustomDropdown(
                                  selectedValue: selectedCategory1,
                                  hintText: "Designation",
                                  items: getUniqueDesignations(employeeProvider),
                                  onChanged: (newValue) {
                                    setState(() => selectedCategory1 = newValue!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        /*Row(
                          children: [
                            Card(
                              elevation: 8,
                              color: Colors.blue,
                              shape: const CircleBorder(),
                              child: Builder(
                                builder:
                                    (context) => Tooltip(
                                      message: 'Show menu',
                                      waitDuration: const Duration(milliseconds: 2),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                        child: const Center(child: Icon(Icons.add, color: Colors.white, size: 20)),
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),*/
                      ],
                    );
                  },
                ),
              ),
            ),
            // Summary Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 400,
                child: Consumer<EmployeeProvider>(
                  builder: (context, employeeProvider, child) {
                    if (employeeProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (employeeProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading data',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red.shade700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              employeeProvider.error!,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                employeeProvider.getFullData();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (employeeProvider.allUserBankAccounts == null || employeeProvider.allUserBankAccounts!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No bank accounts found',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'There are no bank accounts in the system yet.',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    // Get filtered bank accounts based on selected filters
                    final filteredBankAccounts = getFilteredBankAccounts(employeeProvider);
                    if (filteredBankAccounts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_list_outlined, size: 48, color: Colors.orange.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'No matching bank accounts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters to see more results.',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // Check if all bank accounts have empty data
                    final hasAnyData = filteredBankAccounts.any((account) => _hasBankAccountData(account));
                    if (!hasAnyData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Bank accounts found but no data',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bank accounts exist but all fields are empty.',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
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
                                      constraints: const BoxConstraints(minWidth: 1200),
                                      child: Table(
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        columnWidths: const {
                                          0: FlexColumnWidth(0.8),
                                          1: FlexColumnWidth(1.2),
                                          2: FlexColumnWidth(0.8),
                                          3: FlexColumnWidth(1),
                                          4: FlexColumnWidth(1.2),
                                          5: FlexColumnWidth(1.3),
                                          6: FlexColumnWidth(1.0),
                                        },
                                        children: [
                                          // Header Row
                                          TableRow(
                                            decoration: BoxDecoration(color: Colors.red.shade50),
                                            children: [
                                              _buildHeader("Date "),
                                              _buildHeader("Title Name"),
                                              _buildHeader("Bank Name"),
                                              _buildHeader("Account Detail "),
                                              _buildHeader("Contact Detail"),
                                              _buildHeader("Note"),
                                              _buildHeader("Other Action"),
                                            ],
                                          ),
                                          // Bank Account Rows
                                          for (int i = 0; i < filteredBankAccounts.length; i++)
                                            TableRow(
                                              decoration: BoxDecoration(
                                                color: i.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                              ),
                                              children: [
                                                _buildCell(_formatDateForDisplay(filteredBankAccounts[i].createdDate)),
                                                _buildCell(_getDisplayValue(filteredBankAccounts[i].titleName)),
                                                _buildCell(_getDisplayValue(filteredBankAccounts[i].bankName)),
                                                _buildCell(
                                                  _getDisplayValue(filteredBankAccounts[i].bankAccountNumber),
                                                  copyable: true,
                                                ),
                                                _buildCell3(
                                                  _getDisplayValue(filteredBankAccounts[i].contactNumber),
                                                  _getDisplayValue(filteredBankAccounts[i].emailId),
                                                ),
                                                _buildCell(_getDisplayValue(filteredBankAccounts[i].additionalNote)),
                                                _buildActionCell(
                                                  onEdit: () {
                                                    _showEditBankAccountDialog(
                                                      context,
                                                      filteredBankAccounts[i],
                                                      employeeProvider,
                                                    );
                                                  },
                                                  onShare: () {},
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
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
          style: const TextStyle(color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmployeeCell(Employee? employee) {
    if (employee == null) {
      return _buildCell("N/A");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.employeeName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text1,
                style: TextStyle(
                  fontSize: 12,
                  color: text1 == 'N/A' ? Colors.grey.shade500 : Colors.black87,
                  fontStyle: text1 == 'N/A' ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              if (copyable && text1 != 'N/A')
                GestureDetector(
                  onTap: () {
                    ClipboardUtils.copyToClipboard(text1, context, message: 'Text 1 copied');
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
                style: TextStyle(
                  fontSize: 10,
                  color: text2 == 'N/A' ? Colors.grey.shade400 : Colors.black54,
                  fontStyle: text2 == 'N/A' ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              if (copyable && text2 != 'N/A')
                GestureDetector(
                  onTap: () {
                    ClipboardUtils.copyToClipboard(text2, context, message: 'Text 2 copied');
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
    final isNA = text == 'N/A';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isNA ? Colors.grey.shade500 : Colors.black87,
                fontStyle: isNA ? FontStyle.italic : FontStyle.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (copyable && !isNA)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
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

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onShare}) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        /*IconButton(
          icon: const Icon(Icons.share, size: 20, color: Colors.blue),
          tooltip: 'Share',
          onPressed: onShare ?? () {},
        ),*/
      ],
    );
  }

  Widget _buildCell2(String text1, String text2, {bool copyable = false, bool centerText2 = false}) {
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
                    child: Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  ),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.copy, size: 14, color: Colors.blue[700]),
                      ),
                    ),
                ],
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54))),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.copy, size: 8, color: Colors.blue[700]),
                      ),
                    ),
                ],
              ),
        ],
      ),
    );
  }
}
