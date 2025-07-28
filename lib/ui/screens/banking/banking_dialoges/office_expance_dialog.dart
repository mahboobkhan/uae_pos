import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';

import '../../../dialogs/custom_fields.dart';

class OfficeExpanceDialog extends StatefulWidget {
  const OfficeExpanceDialog({super.key});

  @override
  State<OfficeExpanceDialog> createState() => _OfficeExpanceDialogState();
}

class _OfficeExpanceDialogState extends State<OfficeExpanceDialog> {
  String? selectedPlatform;
  List<String> platformList = ['Bank', 'Violet', 'Other'];

  String? selectedBank;
  String? selectedPaymentType;
  String? selectedPaymentType1;

  late TextEditingController _amountController;
  late TextEditingController _paymentByController;
  late TextEditingController _receivedByController;
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _paymentByController = TextEditingController();
    _receivedByController = TextEditingController();
    _serviceTIDController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paymentByController.dispose();
    _receivedByController.dispose();
    _serviceTIDController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 400),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Office Expanse",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "TID. 00001-292382",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _formattedDate(),
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.close, size: 25,color: Colors.red,),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomDropdownField(
                    label: "Select Bank",
                    selectedValue: selectedBank,
                    options: ["HBL", "UBL", "MCB"],
                    onChanged: (val) => setState(() => selectedBank = val),
                  ),
                  CustomDropdownField(
                    label: "Payment",
                    selectedValue: selectedPaymentType,
                    options: ["In", "Out"],
                    onChanged: (val) => setState(() => selectedPaymentType = val),
                  ),
                  CustomDropdownField(
                    label: "Expanse Type",
                    selectedValue: selectedPaymentType1,
                    options: ["Fixed Office Expanse", "Office Maintenance","Office Supplies","Miscellaneous","Other"],
                    onChanged: (val) => setState(() => selectedPaymentType1 = val),
                  ),
                  SizedBox(
                    width: 220,
                    child:
                    CustomDropdownWithAddButton(
                      label: "Select Platform",
                      value: selectedPlatform,
                      items: platformList,
                      onChanged: (newValue) {
                        // Update selectedPlatform state in parent
                      },
                      onAddPressed: () {
                        showInstituteManagementDialog(context);
                      },
                    ),

                  ),

                  SizedBox(
                    width: 220,
                    child: CustomDropdownWithAddButton(
                      label: "Select Platform",
                      value: selectedPlatform,
                      items: platformList,
                      onChanged: (newValue) {
                      },
                      onAddPressed: () {
                        showInstituteManagementDialog(context);
                      },
                    ),
                  ),
                  CustomTextField(label: "Amount", controller: _amountController,hintText: '500',),
                  CustomTextField(label: "Payment By",controller:  _paymentByController, hintText: 'John Doe' ),
                  CustomTextField(label: "Received By",controller:  _receivedByController,hintText: 'Smith'),
                  CustomTextField(label: "Service TID", controller: _serviceTIDController,hintText: 'xxxxxxx',),
                  CustomTextField(label: "Note",controller:  _noteController,hintText: "xxxxx",),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                    onPressed: () {},
                    text: "Editing",
                    backgroundColor: Colors.blue,

                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    onPressed: () {},
                    text: "Submit",
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  }


}

void showOfficeExpanceDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const OfficeExpanceDialog(),
  );
}

void _showEditDialog(
    BuildContext context,
    StateSetter setState,
    List<String> institutes,
    int index,
    TextEditingController editController,
    ) {
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blue),
                  ),
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
                  TextButton(
                    onPressed: () => Navigator.pop(editContext),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
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

void showInstituteManagementDialog(BuildContext context) {
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
              borderRadius: BorderRadius.circular(
                12,
              ), // Slightly smaller radius
            ),
            contentPadding: const EdgeInsets.all(12), // Reduced padding
            insetPadding: const EdgeInsets.all(20), // Space around dialog
            content: SizedBox(
              width: 300, // Fixed width
              height: 400, // Fixed height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Compact header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Institutes',
                        style: TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
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
                  SizedBox(
                    height: 40,
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: addController,
                      decoration: InputDecoration(
                        hintText: "Add institute...",
                        isDense: true,
                        // Makes the field more compact
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        // Border when focused
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.blue,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (addController.text.trim().isNotEmpty) {
                              setState(() {
                                institutes.add(addController.text.trim());
                                addController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Compact list
                  Expanded(
                    child:
                    institutes.isEmpty
                        ? const Center(
                      child: Text(
                        'No institutes',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: institutes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            dense: true,
                            // Makes tiles more compact
                            visualDensity: VisualDensity.compact,
                            // Even more compact
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            title: Text(
                              institutes[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: SizedBox(
                              width:
                              80, // Constrained width for buttons
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed:
                                        () => _showEditDialog(
                                      context,
                                      setState,
                                      institutes,
                                      index,
                                      editController,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
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


