// lib/ui/screens/office_expense/dialogues/dialogue_edit_office_expense.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../expense/update_expense_provider.dart';
import '../../../../utils/request_state.dart';

class DialogueEditOfficeExpense extends StatefulWidget {
  final Map<String, dynamic> expenseData; // pass the whole expense row

  const DialogueEditOfficeExpense({super.key, required this.expenseData});

  @override
  State<DialogueEditOfficeExpense> createState() => _DialogueEditOfficeExpenseState();
}

class _DialogueEditOfficeExpenseState extends State<DialogueEditOfficeExpense> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController expenseNameController;
  late TextEditingController expenseAmountController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    expenseNameController =
        TextEditingController(text: widget.expenseData["expense_name"]);
    expenseAmountController = TextEditingController(
        text: widget.expenseData["expense_amount"].toString());
    noteController = TextEditingController(text: widget.expenseData["note"]);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Expense",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextFormField(
                controller: expenseNameController,
                decoration: const InputDecoration(labelText: "Expense Name"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: expenseAmountController,
                decoration: const InputDecoration(labelText: "Expense Amount"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: "Note"),
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
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: const Text("Save"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final body = {
                              "tid": widget.expenseData["tid"],
                              "expense_type": widget.expenseData["expense_type"],
                              "expense_name": expenseNameController.text,
                              "expense_amount":
                              int.tryParse(expenseAmountController.text) ??
                                  0,
                              "allocated_amount":
                              widget.expenseData["allocated_amount"],
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
    );
  }
}
