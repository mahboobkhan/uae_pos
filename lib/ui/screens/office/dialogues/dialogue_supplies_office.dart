import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../expense/expense_create_provider.dart';
import '../../../../utils/request_state.dart';
import '../../../dialogs/calender.dart';
import '../../../dialogs/custom_fields.dart';

class DialogueOfficeSupplies extends StatefulWidget {
  const DialogueOfficeSupplies({super.key});

  @override
  State<DialogueOfficeSupplies> createState() => _DialogueOfficeSuppliesState();
}

class _DialogueOfficeSuppliesState extends State<DialogueOfficeSupplies> {
  DateTime selectedDateTime = DateTime.now();
  String? selectedExpense;

  late TextEditingController _pasteTIDController;
  late TextEditingController _expanseValueController;
  late TextEditingController _customNoteController;
  late TextEditingController _allocateBalanceController;
  late TextEditingController _expanseNameController;
  late TextEditingController _payByController;
  late TextEditingController _receivedByController;
  final TextEditingController _issueDateController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _pasteTIDController = TextEditingController();
    _expanseValueController = TextEditingController();
    _customNoteController = TextEditingController();
    _allocateBalanceController = TextEditingController();
    _payByController = TextEditingController();
    _receivedByController = TextEditingController();
    _expanseNameController = TextEditingController();
  }

  @override
  void dispose() {
    _pasteTIDController.dispose();
    _expanseValueController.dispose();
    _customNoteController.dispose();
    _allocateBalanceController.dispose();
    _payByController.dispose();
    _receivedByController.dispose();
    _expanseNameController.dispose();
    super.dispose();
  }

  void _selectedDateTime() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          backgroundColor: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180, maxHeight: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  const Text(
                    "Office Supplies",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      final shouldClose = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.white,
                          title: const Text("Are you sure?"),
                          content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Keep Changes ",style: TextStyle(color:Colors.blue ),),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Close",style: TextStyle(color:Colors.red ),),
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
              const SizedBox(height: 20),

              // Input Fields
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                    CustomTextField(
                      label: "Expense Name",
                      hintText: '',
                      controller: _expanseNameController,
                    ),
                    CustomTextField(
                      label: "Pay By",
                      controller: _payByController,
                      hintText: '500',
                    ),
                    CustomTextField(
                      label: "Received By",
                      controller: _receivedByController,
                      hintText: '500',
                    ),
                    CustomTextField(
                      label: "Expanse Value",
                      controller: _expanseValueController,
                      hintText: '500-AED',
                    ),
                    CustomTextField(
                      label: "Allocate Balance",
                      controller: _allocateBalanceController,
                      hintText: '500',
                    ),
                    _buildTextField("Note", _customNoteController, width: 450),
                  ],
              ),

              const SizedBox(height: 20),

              // Show loading and error states
              if (provider.state == RequestState.loading)
                const LinearProgressIndicator(),

              if (provider.state == RequestState.error)
                Text(
                  provider.errorMessage ?? "Something went wrong",
                  style: const TextStyle(color: Colors.red),
                ),

              if (provider.state == RequestState.success)
                Text(
                  provider.response?.message ?? "Expense Created!",
                  style: const TextStyle(color: Colors.green),
                ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  CustomButton(
                    text: "Stop",
                    backgroundColor: Colors.red,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: "Editing",
                    backgroundColor: Colors.blue,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: provider.state == RequestState.loading
                        ? "Submitting..."
                        : "Submit",
                    backgroundColor: Colors.green,
                    onPressed: provider.state == RequestState.loading
                        ? () {} // Empty function when loading
                        : () {
                      final expense = ExpenseRequest(
                        expenseType: "Office Supplies Expense",
                        expenseName: _expanseNameController.text.trim(),
                        expenseAmount: double.tryParse(
                            _expanseValueController.text.trim()) ?? 0,
                        allocatedAmount: double.tryParse(
                            _allocateBalanceController.text.trim()) ?? 0,
                        note: _customNoteController.text.trim(),
                        tag: "office",
                        payByManager: _payByController.text.trim(),
                        receivedByPerson: _receivedByController.text.trim(),
                        editBy: "Admin",
                        paymentStatus: "pending",
                        expenseDate: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDateTime),
                      );

                      provider.createExpense(expense).then((_) {
                        if (provider.state == RequestState.success) {
                          Navigator.pop(context); // auto-close
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(provider.response?.message ??
                                  "Expense Created!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      });
                    },
                  ),
                  const Spacer(),
                  Material(
                    elevation: 8,
                    color: Colors.blue, // Set background color here
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(
                        Icons.print,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Printed"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.black87,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
      }
    );
  }
  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: _selectedDateTime,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: "Date and Time ",
            labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border: OutlineInputBorder(),
            suffixIcon: Icon(
              Icons.calendar_month_outlined,
              color: Colors.red,
              size: 22,
            ),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }}

Widget _buildTextField(
    String label,
    TextEditingController controller, {
      double width = 220,
    }) {
  return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        labelText: label,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    ),
  );
}






void showOfficeSuppliesDialogue(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Center(
          child: const DialogueOfficeSupplies(),
        ), // No extra Dialog wrapper
  );
}
