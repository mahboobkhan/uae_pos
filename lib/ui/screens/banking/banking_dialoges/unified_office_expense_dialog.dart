import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../expense/expense_provider.dart';
import '../../../../utils/request_state.dart';
import '../../../dialogs/calender.dart';
import '../../../dialogs/custom_fields.dart';

class UnifiedOfficeExpenseDialog extends StatefulWidget {
  final Map<String, dynamic>? expenseData; // For edit mode
  final bool isEditMode;

  const UnifiedOfficeExpenseDialog({super.key, this.expenseData, this.isEditMode = false});

  @override
  State<UnifiedOfficeExpenseDialog> createState() => _UnifiedOfficeExpenseDialogState();
}

class _UnifiedOfficeExpenseDialogState extends State<UnifiedOfficeExpenseDialog> {
  DateTime selectedDateTime = DateTime.now();
  String? selectedExpenseType;
  String? selectedBank;
  String? selectedPaymentType;

  // Controllers
  late TextEditingController _expenseNameController;
  late TextEditingController _expenseAmountController;
  late TextEditingController _allocateBalanceController;
  late TextEditingController _payByController;
  late TextEditingController _receivedByController;
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;
  late TextEditingController _issueDateController;

  // Expense types
  final List<String> expenseTypes = [
    'Fixed Office Expense',
    'Office Maintenance Expense',
    'Office Supplies Expense',
    'Miscellaneous Office Expense',
    'Dynamic Attribute Office Expense',
  ];

  final List<String> bankOptions = ['HBL', 'UBL', 'MCB', 'Cash', 'Cheque'];

  final List<String> paymentTypes = ['Cash', 'Cheque', 'Bank'];

  @override
  void initState() {
    super.initState();
    _expenseNameController = TextEditingController();
    _expenseAmountController = TextEditingController();
    _allocateBalanceController = TextEditingController();
    _payByController = TextEditingController();
    _receivedByController = TextEditingController();
    _serviceTIDController = TextEditingController();
    _noteController = TextEditingController();
    _issueDateController = TextEditingController(text: DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime));

