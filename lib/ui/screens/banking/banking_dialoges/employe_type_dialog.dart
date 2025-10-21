import 'dart:convert';
import 'dart:io';

import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../providers/employee_payments_provider.dart';
import '../../../../providers/banking_payment_method_provider.dart';
import '../../../../providers/documents_provider.dart';
import '../../../../employee/EmployeeProvider.dart';
import '../../../dialogs/calender.dart';
import '../../../dialogs/custom_fields.dart';

class DialogEmployeType extends StatefulWidget {
  final Map<String, dynamic>? paymentData;
  final bool isEditMode;

  const DialogEmployeType({super.key, this.paymentData, this.isEditMode = false});

  @override
  State<DialogEmployeType> createState() => _DialogEmployeTypeState();
}

class _DialogEmployeTypeState extends State<DialogEmployeType> {
  DateTime selectedDateTime = DateTime.now();
  String? selectedBank;
  String? selectedPaymentMethod; // Cash, Cheque, Bank
  String? selectedEmployeeType; // salary, bonus, return (pay and advance commented out)
  String? selectedEmployee;
  dynamic selectedEmployeeData;

  // Document related variables
  List<String> uploadedDocumentIds = [];
  List<Map<String, dynamic>> employeeDocuments = [];
  dynamic selectedFile; // Use dynamic to handle both File and PlatformFile
  String? selectedFileName;
  Uint8List? selectedFileBytes; // For web compatibility
  bool _isProcessing = false;
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController documentIssueDateController = TextEditingController();
  final TextEditingController documentExpiryDateController = TextEditingController();

  // Payment types for employee transactions
  final List<String> employeeTypes = ['salary', /*'pay',*/ 'bonus', /*'advance',*/ 'return'];

  late TextEditingController _amountController;
  late TextEditingController _paymentByController;
  late TextEditingController _receivedByController;
  final TextEditingController _issueDateController = TextEditingController();
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;
  late TextEditingController _monthYearController;

