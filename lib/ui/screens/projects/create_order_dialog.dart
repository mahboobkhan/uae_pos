import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dialogs/calender.dart';
import '../../dialogs/custom_fields.dart';

class CreateOrderDialog extends StatefulWidget {
  const CreateOrderDialog({super.key});

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  String? selectedOrderType;
  String? searchClient;
  String? selectedServiceProject;
  String? selectedEmployee;
  String? _beneficiaryController;
  DateTime selectedDateTime = DateTime.now();

  final _fundsController = TextEditingController(text: "");

  /*Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red, // Header background color & selected date
              onPrimary: Colors.white,    // Header text color
              onSurface: Colors.black,    // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple, // OK/Cancel button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.deepPurple, // Dial background and selected time
                onPrimary: Colors.white,    // Selected time text color
                onSurface: Colors.black,    // Default text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple, // OK/Cancel button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }*/

  void _selectDateTime() {
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
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                 selectedDateTime =  selectedDate;
                });
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create New Order",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          "ORN. 00001–0000001",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
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
                        Navigator.of(context).pop(); // close the dialog
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildDateTimeField(),
                  CustomDropdownField(
                    label: "Search Client ",
                    selectedValue: searchClient,
                    options: ["Show Search Result", ""],
                    onChanged: (val) {
                      setState(() => searchClient = val);
                    },
                  ),
                  CustomDropdownField(
                    label: "Order Type ",
                    selectedValue: selectedOrderType,
                    options: ["Services Base", " Project base"],
                    onChanged: (val) {
                      setState(() => selectedOrderType = val);
                    },
                  ),
                  CustomDropdownField(
                    label: "Service Project ",
                    selectedValue: selectedServiceProject,
                    options: ["Passport Renewal", "Development", "Id Card"],
                    onChanged: (val) {
                      setState(() => selectedServiceProject = val);
                    },
                  ),
                  CustomDropdownWithSearch(
                    label: "Service Beneficiary",
                    options: [
                      "Passport Renewal",
                      "Development",
                      "Id Card",
                      "Passport Renewal",
                      "Development",
                      "Id Card",
                    ],
                    selectedValue: _beneficiaryController,
                    onChanged: (val) {
                      setState(() => _beneficiaryController = val);
                    },
                  ),
                  CustomTextField(
                    label: "Order Quote Price",
                    controller: _fundsController,
                    hintText: '500',
                  ),
                  InfoBox(
                    label: 'Muhammad Imran',
                    value: 'Assign Employee',
                    color: Colors.blue.shade200, // light blue fill
                  ),
                  InfoBox(
                    label: '500',
                    value: 'Received Funds',
                    color: Colors.blue.shade200, // light blue fill
                  ),
                  InfoBox(
                    label: 'xxxxxxxx',
                    value: 'Transaction Id',
                    color: Colors.yellow.shade100, // light blue fill
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Row(
                  children: [
                    CustomButton(
                      text: "Save Draft",
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: _selectDateTime,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: "Date and Time ",
            labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border: OutlineInputBorder(),
            suffixIcon: Icon(
              Icons.calendar_month_outlined,
              color: Colors.red,
              size: 22,
            ),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  /*
  Widget _buildDropdown(
      String? label,
      String? selectedValue,
      List<String> options,
      ValueChanged<String?> onChanged,
      ) {
    return SizedBox(
      width: 220,
      height: 48, // Similar to the default form field height
      child: CustomDropdown<String>(
        hintText: label ?? '',
        items: options,
        initialItem: selectedValue,
        decoration: CustomDropdownDecoration(
          closedBorder: Border.all(color: Colors.grey),
          closedBorderRadius: BorderRadius.circular(4),
          expandedBorder: Border.all(color: Colors.red, width: 1),
          expandedBorderRadius: BorderRadius.circular(4),
          closedFillColor: Colors.white,
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          listItemStyle: const TextStyle(fontSize: 16, color: Colors.black),
          closedPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          expandedPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
        onChanged: onChanged,
      ),
    );
  }
*/
}
