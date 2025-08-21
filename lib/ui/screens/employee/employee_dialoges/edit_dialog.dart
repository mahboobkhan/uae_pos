import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:abc_consultant/ui/dialogs/custom_fields.dart';
import 'package:flutter/material.dart';

import '../../../../employee/AllEmployeeData.dart';
import '../../../../employee/employee_models.dart';

class BankAccountEditDialog extends StatefulWidget {
  final BankAccount bankAccount;
  final Function(BankAccount) onSave;
  final AllEmployeeData? data;


  const BankAccountEditDialog({
    Key? key,
    required this.bankAccount,
    required this.onSave,
    required this.data,

  }) : super(key: key);

  @override
  State<BankAccountEditDialog> createState() => _BankAccountEditDialogState();
}

class _BankAccountEditDialogState extends State<BankAccountEditDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBank;


  late TextEditingController _titleNameController;
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
    // Set the selected bank if not already set
    if (_selectedBank == null && widget.bankAccount.bankName.isNotEmpty) {
      _selectedBank = widget.bankAccount.bankName.trim();
    }
    // Initialize controllers with current values
    _titleNameController = TextEditingController(
      text: widget.bankAccount.titleName,
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
        bankName: _selectedBank ?? '', // Use the selected bank from dropdown
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
      widget.onSave(updatedBankAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bankList =
    widget.data!.allBanks.map((d) => d.bankName.trim()).toList();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias, // 👈 yeh line add karo
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.white, size: 26),
                  const SizedBox(width: 12),
                  Text(
                    'Edit Bank Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // First Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Title Name',
                                hintText: '',
                                controller: _titleNameController,

                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child:   CustomDropdownField(
                                label: "Select Bank",
                                options: bankList,
                                selectedValue: _selectedBank,
                                onChanged: (value) {
                                    setState(() {
                                      _selectedBank = value;
                                    });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Account Number',
                                controller: _bankAccountNumberController,
                                hintText: '',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                label: 'Email ID',
                                controller: _emailIdController,
                                hintText: '',
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 10),
                        // Third Row
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'IBAN Number',
                                hintText: '',
                                controller: _ibanNumberController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                label: 'Contact Number',
                                controller: _contactNumberController,
                                hintText: '',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Additional Note',
                                controller: _additionalNoteController,
                                hintText: '',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(width: 10),
                            CustomButton(
                              text: 'Save Changes',
                              onPressed: _saveChanges,
                              backgroundColor: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
