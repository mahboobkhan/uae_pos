import 'package:flutter/material.dart';

import '../../../../employee/employee_models.dart';

class BankAccountEditDialog extends StatefulWidget {
  final BankAccount bankAccount;
  final Function(BankAccount) onSave;

  const BankAccountEditDialog({
    Key? key,
    required this.bankAccount,
    required this.onSave,
  }) : super(key: key);

  @override
  State<BankAccountEditDialog> createState() => _BankAccountEditDialogState();
}

class _BankAccountEditDialogState extends State<BankAccountEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleNameController;
  late TextEditingController _bankNameController;
  late TextEditingController _branchCodeController;
  late TextEditingController _bankAccountNumberController;
  late TextEditingController _ibanNumberController;
  late TextEditingController _contactNumberController;
  late TextEditingController _emailIdController;
  late TextEditingController _bankAddressController;
  late TextEditingController _additionalNoteController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    _titleNameController = TextEditingController(
      text: widget.bankAccount.titleName,
    );
    _bankNameController = TextEditingController(
      text: widget.bankAccount.bankName,
    );
    _branchCodeController = TextEditingController(
      text: widget.bankAccount.branchCode,
    );
    _bankAccountNumberController = TextEditingController(
      text: widget.bankAccount.bankAccountNumber,
    );
    _ibanNumberController = TextEditingController(
      text: widget.bankAccount.ibanNumber,
    );
    _contactNumberController = TextEditingController(
      text: widget.bankAccount.contactNumber,
    );
    _emailIdController = TextEditingController(
      text: widget.bankAccount.emailId,
    );
    _bankAddressController = TextEditingController(
      text: widget.bankAccount.bankAddress,
    );
    _additionalNoteController = TextEditingController(
      text: widget.bankAccount.additionalNote,
    );
  }

  @override
  void dispose() {
    _titleNameController.dispose();
    _bankNameController.dispose();
    _branchCodeController.dispose();
    _bankAccountNumberController.dispose();
    _ibanNumberController.dispose();
    _contactNumberController.dispose();
    _emailIdController.dispose();
    _bankAddressController.dispose();
    _additionalNoteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Create updated bank account
      final updatedBankAccount = BankAccount(
        id: widget.bankAccount.id,
        userId: widget.bankAccount.userId,
        titleName: _titleNameController.text.trim(),
        bankName: _bankNameController.text.trim(),
        branchCode: _branchCodeController.text.trim(),
        bankAccountNumber: _bankAccountNumberController.text.trim(),
        ibanNumber: _ibanNumberController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        emailId: _emailIdController.text.trim(),
        bankAddress: _bankAddressController.text.trim(),
        additionalNote: _additionalNoteController.text.trim(),
        createdBy: widget.bankAccount.createdBy,
        createdDate: widget.bankAccount.createdDate,
      );

      // Call the onSave callback
      widget.onSave(updatedBankAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue.shade700, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Edit Bank Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // First Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Title Name',
                              _titleNameController,
                              Icons.person,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Bank Name',
                              _bankNameController,
                              Icons.account_balance,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Second Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Branch Code',
                              _branchCodeController,
                              Icons.location_on,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Account Number',
                              _bankAccountNumberController,
                              Icons.credit_card,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Third Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'IBAN Number',
                              _ibanNumberController,
                              Icons.account_balance_wallet,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Contact Number',
                              _contactNumberController,
                              Icons.phone,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Fourth Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Email ID',
                              _emailIdController,
                              Icons.email,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Bank Address',
                              _bankAddressController,
                              Icons.location_city,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Additional Note
                      _buildTextField(
                        'Additional Note',
                        _additionalNoteController,
                        Icons.note,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      IconData icon, {
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