  // Capitalize first letter helper
  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<String> getCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    return name ?? '';
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode && widget.paymentData != null) {
      // Edit mode - populate with existing data
      _amountController = TextEditingController(text: widget.paymentData!['amount']?.toString() ?? '');
      _paymentByController = TextEditingController(text: widget.paymentData!['pay_by']?.toString() ?? '');
      _receivedByController = TextEditingController(text: widget.paymentData!['received_by']?.toString() ?? '');
      _serviceTIDController = TextEditingController(text: widget.paymentData!['transaction_id']?.toString() ?? '');
      _noteController = TextEditingController(text: widget.paymentData!['description']?.toString() ?? '');
      _monthYearController = TextEditingController(text: widget.paymentData!['month_year']?.toString() ?? '');

      // Set initial values
      selectedEmployeeType = widget.paymentData!['type']?.toString();
      selectedPaymentMethod = widget.paymentData!['payment_method']?.toString().toLowerCase();
      selectedBank = widget.paymentData!['bank_ref_id']?.toString();
      selectedEmployee = widget.paymentData!['employee_ref_id']?.toString();

      // Parse date if available
      if (widget.paymentData!['created_at'] != null) {
        try {
          selectedDateTime = DateTime.parse(widget.paymentData!['created_at']);
        } catch (e) {
          selectedDateTime = DateTime.now();
        }
      }
    } else {
      // Add mode - default values
      _amountController = TextEditingController();
      _paymentByController = TextEditingController();
      _receivedByController = TextEditingController();
      _serviceTIDController = TextEditingController();
      _noteController = TextEditingController();
      _monthYearController = TextEditingController(text: DateFormat('MMMM yyyy').format(DateTime.now()));

      /*// Set default username for received by
      getCurrentUserName().then((name) {
        if (mounted) {
          _paymentByController.text = name;
        }
      });*/
    }

    // Load data when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final paymentMethodProvider = context.read<BankingPaymentMethodProvider>();
        final employeeProvider = context.read<EmployeeProvider>();
        paymentMethodProvider.getAllPaymentMethods();
        employeeProvider.getFullData();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paymentByController.dispose();
    _receivedByController.dispose();
    _serviceTIDController.dispose();
    _noteController.dispose();
    _monthYearController.dispose();
    documentNameController.dispose();
    documentIssueDateController.dispose();
    documentExpiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeePaymentsProvider>(
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
                        widget.isEditMode ? "Edit Employee Payment" : "Employee Payment Management",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Employee Type Selection
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
                          widget.isEditMode ? "Payment Type (Read Only)" : "Select Payment Type",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children:
                              employeeTypes.map((type) {
                                final isSelected = selectedEmployeeType == type;
                                return GestureDetector(
                                  onTap:
                                      widget.isEditMode
                                          ? null
                                          : () {
                                            setState(() {
                                              selectedEmployeeType = type;
                                              // Update fields when payment type changes
                                              if (selectedEmployeeData != null) {
                                                _updateFieldsBasedOnPaymentType();
                                              }
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
                                      capitalizeFirstLetter(type),
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
                              "Payment type cannot be changed in edit mode",
                              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Form Fields
                  if (selectedEmployeeType != null) ...[
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
                              Icon(_getPaymentTypeIcon(selectedEmployeeType!), color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                capitalizeFirstLetter(selectedEmployeeType!),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Common fields for all payment types
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              // Employee Selection
                              Consumer<EmployeeProvider>(
                                builder: (context, employeeProvider, child) {
                                  final employees = employeeProvider.employees ?? [];
                                  return CustomDropdownWithSearch(
                                    label: "Select Employee",
                                    selectedValue: selectedEmployee,
                                    options: [
                                      'Select Employee',
                                      ...employees.map((emp) => '${emp.employeeName} - ${emp.userId}'),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedEmployee = value == 'Select Employee' ? null : value;
                                        if (value != null && value != 'Select Employee') {
                                          selectedEmployeeData = employees.firstWhere(
                                            (emp) => '${emp.employeeName} - ${emp.userId}' == value,
                                            orElse: () => null as dynamic,
                                          );
                                          // Auto-fill fields based on payment type
                                          if (selectedEmployeeData != null) {
                                            _updateFieldsBasedOnPaymentType();
                                          }
                                        } else {
                                          selectedEmployeeData = null;
                                          _clearPaymentFields();
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                              if (selectedEmployeeType == 'salary') ...[
                                CustomTextField(
                                  label: "Amount",
                                  controller: _amountController,
                                  hintText: '500.00',
                                  keyboardType: TextInputType.number,
                                  enabled: false,
                                ),
                              ] else ...[
                                CustomTextField(
                                  label: "Amount",
                                  controller: _amountController,
                                  hintText: '500.00',
                                  keyboardType: TextInputType.number,
                                ),
                              ],

                              _buildMonthYearPicker(),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Conditional fields based on payment type
                          if (selectedEmployeeType == 'salary') ...[
                            // Salary form - simple fields
                            _buildTextField("Note", _noteController, width: double.infinity),
                            
                            const SizedBox(height: 20),
                            
                            // Document Upload Section
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Document Upload',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      CustomTextField(
                                        label: "Document Name",
                                        controller: documentNameController,
                                        hintText: "e.g., Salary Slip",
                                      ),
                                      CustomDateNotificationField(
                                        label: "Issue Date",
                                        controller: documentIssueDateController,
                                        readOnly: true,
                                        hintText: "yyyy-MM-dd",
                                        onTap: () => _pickDocumentDate(documentIssueDateController),
                                      ),
                                      CustomDateNotificationField(
                                        label: "Expiry Date",
                                        controller: documentExpiryDateController,
                                        readOnly: true,
                                        hintText: "yyyy-MM-dd",
                                        onTap: () => _pickDocumentDate(documentExpiryDateController),
                                      ),
                                      Consumer<DocumentsProvider>(
                                        builder: (context, documentsProvider, child) {
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (documentsProvider.isUploading || _isProcessing)
                                                        ? null
                                                        : () {
                                                            Future.microtask(() {
                                                              _handleDocumentAction();
                                                            });
                                                          },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: (documentsProvider.isUploading || _isProcessing)
                                                            ? Colors.grey
                                                            : _getDocumentButtonColor(),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      constraints: const BoxConstraints(minWidth: 150, minHeight: 38),
                                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          if (documentsProvider.isUploading)
                                                            const SizedBox(
                                                              width: 16,
                                                              height: 16,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                              ),
                                                            )
                                                          else
                                                            Icon(_getDocumentButtonIcon(), size: 16, color: Colors.white),
                                                          const SizedBox(width: 6),
                                                          Text(
                                                            _getDocumentButtonText(),
                                                            style: const TextStyle(fontSize: 14, color: Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  if (documentsProvider.isUploading)
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          documentsProvider.resetLoadingState();
                                                          setState(() {
                                                            selectedFile = null;
                                                            selectedFileName = null;
                                                            selectedFileBytes = null;
                                                          });
                                                        },
                                                        icon: const Icon(Icons.close, color: Colors.red),
                                                        tooltip: 'Cancel Upload',
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              if (documentsProvider.isUploading)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: LinearProgressIndicator(
                                                    value: documentsProvider.uploadProgress,
                                                    backgroundColor: Colors.grey[300],
                                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  if (selectedFileName != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Selected: $selectedFileName',
                                        style: const TextStyle(fontSize: 12, color: Colors.green),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Document List Section
                            if (employeeDocuments.isNotEmpty || uploadedDocumentIds.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Attached Documents',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        // Existing documents
                                        ...employeeDocuments.map(
                                          (doc) => _buildDocumentItem(
                                            name: doc['name'] ?? 'Unknown Document',
                                            issueDate: doc['issue_date'] ?? '',
                                            expiryDate: doc['expire_date'] ?? '',
                                            documentRefId: doc['document_ref_id'] ?? '',
                                            isExisting: true,
                                            url: doc['url'],
                                          ),
                                        ),
                                        
                                        // Newly uploaded documents
                                        ...uploadedDocumentIds.map(
                                          (docId) => _buildDocumentItem(
                                            name: 'New Document',
                                            issueDate: '',
                                            expiryDate: '',
                                            documentRefId: docId,
                                            isExisting: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ] else if (selectedEmployeeType == 'return') ...[
                            // Employee returns to company
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                CustomTextField(
                                  label: "Payment By",
                                  controller: _paymentByController,
                                  hintText: 'Payment By',
                                  enabled: false, // Always selected employee
                                ),
                                CustomTextField(
                                  label: "Received By",
                                  controller: _receivedByController,
                                  hintText: 'Received By',
                                  enabled: false, // Always current user for returns
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildPaymentMethodFields(),
                            const SizedBox(height: 16),
                            _buildTextField("Note", _noteController, width: double.infinity),
                          ] else if (['bonus'].contains(selectedEmployeeType)) ...[
                            // Company pays employee
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                CustomTextField(
                                  label: "Payment By",
                                  controller: _paymentByController,
                                  hintText: 'Payment By',
                                  enabled: false, // Always current user for company payments
                                ),
                                CustomTextField(
                                  label: "Received By",
                                  controller: _receivedByController,
                                  hintText: 'Received By',
                                  enabled: false, // Always selected employee
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildPaymentMethodFields(),
                            const SizedBox(height: 16),
                            _buildTextField("Note", _noteController, width: double.infinity),
                          ],
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
                          if (provider.isLoading) const LinearProgressIndicator(),

                          if (provider.errorMessage != null)
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
                                  Expanded(
                                    child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),

                          if (provider.successMessage != null)
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
                                    child: Text(provider.successMessage!, style: const TextStyle(color: Colors.green)),
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
                                  text: "Clear",
                                  backgroundColor: Colors.blue,
                                  onPressed: () => _clearForm(),
                                ),
                                const SizedBox(width: 12),
                              ],
                              CustomButton(
                                text: widget.isEditMode ? "Update Payment" : "Save & Close",
                                backgroundColor: Colors.green,
                                onPressed:
                                    provider.isLoading
                                        ? () {}
                                        : () => widget.isEditMode ? _updatePayment() : _submitForm(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // No payment type selected
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
                            Icon(Icons.person_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "Please select a payment type to continue",
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

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  }

  IconData _getPaymentTypeIcon(String paymentType) {
    switch (paymentType.toLowerCase()) {
      case 'salary':
        return Icons.account_balance_wallet;
      case 'pay':
        return Icons.payment;
      case 'bonus':
        return Icons.stars;
      case 'advance':
        return Icons.trending_up;
      case 'return':
        return Icons.keyboard_return;
      default:
        return Icons.attach_money;
    }
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

  Widget _buildPaymentMethodFields() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        CustomDropdownField(
          label: "Payment Method",
          selectedValue: selectedPaymentMethod,
          options: ['Cash', 'Cheque', 'Bank'],
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value;
              if (value != 'Bank') {
                selectedBank = null;
                _serviceTIDController.clear();
              }
            });
          },
        ),
        // Bank and Service TID (only show when payment method is Bank)
        if (selectedPaymentMethod == 'Bank') ...[
          Consumer<BankingPaymentMethodProvider>(
            builder: (context, paymentMethodProvider, child) {
              final banks =
                  paymentMethodProvider.paymentMethods
                      .map((pm) => pm['bank_name']?.toString() ?? '')
                      .where((name) => name.isNotEmpty)
                      .toSet()
                      .toList();

              return CustomDropdownField(
                label: 'Select Bank',
                selectedValue: selectedBank,
                options: ['Select Bank', ...banks],
                onChanged: (value) {
                  setState(() {
                    selectedBank = value == 'Select Bank' ? null : value;
                  });
                },
              );
            },
          ),
          CustomTextField(label: "Service TID", controller: _serviceTIDController, hintText: 'Bank Transaction ID'),
        ],
        if (selectedPaymentMethod == 'Cheque') ...[
          CustomTextField(label: "Cheque No", controller: _serviceTIDController, hintText: 'Cheque No'),
        ],
      ],
    );
  }

  void _updateFieldsBasedOnPaymentType() async {
    if (selectedEmployeeData == null || selectedEmployeeType == null) return;

    final currentUserName = await getCurrentUserName();
    final employeeName = selectedEmployeeData!.employeeName ?? '';

    if (selectedEmployeeType == 'salary') {
      // Salary: Pre-fill with employee salary but keep it editable
      if (selectedEmployeeData!.salary != null) {
        _amountController.text = selectedEmployeeData!.salary.toString();
      }
    } else if (['bonus'].contains(selectedEmployeeType)) {
      // Company pays employee: Payment By = current user, Received By = employee
      _paymentByController.text = currentUserName;
      _receivedByController.text = employeeName;
      _amountController.text = '';
    } else if (selectedEmployeeType == 'return') {
      // Employee returns to company: Payment By = employee, Received By = current user
      _paymentByController.text = employeeName;
      _receivedByController.text = currentUserName;
      _amountController.text = '';
    }
  }

  void _clearPaymentFields() {
    _paymentByController.clear();
    _receivedByController.clear();
    _amountController.clear();
  }

  // Document related methods
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'tif'],
        allowMultiple: false,
        withData: true,
        withReadStream: false,
        allowCompression: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        setState(() {
          if (kIsWeb) {
            selectedFile = file;
            selectedFileBytes = file.bytes;
            selectedFileName = file.name;
          } else {
            if (file.path != null && file.path!.isNotEmpty) {
              selectedFile = File(file.path!);
              selectedFileName = file.name;
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${file.name}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('File picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _uploadDocument() async {
    if (_isProcessing) return;

    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a file first')));
      return;
    }

    if (documentNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter document name')));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    final documentsProvider = context.read<DocumentsProvider>();
    String? documentRefId;

    try {
      if (kIsWeb) {
        if (selectedFileBytes != null) {
          documentRefId = await documentsProvider.addDocumentWeb(
            name: documentNameController.text.trim(),
            issueDate: documentIssueDateController.text.trim().isNotEmpty
                ? documentIssueDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            expireDate: documentExpiryDateController.text.trim().isNotEmpty
                ? documentExpiryDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 365))),
            fileBytes: selectedFileBytes!,
            fileName: selectedFileName ?? 'document',
          );
        }
      } else {
        if (selectedFile is File) {
          documentRefId = await documentsProvider.addDocument(
            name: documentNameController.text.trim(),
            issueDate: documentIssueDateController.text.trim().isNotEmpty
                ? documentIssueDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            expireDate: documentExpiryDateController.text.trim().isNotEmpty
                ? documentExpiryDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 365))),
            file: selectedFile as File,
          );
        }
      }

      if (documentRefId != null) {
        if (mounted) {
          setState(() {
            uploadedDocumentIds.add(documentRefId!);
            selectedFile = null;
            selectedFileName = null;
            selectedFileBytes = null;
            documentNameController.clear();
            documentIssueDateController.clear();
            documentExpiryDateController.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Document uploaded successfully: $documentRefId'), backgroundColor: Colors.green),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(documentsProvider.errorMessage ?? 'Failed to upload document'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Upload failed: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _handleDocumentAction() {
    if (selectedFile == null) {
      _pickFile();
    } else if (documentNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter document name')));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _uploadDocument();
      });
    }
  }

  Color _getDocumentButtonColor() {
    if (selectedFile == null) {
      return Colors.blue; // Select Document
    } else if (documentNameController.text.trim().isEmpty) {
      return Colors.orange; // Enter name
    } else {
      return Colors.green; // Upload
    }
  }

  IconData _getDocumentButtonIcon() {
    if (selectedFile == null) {
      return Icons.attach_file; // Select Document
    } else if (documentNameController.text.trim().isEmpty) {
      return Icons.edit; // Enter name
    } else {
      return Icons.upload; // Upload
    }
  }

  String _getDocumentButtonText() {
    if (selectedFile == null) {
      return 'Select Document';
    } else if (documentNameController.text.trim().isEmpty) {
      return 'Enter Name';
    } else {
      return 'Upload';
    }
  }

  void _pickDocumentDate(TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).then((date) {
      if (date != null) {
        controller.text = DateFormat('yyyy-MM-dd').format(date);
      }
    });
  }

  Widget _buildDocumentItem({
    required String name,
    required String issueDate,
    required String expiryDate,
    required String documentRefId,
    required bool isExisting,
    String? url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: isExisting ? Colors.blue : Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (issueDate.isNotEmpty || expiryDate.isNotEmpty)
                  Text(
                    'Issue: $issueDate | Expiry: $expiryDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                Text('ID: $documentRefId', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _downloadDocument(documentRefId, url: url),
                icon: const Icon(Icons.download, color: Colors.blue, size: 20),
                tooltip: 'Download Document',
              ),
              IconButton(
                onPressed: () => _deleteDocument(documentRefId),
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                tooltip: 'Delete Document',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _downloadDocument(String documentRefId, {String? url}) {
    final downloadUrl = url ?? 'No URL available';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading document: $documentRefId\nURL: $downloadUrl'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _deleteDocument(String documentRefId) async {
    final documentsProvider = context.read<DocumentsProvider>();
    final success = await documentsProvider.deleteDocument(documentRefId: documentRefId);

    if (success) {
      setState(() {
        employeeDocuments.removeWhere((doc) => doc['document_ref_id'] == documentRefId);
        uploadedDocumentIds.remove(documentRefId);
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document deleted successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(documentsProvider.errorMessage ?? 'Failed to delete document'),
        ),
      );
    }
  }

  // DateTime Picker Field
  /*  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: _selectDateTime,
        child: InputDecorator(
          decoration: const InputDecoration(
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            labelText: "Date and Time",
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            suffixIcon: Icon(Icons.calendar_month, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }*/

  Widget _buildMonthYearPicker() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: _selectMonthYear,
        child: InputDecorator(
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            labelText: "Month/Year",
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            suffixIcon: Icon(Icons.calendar_month, color: Colors.red),
          ),
          child: Text(
            _monthYearController.text.isEmpty
                ? DateFormat('MMMM yyyy').format(DateTime.now())
                : _monthYearController.text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  /*
  void _selectDateTime() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: CustomCupertinoCalendar(
            onDateTimeChanged: (date) {
              selectedDate = date;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDateTime = selectedDate;
                });
                _issueDateController.text =
                    "${selectedDate.day}-${selectedDate.month}-${selectedDate.year} "
                    "${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}";
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
*/

  void _selectMonthYear() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime currentDate = DateTime.now();
        if (_monthYearController.text.isNotEmpty) {
          try {
            currentDate = DateFormat('MMMM yyyy').parse(_monthYearController.text);
          } catch (e) {
            currentDate = DateTime.now();
          }
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.white,
              title: const Text(
                "Select Month & Year",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 500,
                height: 200,
                child: Row(
                  children: [
                    // Year Picker
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month_outlined, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Year",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 10, // Show 5 years before and after current year
                                itemBuilder: (context, index) {
                                  int year = currentDate.year - 5 + index;
                                  bool isSelected = year == currentDate.year;

                                  return GestureDetector(
                                    onTap: () {
                                      setDialogState(() {
                                        currentDate = DateTime(year, currentDate.month);
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.red : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        year.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                    ),
                    const SizedBox(width: 16),
                    // Month Picker
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_view_month, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Month",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.5,
                                ),
                                itemCount: 12,
                                itemBuilder: (context, index) {
                                  final months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec',
                                  ];
                                  bool isSelected = index + 1 == currentDate.month;

                                  return GestureDetector(
                                    onTap: () {
                                      setDialogState(() {
                                        currentDate = DateTime(currentDate.year, index + 1);
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.red : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: isSelected ? Colors.red : Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          months[index],
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            fontSize: 12,
                                          ),
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
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _monthYearController.text = DateFormat('MMMM yyyy').format(currentDate);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("OK", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _clearForm() {
    setState(() {
      selectedBank = null;
      selectedEmployeeType = null;
      selectedPaymentMethod = null;
      selectedEmployee = null;
      selectedEmployeeData = null;
      selectedDateTime = DateTime.now();
      _amountController.clear();
      _paymentByController.clear();
      _receivedByController.clear();
      _serviceTIDController.clear();
      _noteController.clear();
      _monthYearController.text = DateFormat('MMMM yyyy').format(DateTime.now());
      _issueDateController.clear();
      // Clear document fields
      selectedFile = null;
      selectedFileName = null;
      selectedFileBytes = null;
      uploadedDocumentIds.clear();
      employeeDocuments.clear();
      documentNameController.clear();
      documentIssueDateController.clear();
      documentExpiryDateController.clear();
    });

    // Set default username for received by
    getCurrentUserName().then((name) {
      if (mounted) {
        _paymentByController.text = name;
      }
    });

    // Reset provider state when clearing form
    final provider = Provider.of<EmployeePaymentsProvider>(context, listen: false);
    provider.clearMessages();
  }

  void _submitForm() async {
    // Validate required fields
    if (selectedEmployeeType == null || selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select payment type and employee')));
      return;
    }

    // Validate fields based on payment type
    if (selectedEmployeeType == 'salary') {
      // Salary validation
      if (_amountController.text.isEmpty || _monthYearController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in amount and month/year')));
        return;
      }
    } else if (['bonus', 'return'].contains(selectedEmployeeType)) {
      // Payment/Return validation
      if (_amountController.text.isEmpty ||
          _monthYearController.text.isEmpty ||
          _paymentByController.text.isEmpty ||
          _receivedByController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
        return;
      }

      // Validate payment method for non-salary transactions
      if (selectedPaymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a payment method')));
        return;
      }

      // Validate bank selection if payment method is Bank
      if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a bank for bank payment')));
        return;
      }
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    // Submit the form
    final employeePaymentsProvider = context.read<EmployeePaymentsProvider>();

    // Extract employee ref ID from selected employee
    final employeeRefId = selectedEmployeeData?.userId?.toString() ?? selectedEmployee?.split(' - ')[0] ?? '';

    await employeePaymentsProvider.addEmployeePayment(
      employeeRefId: employeeRefId,
      monthYear: _monthYearController.text.trim(),
      amount: amount,
      type: selectedEmployeeType!,
      description: _noteController.text.trim(),
      // Banking-related parameters for non-salary payments
      payBy: selectedEmployeeType != 'salary' ? _paymentByController.text.trim() : null,
      receivedBy: selectedEmployeeType != 'salary' ? _receivedByController.text.trim() : null,
      status: selectedEmployeeType != 'salary' ? 'completed' : null,
      paymentMethod: selectedEmployeeType != 'salary' ? selectedPaymentMethod : null,
      chequeNo:
          selectedEmployeeType != 'salary' && selectedPaymentMethod == 'Cheque'
              ? _serviceTIDController.text.trim()
              : null,
      transactionId:
          selectedEmployeeType != 'salary' && selectedPaymentMethod == 'Bank'
              ? _serviceTIDController.text.trim()
              : null,
      bankRefId: selectedEmployeeType != 'salary' && selectedPaymentMethod == 'Bank' ? selectedBank : null,
    );

    // Check if submission was successful
    if (employeePaymentsProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(employeePaymentsProvider.successMessage!)));
      Navigator.of(context).pop();
    } else if (employeePaymentsProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(employeePaymentsProvider.errorMessage!)));
    }
  }

  void _updatePayment() async {
    // Validate required fields
    if (selectedEmployeeType == null || selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select payment type and employee')));
      return;
    }

    // Validate fields based on payment type
    if (selectedEmployeeType == 'salary') {
      // Salary validation
      if (_amountController.text.isEmpty || _monthYearController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in amount and month/year')));
        return;
      }
    } else if (['bonus', 'return'].contains(selectedEmployeeType)) {
      // Payment/Return validation
      if (_amountController.text.isEmpty ||
          _monthYearController.text.isEmpty ||
          _paymentByController.text.isEmpty ||
          _receivedByController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
        return;
      }

      // Validate payment method for non-salary transactions
      if (selectedPaymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a payment method')));
        return;
      }

      // Validate bank selection if payment method is Bank
      if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a bank for bank payment')));
        return;
      }
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    // Update the payment
    final employeePaymentsProvider = context.read<EmployeePaymentsProvider>();

    // Extract employee ref ID from selected employee
    final employeeRefId = selectedEmployeeData?.userId?.toString() ?? selectedEmployee?.split(' - ')[0] ?? '';

    await employeePaymentsProvider.updateEmployeePayment(
      // id: widget.paymentData!['id']?.toString(),
      employeePaymentRefId: widget.paymentData!['employee_payment_ref_id']?.toString(),
      employeeRefId: employeeRefId,
      monthYear: _monthYearController.text.trim(),
      amount: amount,
      type: selectedEmployeeType!,
      description: _noteController.text.trim(),
      // Banking-related parameters for non-salary payments
      payBy: selectedEmployeeType != 'salary' ? _paymentByController.text.trim() : null,
      receivedBy: selectedEmployeeType != 'salary' ? _receivedByController.text.trim() : null,
      status: selectedEmployeeType != 'salary' ? 'completed' : null,
      paymentMethod: selectedEmployeeType != 'salary' ? selectedPaymentMethod : null,
      chequeNo:
          selectedEmployeeType != 'salary' && selectedPaymentMethod == 'Cheque'
              ? _serviceTIDController.text.trim()
              : null,
      transactionId:
          selectedEmployeeType != 'salary' && selectedPaymentMethod == 'Bank'
              ? _serviceTIDController.text.trim()
              : null,
      bankRefId: selectedEmployeeType != 'salary' && selectedPaymentMethod == 'Bank' ? selectedBank : null,
    );

    // Check if update was successful
    if (employeePaymentsProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(employeePaymentsProvider.successMessage!)));
      Navigator.of(context).pop();
    } else if (employeePaymentsProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(employeePaymentsProvider.errorMessage!)));
    }
  }
}

Future<bool?> showEmployeeTypeDialog(
  BuildContext context, {
  Map<String, dynamic>? paymentData,
  bool isEditMode = false,
}) {
  // Reset provider state before showing dialog
  final provider = Provider.of<EmployeePaymentsProvider>(context, listen: false);
  provider.clearMessages();

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => DialogEmployeType(paymentData: paymentData, isEditMode: isEditMode),
  );
}
