import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../dialogs/calender.dart';
import '../../../dialogs/custom_fields.dart';

class DialogEmployeType extends StatefulWidget {
  const DialogEmployeType({super.key});

  @override
  State<DialogEmployeType> createState() => _DialogEmployeTypeState();
}

class _DialogEmployeTypeState extends State<DialogEmployeType> {
  DateTime selectedDateTime = DateTime.now();
  String? selectedBank;
  String? selectedPaymentType;

  late TextEditingController _amountController;
  late TextEditingController _paymentByController;
  late TextEditingController _receivedByController;
  final TextEditingController _issueDateController = TextEditingController();
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _paymentByController = TextEditingController(text: "Auto Fill: John Doe");
    _receivedByController = TextEditingController(
      text: "Auto Fill: Jane Smith",
    );
    _serviceTIDController = TextEditingController();
    _noteController = TextEditingController();
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
                    children: const [
                      Text(
                        "Employee Transactions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text("TID. 00001-292382", style: TextStyle(fontSize: 12)),
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
                  CustomDropdownField(
                    label: "Select Bank",
                    selectedValue: selectedBank,
                    options: ["Cash","Cheque","HBL", "UBL", "MCB"],
                    onChanged: (val) => setState(() => selectedBank = val),
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
                  CustomTextField(
                    label: "Service TID",
                    controller: _serviceTIDController,
                    hintText: 'xxxxxx',
                  ),
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
                    onPressed: () {},
                    text: "Editing",
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    onPressed: () {},
                    text: "Submit",
                    backgroundColor: Colors.green,
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
}

void showEmployeeTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const DialogEmployeType(),
  );
}
