import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_dialoges.dart';

void EmployeeProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const EmployeProfile(),
      );
    },
  );
}

class EmployeProfile extends StatefulWidget {
  const EmployeProfile({super.key});

  @override
  State<EmployeProfile> createState() => _EmployeProfileState();
}

class _EmployeProfileState extends State<EmployeProfile> {
  String? selectedJobType;
  String? selectedJobType2;
    String? selectedJobType3;
  String? selectedJobType4;

  final TextEditingController _dateTimeController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Title and Date side by side
                Row(
                  children: [
                    const Text(
                      'Employee Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomDropdownField(
                      hintText: "Select job type",
                      items: ['Full time', 'Half Time', 'Remote'],
                      selectedValue: selectedJobType3,
                      onChanged: (value) {
                        setState(() {
                          selectedJobType3 = value;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    CustomDropdownField(
                      hintText: "select Gender",
                      items: ['Male', 'Female','Other'],
                      selectedValue: selectedJobType4,
                      onChanged: (value) {
                        setState(() {
                          selectedJobType4 = value;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                // Right: Close button
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 1.5),
                    ),
                    child: const Icon(Icons.close, color: Colors.red, size: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EID.EE/EH 10110', // Static example ID
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Fields
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomTextField(
                  label: "Employee Name",
                  borderColor: Colors.red,
                  hintText: "xyz",
                ),
                CustomDropdownField(
                  label: "Job Position",
                  items: ['Full Time', 'Part Time', 'Contract'],
                  selectedValue: selectedJobType,
                  onChanged: (value) {
                    setState(() {
                      selectedJobType = value;
                    });
                  },
                ),
                CustomTextField(
                  label: "Contact Number",
                  borderColor: Colors.red,
                  hintText: "+971",
                ),
                CustomTextField(
                  label: "Contact No - 2",
                  borderColor: Colors.red,
                  hintText: "+971",
                ),
                CustomTextField(
                  label: "Home Contact No",
                  borderColor: Colors.red,
                  hintText: "+971",
                ),
                CustomTextField(
                  label: "Work Permit No",
                  borderColor: Colors.red,
                  hintText: "+WP-1234",
                ),
                CustomTextField(
                  label: "Emirates ID",
                  borderColor: Colors.red,
                  hintText: "+12345",
                ),
                CustomTextField(
                  label: "Email ID",
                  borderColor: Colors.red,
                  hintText: "abc@gmail.com",
                ),
                CustomTextField(
                  label: "Physical Address",
                  borderColor: Colors.red,
                  hintText: "Address,house,street,town,post code",
                ),
                CustomTextField(
                  label: "Date of Joining",
                  controller: _dateTimeController,
                  readOnly: true,
                  onTap: _pickDateTime,
                  borderColor: Colors.red,
                  prefixIcon: const Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
                CustomTextField(
                  label: "Work Contract Expiry",
                  controller: _dateTimeController,
                  readOnly: true,
                  onTap: _pickDateTime,
                  borderColor: Colors.red,
                  prefixIcon: const Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
                CustomTextField(
                  label: "Birthday",
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
                CustomCompactTextField(
                  label: 'Salary',
                  hintText: 'AED-1000',
                  borderColor: Colors.red,
                ),
                CustomCompactTextField(
                  label: 'Increment',
                  hintText: '10%',
                  borderColor: Colors.red,
                ),
                CustomCompactTextField(
                  label: 'Working HOurs ',
                  hintText: '42',
                  borderColor: Colors.red,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Add More", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomTextField(label: "Note / Extra", borderColor: Colors.red),
                CustomDropdownField(
                  label: "Select Bank",
                  items: ['ubl', 'Hbl', 'Mezan'],
                  selectedValue: selectedJobType2,
                  onChanged: (value) {
                    setState(() {
                      selectedJobType2 = value;
                    });
                  },
                ),
                CustomTextField(
                  label: "Title Name",
                  borderColor: Colors.red,
                  hintText: "Address,house,street,town,post code",
                ),
                CustomTextField(
                  label: "Bank Account",
                  borderColor: Colors.red,
                  hintText: "xxxxxxxxxx",
                ),
                CustomTextField(
                  label: "IBN Number",
                  borderColor: Colors.red,
                  hintText: "xxxxxxxxxxx",
                ),
                CustomTextField(
                  label: "Contact Number",
                  borderColor: Colors.red,
                  hintText: "+971",
                ),
                CustomTextField(
                  label: "Email ID",
                  borderColor: Colors.red,
                  hintText: "@gmail.com",
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    CustomCompactInfoBox(
                      title: "Remaining Salary",
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
                    CustomCompactInfoBox(
                      title: "Bonuses",
                      subtitle: "AED-3000",
                      backgroundColor: Colors.blue.shade50,
                      borderColor: Colors.blue,
                    ),
                    CustomCompactInfoBox(
                      title: "Fine Deductions",
                      subtitle: "AED-3000",
                      backgroundColor: Colors.blue.shade50,
                      borderColor: Colors.blue,
                    ),
                    CustomCompactInfoBox(
                      title: "Show Payments",
                      subtitle: "AED-3000",
                      backgroundColor: Colors.blue.shade50,
                      borderColor: Colors.blue,
                    ),

                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    CustomCompactTextField(
                      label: 'Salary Paid UID ',
                      hintText: 'xxxxxxxxx',
                      borderColor: Colors.red,
                    ),
                    CustomCompactTextField(
                      label: 'Close Paid TID ',
                      hintText: 'xxxxxxxx',
                    ),
                    CustomCompactTextField(
                      label: 'Doc Name ',
                    ),
                    CustomCompactTextField(
                      label: 'Swift Code ',
                      hintText: 'xxx',
                      borderColor: Colors.red,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomTextField(
                  label: "Last Salary Date",
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
                  label: "Expiry Date Notifications",
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
            Row(
              children: [
                CustomButton(
                  text: "Editing",
                  backgroundColor: Colors.blue,
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                CustomButton(
                  text: "Stop Contract",
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
}

// Reusable text field widget
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

class CustomCompactTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final Color borderColor;
  final Color? fillColor;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;

  const CustomCompactTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.borderColor = Colors.grey,
    this.fillColor,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6.5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.red),
            hintText: hintText,
            hintStyle: TextStyle(color: borderColor),
            prefixIcon: prefixIcon,
            isDense: true,
            filled: fillColor != null,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            // 👈 Same height
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
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
