import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/create_bank_account.dart';
import '../../providers/designation_delete_provider.dart';

class CreateBankAccountScreen extends StatefulWidget {
  const CreateBankAccountScreen({super.key});

  @override
  State<CreateBankAccountScreen> createState() => _CreateBankAccountScreenState();
}

class _CreateBankAccountScreenState extends State<CreateBankAccountScreen> {
  final _bankNameController = TextEditingController();
  final _branchCodeController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _titleNameController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _ibanController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastSavedAccount();
  }

  Future<void> _loadLastSavedAccount() async {
    final provider = context.read<CreateUserBankAccountProvider>();
    final lastAccount = await provider.getLastSavedAccount();
    if (lastAccount != null) {
      setState(() {
        _bankNameController.text = lastAccount['bank_name'] ?? '';
        _branchCodeController.text = lastAccount['branch_code'] ?? '';
        _bankAddressController.text = lastAccount['bank_address'] ?? '';
        _titleNameController.text = lastAccount['title_name'] ?? '';
        _bankAccountController.text = lastAccount['bank_account_number'] ?? '';
        _ibanController.text = lastAccount['iban_number'] ?? '';
        _contactController.text = lastAccount['contact_number'] ?? '';
        _emailController.text = lastAccount['email_id'] ?? '';
        _noteController.text = lastAccount['additional_note'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Bank Account"),
        backgroundColor: Colors.green,
      ),
      body: Consumer<CreateUserBankAccountProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildTextField("Bank Name", _bankNameController),
                _buildTextField("Branch Code", _branchCodeController),
                _buildTextField("Bank Address", _bankAddressController),
                _buildTextField("Title Name", _titleNameController),
                _buildTextField("Bank Account Number", _bankAccountController),
                _buildTextField("IBAN Number", _ibanController),
                _buildTextField("Contact Number", _contactController),
                _buildTextField("Email ID", _emailController),
                _buildTextField("Additional Note", _noteController),
                const SizedBox(height: 20),

                // Submit button
                ElevatedButton(
                  onPressed: provider.state == RequestState.loading
                      ? null
                      : () async {
                    await provider.createBankAccount(
                      CreateUserBankAccountRequest(
                        userId: "1", // Replace with dynamic userId
                        bankName: _bankNameController.text,
                        branchCode: _branchCodeController.text,
                        bankAddress: _bankAddressController.text,
                        titleName: _titleNameController.text,
                        bankAccountNumber: _bankAccountController.text,
                        ibanNumber: _ibanController.text,
                        contactNumber: _contactController.text,
                        emailId: _emailController.text,
                        additionalNote: _noteController.text,
                        createdBy: "Admin",
                      ),
                    );

                    if (provider.state == RequestState.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Bank account created successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (provider.state == RequestState.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorMessage ?? "Error"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: provider.state == RequestState.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
