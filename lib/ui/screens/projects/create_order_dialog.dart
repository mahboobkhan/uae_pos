import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime selectedDateTime = DateTime.now();

  final _beneficiaryController = TextEditingController();
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

  Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red, // Header background & selected date
              onPrimary: Colors.white, // Text on header
              onSurface: Colors.black, // Default text color
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    5,
                  ), // ✅ Button rounded corners
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            textTheme: const TextTheme(
              headlineSmall: TextStyle(
                // "Select Date" title
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),

              titleSmall: TextStyle(
                // Day name labels (Mon, Tue)
                fontSize: 14,
                color: Colors.grey,

                fontWeight: FontWeight.w500,
              ),
              bodyLarge: TextStyle(
                // Calendar day numbers
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
              displayLarge: TextStyle(fontSize: 11),
              displayMedium: TextStyle(fontSize: 10),
              displaySmall: TextStyle(fontSize: 7),
              /*
              headlineLarge: TextStyle(fontSize: 20),
*/
              /*
              labelLarge: TextStyle(fontSize: 20, color: Colors.red),
*/
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
                primary: Colors.red,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // ✅ Button rounded corners
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
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
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.white,
                          title: const Text("Are you sure?"),
                          content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Keep Changes ",style: TextStyle(color:Colors.blue ),),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Close",style: TextStyle(color:Colors.red ),),
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
                  _buildDropdown(
                    "Search Client ",
                    searchClient,
                    ["Show Search Result", ""],
                    (val) {
                      setState(() => searchClient = val);
                    },
                  ),
                  _buildDropdown(
                    "Order Type ",
                    selectedOrderType,
                    ["Services Base", " Project base"],
                    (val) {
                      setState(() => selectedOrderType = val);
                    },
                  ),
                  _buildDropdown(
                    "Service Project ",
                    selectedServiceProject,
                    ["Passport Renewal", "Development", "Id Card"],
                    (val) {
                      setState(() => selectedServiceProject = val);
                    },
                  ),
                  SearchTextField(
                    label: "Service Beneficiary",
                    controller: _beneficiaryController,
                  ),
                  CustomTextField(
                    label: "Order Quote Price",
                    controller: _fundsController,
                    hintText: '500',
                  ),
                  InfoBox(label: 'Muhammad Imran',
                    value: 'Assign Employee',
                      color: Colors.blue.shade200,// light blue fill
                  ),
                  InfoBox(label: '500', value: 'Received Funds',
                    color: Colors.blue.shade200,// light blue fill
                  ),
                  InfoBox(label: 'xxxxxxxx', value: 'Transaction Id',
                    color: Colors.yellow.shade100,// light blue fill
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
                    const SizedBox(width: 20),
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

  Widget _buildDropdown(
    String? label,
    String? selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label?.isNotEmpty == true ? label : null,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        onChanged: onChanged,
        items:
            options
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(fontSize: 16)),
                  ),
                )
                .toList(),
      ),
    );
  }
}
