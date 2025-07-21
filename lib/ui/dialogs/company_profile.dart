import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_dialoges.dart';

void showCompanyProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
  String? selectedPlatform;
  List<String> platformList = ['Bank', 'Violet', 'Other'];
  String? selectedJobType3;
  String? selectedJobType4;
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text(
                        "Company Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomDropdownField(
                        hintText: "Select job type",
                        items: ['Regular', 'Walking'],
                        selectedValue: selectedJobType3,
                        onChanged: (value) {
                          setState(() {
                            selectedJobType3 = value;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text("12-02-2025", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 4),
            // ORN Label
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ORN. 00001-0000001",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                CustomTextField(
                  label: "Company Name",
                  borderColor: Colors.red,
                  hintText: "xyz",
                ),
                CustomTextField(
                  label: "Trade Licence Number ",
                  borderColor: Colors.red,
                  hintText: "1234",
                ),
                CustomTextField(
                  label: "Company Code ",
                  borderColor: Colors.red,
                  hintText: "456",
                ),
                CustomTextField(
                  label: "Establishment Number ",
                  borderColor: Colors.red,
                  hintText: "xxxxxxxxx",
                ),
              ],
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                CustomTextField(
                  label: "Note Extra ",
                  borderColor: Colors.red,
                  hintText: "xxxxxxxxx",
                ),
                CustomTextField(
                  label: "Email I'd ",
                  borderColor: Colors.red,
                  hintText: "@gmail.com",
                ),
                CustomTextField(
                  label: "Contact Number ",
                  borderColor: Colors.red,
                  hintText: "03xxxxxxxxxx",
                ),
                CustomTextField(
                  label: "Contact Number 2",
                  borderColor: Colors.red,
                  hintText: "03xxxxxxxxxx",
                ),
                CustomTextField(
                  label: "Physical Address",
                  borderColor: Colors.red,
                  hintText: "Address,house,street,town,post code",
                ),
                CustomTextField(
                  label: "E- Channel Name",
                  borderColor: Colors.red,
                  hintText: "S.E.C.P",
                ),
                CustomTextField(
                  label: "E- Channel Login I'd",
                  borderColor: Colors.red,
                  hintText: "S.E.C.P",
                ),
                CustomTextField(
                  label: "E- Channel Login Password",
                  borderColor: Colors.red,
                  hintText: "xxxxxxx",
                ),
                CustomTextField(
                  label: "Doc Name",
                  borderColor: Colors.red,
                  hintText: "xxxxxxx",
                ),
                CustomTextField(
                  label: "Issue Date Notifications",
                  controller: _dateTimeController,
                  readOnly: true,
                  onTap: _pickDateTime,
                  borderColor: Colors.red,
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
                CustomTextField(
                  label: "Expiry Date Notification",
                  controller: _dateTimeController,
                  readOnly: true,
                  onTap: _pickDateTime,
                  borderColor: Colors.red,
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
                CustomButton(
                  text: 'Upload File',
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  icon: Icons.file_copy_outlined,
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
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
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                CustomDropdownField(
                  hintText: "Employee",
                  items: ['Partner', 'Employee', 'Other Records'],
                  selectedValue: selectedJobType4,
                  onChanged: (value) {
                    setState(() {
                      selectedJobType4 = value;
                    });
                  },
                ),
                _buildDropdownWithPlus1(
                  context: context,
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
                CustomTextField(
                  label: " Name",
                  borderColor: Colors.red,
                  hintText: "Imran Khan",
                ),
                CustomTextField(
                  label: "Emirates IDs",
                  borderColor: Colors.red,
                  hintText: "S.E.C.P",
                ),
                CustomTextField(
                  label: "Work Permit No",
                  borderColor: Colors.red,
                  hintText: "xxxxxxx",
                ),
                CustomTextField(
                  label: "Email I'd",
                  borderColor: Colors.red,
                  hintText: "xxxxxxx",
                ),
                CustomTextField(
                  label: "Contact No",
                  borderColor: Colors.red,
                  hintText: "xxxxxxx",
                ),
                CustomTextField(
                  label: "Doc Name",
                  borderColor: Colors.red,
                  hintText: "xxxxxxx",
                ),
                CustomTextField(
                  label: "Issue Date Notifications",
                  controller: _dateTimeController,
                  readOnly: true,
                  onTap: _pickDateTime,
                  borderColor: Colors.red,
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
                CustomTextField(
                  label: "Expiry Date Notification",
                  controller: _dateTimeController,
                  readOnly: true,
                  onTap: _pickDateTime,
                  borderColor: Colors.red,
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
                CustomButton(
                  text: 'Upload File',
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  icon: Icons.file_copy_outlined,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Add 2 more",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
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
            SizedBox(height: 10,),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                CustomTextField(
                  label: "Advance Payment TID",
                  borderColor: Colors.red,
                  hintText: "xxxxxxx",
                ),
                CustomCompactInfoBox(
                  title: "Pending Payment",
                  subtitle: "AED-3000",
                  backgroundColor: Colors.blue.shade50,
                  borderColor: Colors.blue,
                ),
                CustomCompactInfoBox(
                  title: "Advance Payment",
                  subtitle: "AED-3000",
                  backgroundColor: Colors.blue.shade50,
                  borderColor: Colors.blue,
                ),
              ],
            ), SizedBox(height: 10),
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
            SizedBox(height: 10),

          ],
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

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final Color borderColor;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;

  const CustomTextField({
    Key? key,
    required this.label,
    this.borderColor = Colors.grey,
    this.controller,
    this.hintText,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4.5, // 5 per row
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.red),

            hintStyle: TextStyle(color: borderColor),
            hintText: hintText,
            labelText: label,
            prefixIcon: prefixIcon,
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
        ),
      ),
    );
  }
}

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
