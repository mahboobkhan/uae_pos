import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateOrderDialog extends StatefulWidget {
  const CreateOrderDialog({super.key});

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  String? selectedOrderType;
  String? selectedServiceProject;
  String? selectedEmployee;
  DateTime selectedDateTime = DateTime.now();

  final _clientController = TextEditingController(text: "");
  final _beneficiaryController = TextEditingController();
  final _quotePriceController = TextEditingController(text: "");
  final _fundsController = TextEditingController(text: "");
  final _paymentIdController = TextEditingController(text: "");

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
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
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
                  children:  [
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
                      child: Text("ORN. 00001–0000001", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildDateTimeField(),
                _buildTextField("Client (Search/Type) ", _clientController),
                _buildDropdown(
                  "Order Type ",
                  selectedOrderType,
                  ["Services Base / Project base"],
                  (val) {
                    setState(() => selectedOrderType = val);
                  },
                ),
                _buildDropdown(
                  "Service Project ",
                  selectedServiceProject,
                  ["Passport Renewal"],
                  (val) {
                    setState(() => selectedServiceProject = val);
                  },
                ),
                _buildDropdown(
                  "Assign Employee",
                  selectedEmployee,
                  ["Muhammad Imran"],
                  (val) {
                    setState(() => selectedEmployee = val);
                  },
                ),
                _buildTextField("Service Beneficiary", _beneficiaryController),
                _buildTextField("Quote Price ", _quotePriceController),
                _buildTextField("Received Funds", _fundsController),
                _buildTextField("Payment ID", _paymentIdController),
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
            labelStyle: const TextStyle(fontSize: 12,color: Colors.grey),
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_month_outlined, color: Colors.red,size: 22,),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16,color: Colors.grey),
          border: const OutlineInputBorder(), // matches _buildDateTimeField
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // same as default InputDecorator
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1), // highlight on focus
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      String? selectedValue,
      List<String> options,
      ValueChanged<String?> onChanged,
      ) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: "Select Option",
          labelStyle: TextStyle(fontSize: 16,color: Colors.grey),
          border: OutlineInputBorder(), // default border
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // default border like date field
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1), // red on focus
          ),
        ),
        onChanged: onChanged,
        items: options.map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: const TextStyle(fontSize: 12)),
          ),
        ).toList(),
      ),
    );
  }
}
