import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../dialogs/custom_dialoges.dart';
import '../../../dialogs/custom_fields.dart';

String? selectedPlatform;
List<String> platformList = ['Bank', 'Violet', 'Other'];

void showAddPaymentMethodDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AddPaymentMethodDialog();
    },
  );
}

class AddPaymentMethodDialog extends StatefulWidget {
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
                  const Text(
                    'Add Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('dd-MM-yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      final shouldClose = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.white,
                              title: const Text("Are you sure?"),
                              content: const Text(
                                "Do you want to close this form? Unsaved changes may be lost.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text(
                                    "Keep Changes ",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(color: Colors.red),
                                  ),
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
                  SizedBox(
                    width: 220,
                    // child: CustomDropdownWithRightAdd(
                    //   label: "Services ",
                    //   value: selectedService,
                    //   items: serviceOptions,
                    //   onChanged: (val) =>
                    //       setState(() => selectedService = val),
                    //   onAddPressed: () {
                    //     showInstituteManagementDialog2(context);
                    //   },
                    // ),
                  ),
                  CustomTextField(
                    label: "Bank Name",
                    controller: bankName,
                    hintText: "Ubl",
                  ),
                  CustomTextField(
                    label: "Email ID",
                    controller: emailController,
                    hintText: "user@email.com",
                  ),
                  CustomTextField(
                    label: "Title Name",
                    controller: titleName,
                    hintText: "user",
                  ),
                  CustomTextField(
                    label: "Account No",
                    controller: accountNo,
                    hintText: "xxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "IBN",
                    controller: ibnController,
                    hintText: "xxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Mobile Number",
                    controller: mobileNumber,
                    hintText: "+972********",
                  ),
                  CustomTextField(
                    label: "Tag Add",
                    controller: tagAdd, // ✅ Fixed
                    hintText: "NA",
                  ),
                  CustomTextField(
                    label: "Bank Physical Address",
                    controller: bankAddress,
                    hintText: "xxxxxxx",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                children: [
                  CustomButton(
                    text: "Editing",
                    backgroundColor: Colors.blue,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: "Submit",
                    backgroundColor: Colors.green,
                    onPressed: () {},
                  ),
                ],
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
                borderRadius: BorderRadius.circular(
                  12,
                ), // Slightly smaller radius
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
                          icon: const Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.red,
                          ),
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
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: addController,
                              cursorColor: Colors.blue,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: "Add institute...",
                                border:
                                    InputBorder.none, // remove double border
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              if (addController.text.trim().isNotEmpty) {
                                setState(() {
                                  institutes.add(addController.text.trim());
                                  addController.clear();
                                });
                              }
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      // Makes tiles more compact
                                      visualDensity: VisualDensity.compact,
                                      // Even more compact
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                                color: Colors.green,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
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
                        style: TextStyle(color: Colors.grey),
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
}
