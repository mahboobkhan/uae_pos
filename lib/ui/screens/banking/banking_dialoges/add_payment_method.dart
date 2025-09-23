import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../providers/banking_payment_method_provider.dart';
import '../../../dialogs/custom_dialoges.dart';
import '../../../dialogs/custom_fields.dart';

String? selectedPlatform;
List<String> platformList = ['Bank', 'Violet', 'Other'];

void showAddPaymentMethodDialog(BuildContext context, {Map<String, dynamic>? paymentMethodData}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AddPaymentMethodDialog(paymentMethodData: paymentMethodData);
    },
  );
}

class AddPaymentMethodDialog extends StatefulWidget {
  final Map<String, dynamic>? paymentMethodData;

  const AddPaymentMethodDialog({Key? key, this.paymentMethodData}) : super(key: key);

  @override
  State<AddPaymentMethodDialog> createState() => _AddPaymentMethodDialogState();
}

class _AddPaymentMethodDialogState extends State<AddPaymentMethodDialog> {
  final TextEditingController bankName = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController titleName = TextEditingController();
  final TextEditingController accountNo = TextEditingController();
  final TextEditingController ibnController = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController tagAdd = TextEditingController();
  final TextEditingController bankAddress = TextEditingController();

  final List<String> serviceOptions = ['Cleaning', 'Consulting', 'Repairing'];
  String? selectedService;

  bool get isEditing => widget.paymentMethodData != null;

  @override
  void initState() {
    super.initState();
    // If editing, populate fields with existing data
    if (isEditing && widget.paymentMethodData != null) {
      final data = widget.paymentMethodData!;
      bankName.text = data['bank_name'] ?? '';
      emailController.text = data['registered_email'] ?? '';
      titleName.text = data['account_title'] ?? '';
      accountNo.text = data['account_num'] ?? '';
      ibnController.text = data['iban'] ?? '';
      mobileNumber.text = data['registered_phone'] ?? '';
      bankAddress.text = data['bank_address'] ?? '';

      // Handle tags
      if (data['tags'] is List) {
        final tags = data['tags'] as List;
        tagAdd.text = tags.join(', ');
      }
    }
  }

  @override
  void dispose() {
    bankName.dispose();
    emailController.dispose();
    titleName.dispose();
    accountNo.dispose();
    ibnController.dispose();
    mobileNumber.dispose();
    tagAdd.dispose();
    bankAddress.dispose();
    super.dispose();
  }

