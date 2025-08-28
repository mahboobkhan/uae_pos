// lib/ui/screens/office_expense/dialogues/dialogue_edit_office_expense.dart
import 'package:abc_consultant/ui/dialogs/custom_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../expense/update_expense_provider.dart';
import '../../../../utils/request_state.dart';
import '../../../dialogs/custom_dialoges.dart';

class DialogueEditOfficeExpense extends StatefulWidget {
  final Map<String, dynamic> expenseData; // pass the whole expense row

  const DialogueEditOfficeExpense({super.key, required this.expenseData});

  @override
  State<DialogueEditOfficeExpense> createState() =>
      _DialogueEditOfficeExpenseState();
}

class _DialogueEditOfficeExpenseState extends State<DialogueEditOfficeExpense> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController expenseNameController;
  late TextEditingController expenseAmountController;
  late TextEditingController noteController;
  late TextEditingController allocatedAmount;

  @override
  void initState() {
    super.initState();
    expenseNameController = TextEditingController(
      text: widget.expenseData["expense_name"],
    );
    expenseAmountController = TextEditingController(
      text: widget.expenseData["expense_amount"].toString(),
    );
    noteController = TextEditingController(text: widget.expenseData["note"]);
    allocatedAmount = TextEditingController(
      text: widget.expenseData["allocated_amount"]?.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180, maxHeight: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Change the Dialog",
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
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      CustomTextField(
                        controller: expenseNameController,
                        label: 'Expense Name',
                        hintText: 'Expense Name',
                      ),
                      CustomTextField(
                        controller: expenseAmountController,
                        label: 'Expense Amount',
                        hintText: 'Expense Amount',
                        keyboardType: TextInputType.number,
                      ),
                      CustomTextField(
                        controller: noteController,
                        label: 'Note',
                        hintText: 'Note',
                      ),
                      CustomTextField(
                        controller: allocatedAmount,
                        label: 'Allocated Amount',
                        hintText: '',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Consumer<UpdateExpenseProvider>(
                    builder: (context, provider, _) {
                      if (provider.state == RequestState.loading) {
                        return const CircularProgressIndicator();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            onPressed: () => Navigator.pop(context), text: 'Cancel',
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            text: 'Save',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final body = {
                                  "tid": widget.expenseData["tid"],
                                  "expense_type":
                                      widget.expenseData["expense_type"],
                                  "expense_name": expenseNameController.text,
                                  "expense_amount":
                                      expenseAmountController.text.trim(),
                                  "allocated_amount": allocatedAmount.text.trim(),
                                  "note": noteController.text,
                                  "tag": widget.expenseData["tag"],
                                  "pay_by_manager":
                                      widget.expenseData["pay_by_manager"],
                                  "received_by_person":
                                      widget.expenseData["received_by_person"],
                                  "edit_by": "Admin",
                                  "payment_status":
                                      widget.expenseData["payment_status"],
                                };

                                await provider.updateExpense(body);

                                if (provider.state == RequestState.success) {
                                  Navigator.pop(context, true); // return success
                                }
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
