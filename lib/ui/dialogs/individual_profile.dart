import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calender.dart';
import 'custom_dialoges.dart';
import 'custom_fields.dart';

void showIndividualProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: IndividualProfileDialog(),
      );
    },
  );
}

class IndividualProfileDialog extends StatefulWidget {
  @override
  State<IndividualProfileDialog> createState() =>
      _IndividualProfileDialogState();
}

class _IndividualProfileDialogState extends State<IndividualProfileDialog> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController channelNameController = TextEditingController();
  final TextEditingController channelLoginController = TextEditingController();
  final TextEditingController advancePaymentController =
      TextEditingController();
  final TextEditingController channelPasswordController =
      TextEditingController();
  final TextEditingController _physicalAddressController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController emiratesIdController = TextEditingController();
  final TextEditingController emailId = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final TextEditingController contactNumber2 = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  void _pickDateTime2() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: CustomCupertinoCalendar(
            onDateTimeChanged: (date) {
              selectedDate = date;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text("Cancel",style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () {
                _issueDateController.text =
                "${selectedDate.day}-${selectedDate.month}-${selectedDate.year} "
                    "${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}";
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK",style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String? selectedJobType3;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedJobType2;

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Individual Profile',
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
                          label: " Type",
                          options: ['Regular', 'Walking'],
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
                'ORN.0001-0000001', // Static example ID
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(
                    label: "Client Name",
                    hintText: "xyz",
                    controller: clientNameController,
                  ),
                  CustomTextField(
                    label: "Emirates ID ",
                    controller: emiratesIdController,
                    hintText: "1234",
                  ),
                  CustomTextField(
                    label: "Email ID ",
                    controller: emailId,
                    hintText: "456",
                  ),
                  CustomTextField(
                    label: "Contact Number ",
                    controller: contactNumber,
                    hintText: "xxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Contact Number 2",
                    controller: contactNumber2,
                    hintText: "xxxxxxxxx",
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
                  CustomTextField(
                    label: "Advance Payment TID",
                    controller: advancePaymentController,
                    hintText: "*****",
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 450,
                    child: CustomTextField(
                      label: "Physical Address",
                      hintText: "Address,house,street,town,post code",
                      controller: _physicalAddressController,
                    ),
                  ),
                  SizedBox(
                    width: 450,
                    child: CustomTextField(
                      label: "Note / Extra",
                      controller: _noteController,
                      hintText: 'xxxxx',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
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
                        onPressed: () {},
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
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          // Label color
          isDense: true,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            // Red border on focus
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomDropdownField(
          label: "Type",
          items: ['Regular', 'Walking'],
          selectedValue: selectedJobType2,
          onChanged: (value) {
            setState(() {
              selectedJobType2 = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildPaymentTile("Pending Payments", "9700", Colors.red),
        _buildPaymentTile("Advance Payment", "10,000", Colors.green),
      ],
    );
  }

  Widget _buildPaymentTile(String title, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadRow() {
    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.check_circle, color: Colors.green, size: 24),
        CustomButton(
          text: 'Upload File',
          onPressed: () {},
          backgroundColor: Colors.green,
          icon: Icons.file_copy_outlined,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomButton(
          text: 'Editing',
          onPressed: () {},
          backgroundColor: Colors.blue,
        ),
        const SizedBox(width: 20),
        CustomButton(
          text: 'Submit',
          onPressed: () {},
          backgroundColor: Colors.red,
        ),
      ],
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
      width: 250,
      height: 56, // <-- Matches default TextField height
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isDense: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
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
    );
  }
}