  // Submit form
  Future<void> _submitForm() async {
    if (bankName.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        titleName.text.trim().isEmpty ||
        accountNo.text.trim().isEmpty ||
        ibnController.text.trim().isEmpty ||
        mobileNumber.text.trim().isEmpty ||
        bankAddress.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Colors.red));
      return;
    }

    final provider = context.read<BankingPaymentMethodProvider>();

    // Parse tags
    List<String> tags = [];
    if (tagAdd.text.trim().isNotEmpty) {
      tags = tagAdd.text.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
    }

    if (isEditing) {
      // Update existing payment method
      await provider.updatePaymentMethod(
        paymentMethodRefId: widget.paymentMethodData!['payment_method_ref_id'],
        bankName: bankName.text.trim(),
        accountTitle: titleName.text.trim(),
        accountNum: accountNo.text.trim(),
        iban: ibnController.text.trim(),
        registeredPhone: mobileNumber.text.trim(),
        registeredEmail: emailController.text.trim(),
        bankAddress: bankAddress.text.trim(),
        tags: tags.isNotEmpty ? tags : null,
      );
    } else {
      // Add new payment method
      await provider.addPaymentMethod(
        userId: "USR-123",
        // TODO: Get actual user ID from auth
        bankName: bankName.text.trim(),
        accountTitle: titleName.text.trim(),
        accountNum: accountNo.text.trim(),
        iban: ibnController.text.trim(),
        registeredPhone: mobileNumber.text.trim(),
        registeredEmail: emailController.text.trim(),
        bankAddress: bankAddress.text.trim(),
        tags: tags.isNotEmpty ? tags : null,
      );
    }

    // Close dialog if successful
    if (provider.successMessage != null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    isEditing ? 'Edit Payment Method' : 'Add Payment Method',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('dd-MM-yyyy').format(DateTime.now()),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      final shouldClose = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.white,
                              title: const Text("Are you sure?"),
                              content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Keep Changes ", style: TextStyle(color: Colors.blue)),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("Close", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                      );
                      if (shouldClose == true) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
              Text('ORN.0001-0001', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(label: "Bank Name", controller: bankName, hintText: "Ubl"),
                  CustomTextField(label: "Email ID", controller: emailController, hintText: "user@email.com"),
                  CustomTextField(label: "Title Name", controller: titleName, hintText: "user"),
                  CustomTextField(label: "Account No", controller: accountNo, hintText: "xxxxxxxxx"),
                  CustomTextField(label: "IBN", controller: ibnController, hintText: "xxxxxxxxx"),
                  CustomTextField(label: "Mobile Number", controller: mobileNumber, hintText: "+972********"),
                  CustomTextField(label: "Tag Add", controller: tagAdd, hintText: "NA",),
                  CustomTextField(label: "Bank Physical Address", controller: bankAddress, hintText: "xxxxxxx"),
                ],
              ),
              const SizedBox(height: 20),

              // Error/Success Messages
              Consumer<BankingPaymentMethodProvider>(
                builder: (context, provider, child) {
                  if (provider.errorMessage != null) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(child: Text(provider.errorMessage!, style: TextStyle(color: Colors.red))),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              provider.clearMessages();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.successMessage != null) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(child: Text(provider.successMessage!, style: TextStyle(color: Colors.green))),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.green),
                            onPressed: () {
                              provider.clearMessages();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),

              // Action Buttons
              Consumer<BankingPaymentMethodProvider>(
                builder: (context, provider, child) {
                  return Row(
                    children: [
                      if (isEditing)
                        CustomButton(
                          text: "Cancel",
                          backgroundColor: Colors.grey,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      if (isEditing) const SizedBox(width: 10),
                      CustomButton(
                        text: provider.isLoading ? (isEditing ? "Updating..." : "Adding...") : (isEditing ? "Update" : "Submit"),
                        backgroundColor: isEditing ? Colors.blue : Colors.green,
                        onPressed: provider.isLoading ? () {} : _submitForm,
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

  void showInstituteManagementDialog2(BuildContext context) {
    final List<String> institutes = [];
    final TextEditingController addController = TextEditingController();
    final TextEditingController editController = TextEditingController();
    int? editingIndex;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Slightly smaller radius
              ),
              contentPadding: const EdgeInsets.all(12), // Reduced padding
              insetPadding: const EdgeInsets.all(20), // Space around dialog
              content: SizedBox(
                width: 363,
                height: 305,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Compact header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Services',
                          style: TextStyle(
                            fontSize: 16, // Smaller font
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 25, color: Colors.red),
                          // Smaller icon
                          padding: EdgeInsets.zero,
                          // Remove default padding
                          constraints: const BoxConstraints(),
                          // Remove minimum size
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Compact input field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // align top
                      children: [
                        // TextField
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: addController,
                              cursorColor: Colors.blue,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: "Add institute...",
                                border: InputBorder.none, // remove double border
                                isDense: true,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Add Button
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () {
                              if (addController.text.trim().isNotEmpty) {
                                setState(() {
                                  institutes.add(addController.text.trim());
                                  addController.clear();
                                });
                              }
                            },
                            child: const Text("Add", style: TextStyle(fontSize: 14, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Compact list
                    Expanded(
                      child:
                          institutes.isEmpty
                              ? const Center(child: Text('No institutes', style: TextStyle(fontSize: 14)))
                              : ListView.builder(
                                shrinkWrap: true,
                                itemCount: institutes.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                                    child: ListTile(
                                      dense: true,
                                      // Makes tiles more compact
                                      visualDensity: VisualDensity.compact,
                                      // Even more compact
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                      title: Text(institutes[index], style: const TextStyle(fontSize: 14)),
                                      trailing: SizedBox(
                                        width: 80, // Constrained width for buttons
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, size: 18, color: Colors.green),
                                              padding: EdgeInsets.zero,
                                              onPressed: () => _showEditDialog(context, setState, institutes, index, editController),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                setState(() {
                                                  institutes.removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
      },
    );
  }

  void _showEditDialog(BuildContext context, StateSetter setState, List<String> institutes, int index, TextEditingController editController) {
    editController.text = institutes[index];
    showDialog(
      context: context,
      builder: (editContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: 250, // Smaller width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: Colors.blue,
                  controller: editController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Colors.grey)),
                    labelText: 'Edit institute',
                    labelStyle: TextStyle(color: Colors.blue),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(editContext), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                    const SizedBox(width: 8),
                    CustomButton(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        if (editController.text.trim().isNotEmpty) {
                          setState(() {
                            institutes[index] = editController.text.trim();
                          });
                          Navigator.pop(editContext);
                        }
                      },
                      text: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
