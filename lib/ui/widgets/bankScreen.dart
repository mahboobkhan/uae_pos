import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/create_bank_provider.dart';
import '../../providers/designation_delete_provider.dart';

class BankCreateScreen extends StatefulWidget {
  final String userId; // Pass this from login/profile

  const BankCreateScreen({super.key, required this.userId});

  @override
  State<BankCreateScreen> createState() => _BankCreateScreenState();
}

class _BankCreateScreenState extends State<BankCreateScreen> {
  final TextEditingController _bankNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedBank();
  }

  Future<void> _loadSavedBank() async {
    final provider = context.read<BankCreateProvider>();
    final saved = await provider.getSavedBankName();
    if (saved != null && saved.isNotEmpty) {
      _bankNameController.text = saved;
    }
  }

  Future<void> _submitBank() async {
    final provider = context.read<BankCreateProvider>();

    if (_bankNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter bank name")),
      );
      return;
    }

    await provider.createBank(
      BankCreateRequest(
        bankName: _bankNameController.text.trim(),
        userId: widget.userId,
        createdBy: "Admin", // Replace with actual logged-in user
      ),
    );

    if (provider.state == RequestState.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bank created successfully")),
      );
      _bankNameController.clear();
    } else if (provider.state == RequestState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankCreateProvider>(
      builder: (context, bankProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Bank"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(
                    labelText: "Bank Name",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: bankProvider.setBankName,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: bankProvider.state == RequestState.loading
                      ? null
                      : _submitBank,
                  child: bankProvider.state == RequestState.loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text("Create Bank"),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Text(
                  "Created Banks (Local)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: bankProvider.getCreatedBanksList().length,
                    itemBuilder: (context, index) {
                      final bank = bankProvider.getCreatedBanksList()[index];
                      return ListTile(
                        leading: const Icon(Icons.account_balance),
                        title: Text(bank),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
