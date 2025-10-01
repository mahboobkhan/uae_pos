import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/delete_bank_account.dart';
import '../../providers/designation_delete_provider.dart';

class DeleteUserBankAccountScreen extends StatefulWidget {
  const DeleteUserBankAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteUserBankAccountScreen> createState() => _DeleteUserBankAccountScreenState();
}

class _DeleteUserBankAccountScreenState extends State<DeleteUserBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _ibanController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _titleNameController = TextEditingController();

  Map<String, dynamic>? _lastDeleted;

  @override
  void initState() {
    super.initState();
    _loadLastDeleted();
  }

  Future<void> _loadLastDeleted() async {
    final lastDeleted = await Provider.of<DeleteUserBankAccountProvider>(context, listen: false)
        .getLastDeletedAccount();
    setState(() {
      _lastDeleted = lastDeleted;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final request = DeleteUserBankAccountRequest(
        ibanNumber: _ibanController.text.trim(),
        bankAccountNumber: _accountNumberController.text.trim(),
        bankName: _bankNameController.text.trim(),
        titleName: _titleNameController.text.trim(),
      );

      final provider = Provider.of<DeleteUserBankAccountProvider>(context, listen: false);
      await provider.deleteBankAccount(request);

      if (provider.state == RequestState.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Bank account deleted successfully!")),
        );
        _loadLastDeleted(); // Refresh last deleted
      } else if (provider.state == RequestState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${provider.errorMessage}")),
        );
      }
    }
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _titleNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Bank Account")),
      body: Consumer<DeleteUserBankAccountProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (_lastDeleted != null) ...[
                    Text(
                      "📌 Last deleted account:",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_lastDeleted.toString()),
                    const SizedBox(height: 20),
                  ],
                  TextFormField(
                    controller: _ibanController,
                    decoration: const InputDecoration(labelText: "IBAN Number"),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _accountNumberController,
                    decoration: const InputDecoration(labelText: "Bank Account Number"),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _bankNameController,
                    decoration: const InputDecoration(labelText: "Bank Name"),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _titleNameController,
                    decoration: const InputDecoration(labelText: "Title Name"),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: provider.state == RequestState.loading ? null : _submit,
                    child: provider.state == RequestState.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Delete Account"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
