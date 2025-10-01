import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/update_ban_account_provider.dart';
import '../utils/request_state.dart';

class UpdateUserBankAccountScreen extends StatefulWidget {
  const UpdateUserBankAccountScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserBankAccountScreen> createState() =>
      _UpdateUserBankAccountScreenState();
}

class _UpdateUserBankAccountScreenState
    extends State<UpdateUserBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final bankNameCtrl = TextEditingController();
  final branchCodeCtrl = TextEditingController();
  final bankAddressCtrl = TextEditingController();
  final titleNameCtrl = TextEditingController();
  final bankAccountNumberCtrl = TextEditingController();
  final ibanNumberCtrl = TextEditingController();
  final contactNumberCtrl = TextEditingController();
  final emailIdCtrl = TextEditingController();
  final additionalNoteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastSavedData();
  }

  /// Load last saved account from SharedPreferences
  Future<void> _loadLastSavedData() async {
    final provider =
    Provider.of<UpdateUserBankAccountProvider>(context, listen: false);
    final savedData = await provider.getLastUpdatedAccount();

    if (savedData != null) {
      bankNameCtrl.text = savedData["bank_name"] ?? "";
      branchCodeCtrl.text = savedData["branch_code"] ?? "";
      bankAddressCtrl.text = savedData["bank_address"] ?? "";
      titleNameCtrl.text = savedData["title_name"] ?? "";
      bankAccountNumberCtrl.text = savedData["bank_account_number"] ?? "";
      ibanNumberCtrl.text = savedData["iban_number"] ?? "";
      contactNumberCtrl.text = savedData["contact_number"] ?? "";
      emailIdCtrl.text = savedData["email_id"] ?? "";
      additionalNoteCtrl.text = savedData["additional_note"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Bank Account"),
      ),
      body: Consumer<UpdateUserBankAccountProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(bankNameCtrl, "Bank Name"),
                  _buildTextField(branchCodeCtrl, "Branch Code"),
                  _buildTextField(bankAddressCtrl, "Bank Address"),
                  _buildTextField(titleNameCtrl, "Title Name"),
                  _buildTextField(bankAccountNumberCtrl, "Bank Account Number"),
                  _buildTextField(ibanNumberCtrl, "IBAN Number"),
                  _buildTextField(contactNumberCtrl, "Contact Number"),
                  _buildTextField(emailIdCtrl, "Email ID"),
                  _buildTextField(additionalNoteCtrl, "Additional Note",
                      maxLines: 3),
                  const SizedBox(height: 20),
                  provider.state == RequestState.loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        provider.updateBankAccount(
                          UpdateUserBankAccountRequest(
                            userId: "user_6896ea35be8dd", // Get from prefs/login
                            bankName: bankNameCtrl.text,
                            branchCode: branchCodeCtrl.text,
                            bankAddress: bankAddressCtrl.text,
                            titleName: titleNameCtrl.text,
                            bankAccountNumber:
                            bankAccountNumberCtrl.text,
                            ibanNumber: ibanNumberCtrl.text,
                            contactNumber: contactNumberCtrl.text,
                            emailId: emailIdCtrl.text,
                            additionalNote: additionalNoteCtrl.text,
                          ),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                  if (provider.state == RequestState.error)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        provider.errorMessage ?? "An error occurred",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (provider.state == RequestState.success)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Bank account updated successfully!",
                        style: TextStyle(color: Colors.green),
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

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
        (value == null || value.isEmpty) ? "Enter $label" : null,
      ),
    );
  }
}