    // Initialize with edit data if in edit mode
    if (widget.isEditMode && widget.expenseData != null) {
      _initializeEditData();
    }
  }

  void _initializeEditData() {
    final data = widget.expenseData!;
    setState(() {
      selectedExpenseType = data['expense_type'] ?? '';
      selectedBank = data['bank_ref_id'] ?? data['bank'] ?? '';
      selectedPaymentType = data['payment_type'] ?? '';
      selectedDateTime = data['expense_date'] != null ? 
        (data['expense_date'] is String ? 
          DateTime.tryParse(data['expense_date']) ?? DateTime.now() : 
          data['expense_date']) : 
        DateTime.now();
    });

    _expenseNameController.text = data['expense_name'] ?? '';
    _expenseAmountController.text = data['expense_amount']?.toString() ?? '';
    _allocateBalanceController.text = data['allocated_amount']?.toString() ?? '';
    _payByController.text = data['pay_by_manager'] ?? '';
    _receivedByController.text = data['received_by_person'] ?? '';
    _serviceTIDController.text = data['service_tid'] ?? '';
    _noteController.text = data['note'] ?? '';
    _issueDateController.text = DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime);
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    _allocateBalanceController.dispose();
    _payByController.dispose();
    _receivedByController.dispose();
    _noteController.dispose();
    _issueDateController.dispose();
    _serviceTIDController.dispose();
    super.dispose();
  }

  void _pickDateTime() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime tempDate = selectedDateTime;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: CustomCupertinoCalendar(
            onDateTimeChanged: (date) {
              tempDate = date;
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDateTime = tempDate;
                  _issueDateController.text = DateFormat("dd-MM-yyyy - hh:mm a").format(tempDate);
                });
                Navigator.pop(context);
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        widget.isEditMode ? "Edit Office Expense" : "Office Expense Management",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red, size: 28),
                        onPressed: () async {
                          final shouldClose = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: Colors.white,
                                  title: const Text("Are you sure?"),
                                  content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Keep Changes", style: TextStyle(color: Colors.blue)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text("Close", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldClose == true) {
                            Navigator.of(context).pop(false);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Expense Type Selection
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isEditMode ? "Expense Type (Read Only)" : "Select Expense Type",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children:
                              expenseTypes.map((type) {
                                final isSelected = selectedExpenseType == type;
                                return GestureDetector(
                                  onTap:
                                      widget.isEditMode
                                          ? null
                                          : () {
                                            setState(() {
                                              selectedExpenseType = type;
                                            });
                                          },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.red : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: isSelected ? Colors.red : Colors.grey, width: 1.5),
                                    ),
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: widget.isEditMode ? FontStyle.italic : FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        if (widget.isEditMode)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Expense type cannot be changed in edit mode",
                              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Form Fields
                  if (selectedExpenseType != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_getExpenseIcon(selectedExpenseType!), color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Text(selectedExpenseType!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // First row of fields
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              CustomTextField(label: "Expense Name", hintText: 'Enter expense name', controller: _expenseNameController),
                              CustomTextField(label: "Expense Amount", controller: _expenseAmountController, hintText: '500-AED'),
                              CustomTextField(label: "Allocate Balance", controller: _allocateBalanceController, hintText: '500'),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Second row of fields
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              CustomTextField(label: "Pay By", controller: _payByController, hintText: 'Pay By'),
                              CustomTextField(label: "Received By", controller: _receivedByController, hintText: 'Received By'),
                              _buildDateTimeField(),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Payment Type
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              CustomDropdownField(
                                label: "Payment Type",
                                selectedValue: selectedPaymentType,
                                options: paymentTypes,
                                onChanged:
                                    (val) => setState(() {
                                      selectedPaymentType = val;
                                      // Reset bank and service TID when changing payment type
                                      if (val != 'Bank') {
                                        selectedBank = null;
                                        _serviceTIDController.clear();
                                      }
                                    }),
                              ),
                              // Bank and Service TID (only show when payment type is Bank)
                              if (selectedPaymentType == 'Bank') ...[
                                CustomDropdownField(
                                  label: "Select Bank",
                                  selectedValue: selectedBank,
                                  options: bankOptions,
                                  onChanged: (val) => setState(() => selectedBank = val),
                                ),
                                CustomTextField(label: "Service TID", controller: _serviceTIDController, hintText: 'Service TID'),
                              ],
                              if (selectedPaymentType == 'Cheque') ...[
                                CustomTextField(label: "Cheque No", controller: _serviceTIDController, hintText: 'Cheque No'),
                              ],
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Note field
                          _buildTextField("Note", _noteController, width: double.infinity),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Status and Actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          // Status indicators
                          if (provider.state == RequestState.loading) const LinearProgressIndicator(),

                          if (provider.state == RequestState.error)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error, color: Colors.red, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(provider.errorMessage ?? "Something went wrong", style: const TextStyle(color: Colors.red))),
                                ],
                              ),
                            ),

                          if (provider.state == RequestState.success)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      provider.response?.message ?? "Expense Created Successfully!",
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 16),

                          // Action buttons
                          Row(
                            children: [
                              if (!widget.isEditMode) ...[
                                CustomButton(
                                  text: "Add Another",
                                  backgroundColor: Colors.blue,
                                  onPressed: () {
                                    _clearForm();
                                  },
                                ),
                                const SizedBox(width: 12),
                              ],
                              CustomButton(
                                text: widget.isEditMode ? "Update Expense" : "Save & Close",
                                backgroundColor: Colors.green,
                                onPressed:
                                    provider.state == RequestState.loading
                                        ? () {}
                                        : () {
                                          _submitExpense(provider);
                                        },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // No expense type selected
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Column(
                          children: [
                            Icon(Icons.business_center_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "Please select an expense type to continue",
                              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: _pickDateTime,
        child: AbsorbPointer(
          child: TextField(
            controller: _issueDateController,
            decoration: const InputDecoration(
              labelText: "Date and Time",
              labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_month_outlined, color: Colors.red, size: 22),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {double width = 220}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          labelText: label,
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
      ),
    );
  }

  IconData _getExpenseIcon(String expenseType) {
    switch (expenseType) {
      case 'Fixed Office Expense':
        return Icons.business;
      case 'Office Maintenance Expense':
        return Icons.build;
      case 'Office Supplies Expense':
        return Icons.inventory;
      case 'Miscellaneous Office Expense':
        return Icons.category;
      case 'Dynamic Attribute Office Expense':
        return Icons.dynamic_form;
      default:
        return Icons.receipt;
    }
  }

  void _clearForm() {
    setState(() {
      _expenseNameController.clear();
      _expenseAmountController.clear();
      _allocateBalanceController.clear();
      _payByController.clear();
      _receivedByController.clear();
      _serviceTIDController.clear();
      _noteController.clear();
      selectedBank = null;
      selectedPaymentType = null;
      selectedExpenseType = null;
    });

    // Reset provider state when clearing form
    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    provider.resetState();
  }

  void _submitExpense(ExpenseProvider provider) {
    if (selectedExpenseType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an expense type"), backgroundColor: Colors.red));
      return;
    }

    if (_expenseNameController.text.trim().isEmpty || _expenseAmountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in required fields"), backgroundColor: Colors.red));
      return;
    }

    if (widget.isEditMode) {
      // Update existing expense
      final updateBody = {
        "tid": widget.expenseData!["tid"],
        "expense_type": selectedExpenseType!,
        "expense_name": _expenseNameController.text.trim(),
        "expense_amount": _expenseAmountController.text.trim(),
        "allocated_amount": _allocateBalanceController.text.trim(),
        "note": _noteController.text.trim(),
        "tag": widget.expenseData!["tag"] ?? "office",
        "pay_by_manager": _payByController.text.trim(),
        "received_by_person": _receivedByController.text.trim(),
        "edit_by": "Admin",
        "payment_status": widget.expenseData!["payment_status"] ?? "paid",
        "payment_type": selectedPaymentType ?? "",
        "bank_ref_id": selectedBank ?? "",
        "service_tid": _serviceTIDController.text.trim(),
        "expense_date": DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDateTime),
      };

      provider.updateExpense(updateBody).then((_) {
        if (provider.state == RequestState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.updateResponse?.message ?? "Expense Updated!"), backgroundColor: Colors.green)
          );
          Navigator.of(context).pop(true); // Return success
        }
      });
    } else {
      // Create new expense
      final expense = ExpenseRequest(
        expenseType: selectedExpenseType!,
        serviceTid: _serviceTIDController.text.trim(),
        expenseName: _expenseNameController.text.trim(),
        expenseAmount: double.tryParse(_expenseAmountController.text.trim()) ?? 0,
        allocatedAmount: double.tryParse(_allocateBalanceController.text.trim()) ?? 0,
        note: _noteController.text.trim(),
        tag: "office",
        payByManager: _payByController.text.trim(),
        receivedByPerson: _receivedByController.text.trim(),
        editBy: "Admin",
        paymentStatus: "paid",
        paymentType: selectedPaymentType,
        bankRefId: selectedBank,
        expenseDate: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDateTime),
      );

      provider.createExpense(expense).then((_) {
        if (provider.state == RequestState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.response?.message ?? "Expense Created!"), backgroundColor: Colors.green)
          );
          Navigator.of(context).pop(false);
        }
      });
    }
  }
}

Future<bool?> showUnifiedOfficeExpenseDialog(BuildContext context, {Map<String, dynamic>? expenseData, bool isEditMode = false}) {
  // Reset provider state before showing dialog
  final provider = Provider.of<ExpenseProvider>(context, listen: false);
  provider.resetState();

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => UnifiedOfficeExpenseDialog(expenseData: expenseData, isEditMode: isEditMode),
  );
}
