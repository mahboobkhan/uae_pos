import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/create_bank_account.dart';
import '../utils/app_colors.dart';
import '../utils/request_state.dart';

class CreateBankAccountScreen extends StatefulWidget {
  @override
  _CreateBankAccountScreenState createState() => _CreateBankAccountScreenState();
}

class _CreateBankAccountScreenState extends State<CreateBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _bankNameController = TextEditingController();
  final _branchCodeController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _titleNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _ibanNumberController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _additionalNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateUserBankAccountProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Bank Account")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Bank Name", _bankNameController),
              _buildTextField("Branch Code", _branchCodeController),
              _buildTextField("Bank Address", _bankAddressController),
              _buildTextField("Title Name", _titleNameController),
              _buildTextField("Bank Account Number", _bankAccountNumberController),
              _buildTextField("IBAN Number", _ibanNumberController),
              _buildTextField("Contact Number", _contactNumberController),
              _buildTextField("Email ID", _emailIdController),
              _buildTextField("Additional Note", _additionalNoteController),

              const SizedBox(height: 20),

              provider.state == RequestState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final request = CreateUserBankAccountRequest(
                      userId: "user_6888ecba5a626", // Replace with actual userId
                      bankName: _bankNameController.text,
                      branchCode: _branchCodeController.text,
                      bankAddress: _bankAddressController.text,
                      titleName: _titleNameController.text,
                      bankAccountNumber: _bankAccountNumberController.text,
                      ibanNumber: _ibanNumberController.text,
                      contactNumber: _contactNumberController.text,
                      emailId: _emailIdController.text,
                      additionalNote: _additionalNoteController.text,
                      createdBy: "admin", // Replace with actual creator name
                    );

                    context
                        .read<CreateUserBankAccountProvider>()
                        .createBankAccount(request);
                  }
                },
                child: const Text("Submit"),
              ),

              const SizedBox(height: 20),

              if (provider.state == RequestState.error)
                Text(provider.errorMessage ?? "Something went wrong",
                    style: const TextStyle(color: AppColors.redColor)),

              if (provider.state == RequestState.success)
                const Text("Bank account created successfully!",
                    style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  // Simple text field builder
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? "$label is required" : null,
      ),
    );
  }
}
