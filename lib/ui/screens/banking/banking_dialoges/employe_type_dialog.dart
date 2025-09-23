import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../providers/banking_payment_method_provider.dart';
import '../../../../providers/banking_payments_provider.dart';
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
  String? selectedPaymentType;
  String? selectedPaymentMethod; // Cash, Cheque, Bank

  // Payment types similar to unified office expense dialog
  final List<String> paymentTypes = ['Cash', 'Cheque', 'Bank'];

  late TextEditingController _amountController;
  late TextEditingController _paymentByController;
  late TextEditingController _receivedByController;
  final TextEditingController _issueDateController = TextEditingController();
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    
    if (widget.isEditMode && widget.paymentData != null) {
      // Edit mode - populate with existing data
      _amountController = TextEditingController(text: widget.paymentData!['total_amount']?.toString() ?? '');
      _paymentByController = TextEditingController(text: widget.paymentData!['pay_by']?.toString() ?? '');
      _receivedByController = TextEditingController(text: widget.paymentData!['received_by']?.toString() ?? '');
      _serviceTIDController = TextEditingController(text: widget.paymentData!['transaction_id']?.toString() ?? '');
      _noteController = TextEditingController(text: widget.paymentData!['note']?.toString() ?? '');
      
      // Set initial values
      selectedPaymentType = widget.paymentData!['payment_type']?.toString().toLowerCase();
      selectedPaymentMethod = widget.paymentData!['payment_method']?.toString().toLowerCase();
      selectedBank = widget.paymentData!['bank_ref_id']?.toString();
      
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
      _paymentByController = TextEditingController(text: "Auto Fill: John Doe");
      _receivedByController = TextEditingController(text: "Auto Fill: Jane Smith");
      _serviceTIDController = TextEditingController();
      _noteController = TextEditingController();
    }
    
    // Load data when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final paymentMethodProvider = context.read<BankingPaymentMethodProvider>();
        paymentMethodProvider.getAllPaymentMethods();
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditMode ? "Edit Banking Payment" : "Employee Transactions",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.isEditMode 
                          ? "Ref: ${widget.paymentData?['payment_ref_id'] ?? 'N/A'}"
                          : "TID. 00001-292382", 
                        style: const TextStyle(fontSize: 12)
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _formattedDate(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          final shouldClose = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: const Text("Are you sure?"),
                                  content: const Text(
                                    "Do you want to close this form? Unsaved changes may be lost.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text(
                                        "Keep Changes ",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(color: Colors.red),
                                      ),
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
              // Form Fields
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildDateTimeField(),
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
                    onChanged:
                        (val) => setState(() => selectedPaymentType = val),
                  ),
                  CustomTextField(
                    label: "Amount",
                    controller: _amountController,
                    hintText: '500',
                  ),
                  CustomTextField(
                    label: "Payment By",
                    controller: _paymentByController,
                    hintText: 'John Doe',
                  ),
                  CustomTextField(
                    label: "Received By",
                    controller: _receivedByController,
                    hintText: 'Smith',
                  ),
                  
                  // Bank and Service TID (only show when payment type is Bank)
                  if (selectedPaymentMethod == 'Bank') ...[
                    Consumer<BankingPaymentMethodProvider>(
                      builder: (context, paymentMethodProvider, child) {
                        final banks = paymentMethodProvider.paymentMethods
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
                    CustomTextField(
                      label: "Service TID",
                      controller: _serviceTIDController,
                      hintText: 'Bank Transaction ID',
                    ),
                  ],
                  
                  // Cheque No (only show when payment type is Cheque)
                  if (selectedPaymentMethod == 'Cheque') ...[
                    CustomTextField(
                      label: "Cheque No",
                      controller: _serviceTIDController,
                      hintText: 'Cheque No',
                    ),
                  ],
                  
                  CustomTextField(
                    label: "Note",
                    controller: _noteController,
                    hintText: 'xxxxx',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Buttons
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
                        onPressed: bankingProvider.isLoading ? (){} : () {
                          widget.isEditMode ? _updatePayment() : _submitForm();
                        },
                        text: bankingProvider.isLoading 
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

  // DateTime Picker Field
  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: _selectDateTime,
        child: InputDecorator(
          decoration: const InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: "Date and Time",
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: Icon(Icons.calendar_month, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

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
              child: const Text("Cancel",style: TextStyle(color: Colors.grey),),
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
              child: const Text("OK",style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    setState(() {
      selectedBank = null;
      selectedPaymentType = null;
      selectedPaymentMethod = null;
      selectedDateTime = DateTime.now();
      _amountController.clear();
      _paymentByController.clear();
      _receivedByController.clear();
      _serviceTIDController.clear();
      _noteController.clear();
      _issueDateController.clear();
    });
  }

  void _submitForm() async {
    // Validate required fields
    if (selectedPaymentMethod == null || selectedPaymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Validate bank selection if payment method is Bank
    if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a bank for bank payment')),
      );
      return;
    }

    if (_amountController.text.isEmpty || _paymentByController.text.isEmpty || _receivedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Submit the form
    final bankingProvider = context.read<BankingPaymentsProvider>();
    
    await bankingProvider.addBankingPayment(
      type: 'employee',
      typeRef: 'employee_transaction', // Default type reference for employee transactions
      clientRef: '', // No client reference for employee transactions
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
      createdAt: selectedDateTime.toIso8601String(),
    );

    // Check if submission was successful
    if (bankingProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bankingProvider.successMessage!)),
      );
      _clearForm();
      Navigator.of(context).pop();
    } else if (bankingProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bankingProvider.errorMessage!)),
      );
    }
  }

  void _updatePayment() async {
    // Validate required fields
    if (selectedPaymentMethod == null || selectedPaymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Validate bank selection if payment method is Bank
    if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a bank for bank payment')),
      );
      return;
    }

    if (_amountController.text.isEmpty || _paymentByController.text.isEmpty || _receivedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bankingProvider.successMessage!)),
      );
      Navigator.of(context).pop();
    } else if (bankingProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bankingProvider.errorMessage!)),
      );
    }
  }
}

void showEmployeeTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const DialogEmployeType(),
  );
}
