import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/banking_payment_method_provider.dart';
import '../../../../providers/banking_payments_provider.dart';
import '../../../../providers/projects_provider.dart';
import '../../../dialogs/custom_fields.dart';

class DialogueBankTransaction extends StatefulWidget {
  final Map<String, dynamic>? paymentData;
  final bool isEditMode;

  const DialogueBankTransaction({super.key, this.paymentData, this.isEditMode = false});

  @override
  State<DialogueBankTransaction> createState() => _DialogueBankTransactionState();
}

class _DialogueBankTransactionState extends State<DialogueBankTransaction> {
  String? selectedBank;
  String? selectedPaymentType;
  String? selectedProject;
  String? selectedPaymentMethod; // Cash, Cheque, Bank
  Map<String, dynamic>? selectedProjectData; // Store full project data

  // Payment types similar to unified office expense dialog
  final List<String> paymentTypes = ['Cash', 'Cheque', 'Bank'];

  late TextEditingController _amountController;
  late TextEditingController _searchController;
  late TextEditingController _paymentByController;
  late TextEditingController _receivedByController;
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;

  // Capitalize first letter helper
  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode && widget.paymentData != null) {
      // Edit mode - populate with existing data
      _searchController = TextEditingController();
      _amountController = TextEditingController(text: widget.paymentData!['total_amount']?.toString() ?? '');
      _paymentByController = TextEditingController(text: widget.paymentData!['pay_by']?.toString() ?? '');
      _receivedByController = TextEditingController(text: widget.paymentData!['received_by']?.toString() ?? '');
      _serviceTIDController = TextEditingController(text: widget.paymentData!['transaction_id']?.toString() ?? '');
      _noteController = TextEditingController(text: widget.paymentData!['note']?.toString() ?? '');

      // Set initial values
      selectedPaymentType = capitalizeFirstLetter(widget.paymentData!['payment_type']?.toString());
      selectedPaymentMethod = capitalizeFirstLetter(widget.paymentData!['payment_method']?.toString());

      print("payment type $selectedPaymentType,  payment method $selectedPaymentMethod");

      selectedBank = widget.paymentData!['bank_ref_id']?.toString();

      // Set project data if available
      if (widget.paymentData!['type_ref'] != null) {
        selectedProject = widget.paymentData!['type_ref']?.toString();
        // Create mock project data for display
        selectedProjectData = {
          'project_ref_id': widget.paymentData!['type_ref'],
          'client_id': {'client_ref_id': widget.paymentData!['client_ref'], 'name': 'Client from Payment Data'},
        };
      }
    } else {
      // Add mode - default values
      _searchController = TextEditingController();
      _amountController = TextEditingController();
      _paymentByController = TextEditingController();
      _receivedByController = TextEditingController();
      _serviceTIDController = TextEditingController();
      _noteController = TextEditingController();
    }

    // Load data when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final paymentMethodProvider = context.read<BankingPaymentMethodProvider>();
        final projectsProvider = context.read<ProjectsProvider>();
        paymentMethodProvider.getAllPaymentMethods();
        projectsProvider.getAllProjects();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 400),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditMode ? "Edit Banking Payment" : "Client Transactions",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.isEditMode ? "Ref: ${widget.paymentData?['payment_ref_id'] ?? 'N/A'}" : "TID. 00001-292382",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(_formattedDate(), style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
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
                                      child: const Text("Keep Changes ", style: TextStyle(color: Colors.blue)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text("Close", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldClose == true) {
                            Navigator.of(context).pop(); // close the dialog
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // Payment Type Selection
                  CustomDropdownField(
                    label: "Payment Type",
                    selectedValue: selectedPaymentMethod,
                    options: paymentTypes,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                        // Reset bank and service TID when changing payment type
                        if (value != 'Bank') {
                          selectedBank = null;
                          _serviceTIDController.clear();
                        }
                      });
                    },
                  ),
                  CustomDropdownField(
                    label: "Payment",
                    selectedValue: selectedPaymentType,
                    options: ["In", "Out"],
                    onChanged: (value) => setState(() => selectedPaymentType = value),
                  ),
                  CustomTextField(label: "Amount", controller: _amountController, hintText: '300'),
                  // Project Selection
                  Consumer<ProjectsProvider>(
                    builder: (context, projectsProvider, child) {
                      final projects =
                          projectsProvider.projects.where((project) => project['project_ref_id']?.toString().isNotEmpty == true).toList();

                      return CustomDropdownField(
                        label: "Select Project",
                        selectedValue: selectedProject,
                        options: [
                          'Select Project',
                          ...projects.map((p) => '${p['project_ref_id']} - ${p['client_id']?['name'] ?? 'Unknown Client'}'),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedProject = value == 'Select Project' ? null : value;
                            if (value != null && value != 'Select Project') {
                              // Find and store the full project data
                              selectedProjectData = projects.firstWhere(
                                (p) => '${p['project_ref_id']} - ${p['client_id']?['name'] ?? 'Unknown Client'}' == value,
                                orElse: () => {},
                              );
                            } else {
                              selectedProjectData = null;
                            }
                          });
                        },
                      );
                    },
                  ),
                  CustomTextField(label: "Payment By", controller: _paymentByController, hintText: "John Doe"),
                  CustomTextField(label: "Received By", controller: _receivedByController, hintText: 'Auto fill'),

                  // Bank and Service TID (only show when payment type is Bank)
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
                    CustomTextField(label: "Service TID", controller: _serviceTIDController, hintText: 'Bank Transaction ID '),
                  ],

                  // Cheque No (only show when payment type is Cheque)
                  if (selectedPaymentMethod == 'Cheque') ...[
                    CustomTextField(label: "Cheque No", controller: _serviceTIDController, hintText: 'Cheque No'),
                  ],

                  CustomTextField(label: "Note", controller: _noteController, hintText: 'xxxx'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                    onPressed: () {
                      _clearForm();
                    },
                    text: "Clear",
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Consumer<BankingPaymentsProvider>(
                    builder: (context, bankingProvider, child) {
                      return CustomButton(
                        onPressed:
                            bankingProvider.isLoading
                                ? () {}
                                : () {
                                  widget.isEditMode ? _updatePayment() : _submitForm();
                                },
                        text:
                            bankingProvider.isLoading
                                ? (widget.isEditMode ? "Updating..." : "Submitting...")
                                : (widget.isEditMode ? "Update" : "Submit"),
                        backgroundColor: Colors.green,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  }

  void _clearForm() {
    setState(() {
      selectedBank = null;
      selectedPaymentType = null;
      selectedProject = null;
      selectedPaymentMethod = null;
      selectedProjectData = null;
      _amountController.clear();
      _searchController.clear();
      _paymentByController.clear();
      _receivedByController.clear();
      _serviceTIDController.clear();
      _noteController.clear();
    });
  }

  void _submitForm() async {
    // Validate required fields
    if (selectedPaymentMethod == null || selectedPaymentType == null || selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    // Validate bank selection if payment method is Bank
    if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a bank for bank payment')));
      return;
    }

    if (_amountController.text.isEmpty || _paymentByController.text.isEmpty || _receivedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    // Submit the form
    final bankingProvider = context.read<BankingPaymentsProvider>();

    // Extract project ref ID and client ref ID from selected project data
    final projectRefId = selectedProjectData?['project_ref_id']?.toString() ?? selectedProject!;
    final clientRefId = selectedProjectData?['client_id']?['client_ref_id']?.toString() ?? '';

    await bankingProvider.addBankingPayment(
      type: 'project',
      typeRef: projectRefId,
      clientRef: clientRefId,
      // Using actual client ref ID from project data
      paymentType: selectedPaymentType!.toLowerCase(),
      payBy: _paymentByController.text,
      receivedBy: _receivedByController.text,
      totalAmount: amount,
      paidAmount: amount,
      status: 'completed',
      paymentMethod: selectedPaymentMethod!.toLowerCase(),
      transactionId: _serviceTIDController.text.isNotEmpty ? _serviceTIDController.text : null,
      bankRefId: selectedBank,
      chequeNo: selectedPaymentMethod == 'Cheque' && _serviceTIDController.text.isNotEmpty ? _serviceTIDController.text : null,
    );

    // Check if submission was successful
    if (bankingProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.successMessage!)));
      _clearForm();
      Navigator.of(context).pop();
    } else if (bankingProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.errorMessage!)));
    }
  }

  void _updatePayment() async {
    // Validate required fields
    if (selectedPaymentMethod == null || selectedPaymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    // Validate bank selection if payment method is Bank
    if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a bank for bank payment')));
      return;
    }

    if (_amountController.text.isEmpty || _paymentByController.text.isEmpty || _receivedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    // Update the payment
    final bankingProvider = context.read<BankingPaymentsProvider>();

    await bankingProvider.updateBankingPayment(
      id: widget.paymentData!['id']?.toString(),
      paymentRefId: widget.paymentData!['payment_ref_id']?.toString(),
      paymentType: selectedPaymentType!.toLowerCase(),
      payBy: _paymentByController.text,
      receivedBy: _receivedByController.text,
      totalAmount: amount,
      paidAmount: amount,
      status: 'completed',
      paymentMethod: selectedPaymentMethod!.toLowerCase(),
      transactionId: _serviceTIDController.text.isNotEmpty ? _serviceTIDController.text : null,
      bankRefId: selectedBank,
      chequeNo: selectedPaymentMethod == 'Cheque' && _serviceTIDController.text.isNotEmpty ? _serviceTIDController.text : null,
    );

    // Check if update was successful
    if (bankingProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.successMessage!)));
      Navigator.of(context).pop();
    } else if (bankingProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.errorMessage!)));
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true, double width = 220}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    double width = 220,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          border: const OutlineInputBorder(),
        ),
        items: options.map((String val) => DropdownMenuItem<String>(value: val, child: Text(val))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

void showBankTransactionDialog(BuildContext context) {
  showDialog(context: context, barrierDismissible: false, builder: (context) => const DialogueBankTransaction());
}

Widget _buildTextFieldSearch(String label, TextEditingController controller, {bool enabled = true, double width = 220}) {
  return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        suffixIcon: Icon(Icons.search, color: Colors.grey),
      ),
    ),
  );
}
