import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../employee/employee_models.dart';
import '../../../../providers/designation_delete_provider.dart';
import '../../../../providers/update_ban_account_provider.dart';

class BankAccountEditDialog extends StatefulWidget {
  final BankAccount bankAccount;
  final Employee employee;
  final Function(BankAccount) onSave;

  const BankAccountEditDialog({
    Key? key,
    required this.bankAccount,
    required this.employee,
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

  void _saveChanges() async {
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
        // Keep existing created by
        createdDate: widget.bankAccount.createdDate,
      );

      // Call the onSave callback
      await widget.onSave(updatedBankAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return Icon(
                        isLoading ? Icons.hourglass_empty : Icons.edit,
                        color:
                            isLoading
                                ? Colors.orange.shade700
                                : Colors.red.shade700,
                        size: 24,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<UpdateUserBankAccountProvider>(
                          builder: (context, provider, child) {
                            final isLoading =
                                provider.state == RequestState.loading;
                            return Text(
                              isLoading
                                  ? 'Updating Bank Account...'
                                  : 'Edit Bank Account',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    isLoading
                                        ? Colors.orange.shade700
                                        : Colors.red.shade700,
                              ),
                            );
                          },
                        ),
                        Text(
                          'Employee: ${widget.employee.employeeName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return IconButton(
                        onPressed:
                            isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: isLoading ? Colors.grey : null,
                        ),
                      );
                    },
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
                      // First row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _titleNameController,
                              label: 'Account Title',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Account title is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _bankNameController,
                              label: 'Bank Name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Bank name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Second row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _branchCodeController,
                              label: 'Branch Code',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _bankAccountNumberController,
                              label: 'Account Number',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Third row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _ibanNumberController,
                              label: 'IBAN Number',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _contactNumberController,
                              label: 'Contact Number',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Fourth row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _emailIdController,
                              label: 'Email ID',
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(), // Empty container for spacing
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Fifth row
                      _buildTextField(
                        controller: _bankAddressController,
                        label: 'Bank Address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      // Sixth row
                      _buildTextField(
                        controller: _additionalNoteController,
                        label: 'Additional Note',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Fourth row
                      _buildTextField(
                        controller: _bankAddressController,
                        label: 'Bank Address',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer with buttons
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
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return TextButton(
                        onPressed:
                            isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                        child: Text(
                          isLoading ? 'Please wait...' : 'Cancel',
                          style: TextStyle(
                            color: isLoading ? Colors.grey : null,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Consumer<UpdateUserBankAccountProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.state == RequestState.loading;

                      return ElevatedButton(
                        onPressed: isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                        ),
                        child:
                            isLoading
                                ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Updating...'),
                                  ],
                                )
                                : const Text('Save Changes'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Consumer<UpdateUserBankAccountProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.state == RequestState.loading;

        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          enabled: !isLoading,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            filled: isLoading,
            fillColor: isLoading ? Colors.grey.shade100 : null,
          ),
        );
      },
    );
  }
}
