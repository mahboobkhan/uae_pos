import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_dialoges.dart';
import 'custom_fields.dart';

void showCompanyProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: CompanyProfile(),
        ),
  );
}


class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<StatefulWidget> createState() => CompanyProfileState();
}

class CompanyProfileState extends State<CompanyProfile> {
  Future<void> _pickDateTime2() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final formatted = DateFormat('dd-MM-yyyy – hh:mm a').format(combined);
        _expiryDateController.text = formatted;
        _issueDateController.text = formatted;
      }
    }
  }

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController tradeLicenseController = TextEditingController();
  final TextEditingController companyCodeController = TextEditingController();
  final TextEditingController establishmentNumberController =
      TextEditingController();
  final TextEditingController extraNoteController = TextEditingController();
  final TextEditingController emailId2Controller = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController contactNumber2Controller =
      TextEditingController();
  final TextEditingController physicalAddressController =
      TextEditingController();
  final TextEditingController channelNameController = TextEditingController();
  final TextEditingController channelLoginController = TextEditingController();
  final TextEditingController channelPasswordController =
      TextEditingController();
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emiratesIdController = TextEditingController();
  final TextEditingController workPermitNumberController =
      TextEditingController();
  final TextEditingController emailId1Controller = TextEditingController();
  final TextEditingController contactNumber3Controller =
      TextEditingController();
  final TextEditingController docName2 = TextEditingController();
  final TextEditingController advancePayment = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();


  String? selectedPlatform;
  List<String> platformList = ['Bank', 'Violet', 'Other'];
  String? selectedJobType3;
  String? selectedJobType4;
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 950,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Company Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 160,
                        child: SmallDropdownField(
                          label: "Employee type",
                          options: ['Cleaning', 'Consultining', 'Reparing'],
                          selectedValue: selectedJobType3,
                          onChanged: (value) {
                            setState(() {
                              selectedJobType3 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: Colors.white,
                                  title: const Text("Are you sure?"),
                                  content: const Text(
                                    "Do you want to close this form? Unsaved changes may be lost.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
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
                            Navigator.of(context).pop(); // close the dialog
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'ORN.0001-0000002', // Static example ID
                style: TextStyle(fontSize: 12,),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(
                    label: "Company Name",
                    hintText: "xyz",
                    controller: companyNameController,
                  ),
                  CustomTextField(
                    label: "Trade Licence Number ",
                    controller: tradeLicenseController,
                    hintText: "1234",
                  ),
                  CustomTextField(
                    label: "Company Code ",
                    controller: companyCodeController,
                    hintText: "456",
                  ),
                  CustomTextField(
                    label: "Establishment Number ",
                    controller: establishmentNumberController,
                    hintText: "xxxxxxxxx",
                  ),
                ],
              ),
              SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(
                    label: "Note Extra ",
                    controller: extraNoteController,
                    hintText: "xxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Email I'd ",
                    controller: emailId2Controller,
                    hintText: "@gmail.com",
                  ),
                  CustomTextField(
                    label: "Contact Number ",
                    controller: contactNumberController,
                    hintText: "+973xxxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Contact Number 2",
                    controller: contactNumber2Controller,
                    hintText: "+973xxxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Physical Address",
                    controller: physicalAddressController,
                    hintText: "Address,house,street,town,post code",
                  ),
                  CustomTextField(
                    label: "E- Channel Name",
                    controller: channelNameController,
                    hintText: "S.E.C.P",
                  ),
                  CustomTextField(
                    label: "E- Channel Login I'd",
                    controller: channelLoginController,
                    hintText: "S.E.C.P",
                  ),
                  CustomTextField(
                    label: "E- Channel Login Password",
                    controller: channelPasswordController,
                    hintText: "xxxxxxx",
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          CustomCompactTextField(
                            label: 'Doc Name',
                            hintText: '',
                            controller: documentNameController,
                          ),
                          CustomDateNotificationField(
                            label: "Issue Date Notifications",
                            controller: _issueDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime2,
                          ),
                          CustomDateNotificationField(
                            label: "Expiry Date Notifications",
                            controller: _expiryDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime2,
                          ),
                          ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(150, 38),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Optional: slight rounding
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.upload_file,
                                  size: 16,
                                  color: Colors.white,
                                ), //
                                SizedBox(width: 6),
                                Text(
                                  'Upload File',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ), //
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )

                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Text(
                    "Partner / Employee Records",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomDropdownField(
                    label: "Employee",
                    options: ['Partner', 'Employee', 'Other Records'],
                    selectedValue: selectedJobType4,
                    onChanged: (value) {
                      setState(() {
                        selectedJobType4 = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 220,
                    child: CustomDropdownWithAddButton(
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
                  CustomTextField(
                    label: " Name",
                    controller: nameController,
                    hintText: "Imran Khan",
                  ),
                  CustomTextField(
                    label: "Emirates IDs",
                    controller: emiratesIdController,
                    hintText: "S.E.C.P",
                  ),
                  CustomTextField(
                    label: "Work Permit No",
                    controller: workPermitNumberController,
                    hintText: "xxxxxxx",
                  ),
                  CustomTextField(
                    label: "Email I'd",
                    controller: emailId1Controller,
                    hintText: "xxxxxxx",
                  ),
                  CustomTextField(
                    label: "Contact No",
                    controller: contactNumber3Controller,
                    hintText: "xxxxxxx",
                  ),
                  CustomTextField(
                    label: "Advance Payment TID",
                    controller: advancePayment,
                    hintText: "*****",
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      InfoBox(
                        value: "Pending Payment",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                      InfoBox(
                        value: "Advance Payment",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          CustomCompactTextField(
                            label: 'Doc Name',
                            hintText: '',
                            controller: docName2,
                          ),
                          CustomDateNotificationField(
                            label: "Issue Date Notifications",
                            controller: _issueDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime,
                          ),
                          CustomDateNotificationField(
                            label: "Expiry Date Notifications",
                            controller: _expiryDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime,
                          ),
                          ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(150, 38),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Optional: slight rounding
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.upload_file,
                                  size: 16,
                                  color: Colors.white,
                                ), //
                                SizedBox(width: 6),
                                Text(
                                  'Upload File',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ), //
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /*     Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Add 2 more",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Add More Employee",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),*/
              SizedBox(height: 20),

                  Row(
                children: [
                  CustomButton(
                    text: "Editing",
                    backgroundColor: Colors.red,
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
            ])],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _dateTimeController.text = DateFormat(
          'dd-MM-yyyy – hh:mm a',
        ).format(combined);
      }
    }
  }
}

/*
class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Color borderColor;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    this.label,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width /
          4.5, // Same width as CustomTextField
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          isDense: true,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.red),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
          ),
          hint: hintText != null ? Text(hintText!) : null,
          icon: const Icon(Icons.arrow_drop_down),
          items:
              items.map((item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
*/

Widget _buildDropdownWithPlus1({
  required BuildContext context,
  required String label,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
  required VoidCallback onAddPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 4.5,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.red),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            isDense: true,
            style: const TextStyle(fontSize: 13),
            items:
                items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
          Positioned(
            right: 6,
            top: 6,
            bottom: 6,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
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

class CustomCompactInfoBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const CustomCompactInfoBox({
    Key? key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.borderColor = Colors.grey,
    this.titleStyle,
    this.subtitleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6.5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    titleStyle ??
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style:
                    subtitleStyle ??
                    const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
