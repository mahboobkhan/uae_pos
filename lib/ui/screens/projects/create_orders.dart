import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dialogs/custom_dialoges.dart';

class DropdownItem {
  final String id;
  final String label;

  DropdownItem(this.id, this.label);

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label;

  @override
  int get hashCode => id.hashCode ^ label.hashCode;
}

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  List<DropdownItem> orderTypes = [
    DropdownItem("001", "Services Base"),
    DropdownItem("002", "Project Base"),
  ];
  DropdownItem? selectedOrderType;

  DateTime selectedDateTime = DateTime.now();

  final _clientController = TextEditingController(text: "Sample Client");
  final _beneficiaryController = TextEditingController(
    text: "Passport Renewal",
  );
  final _quotePriceController = TextEditingController(text: "500");
  final _fundsController = TextEditingController(text: "300");
  final _paymentIdController = TextEditingController(text: "TID 00001–01");

  String? selectedEmployee = "Muhammad Imran";

  @override
  void initState() {
    super.initState();
    selectedOrderType = orderTypes[0];
  }

  Future<void> _selectedDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Project Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text("ORN. 00001–0000001"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Input Fields Wrap
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildDateTimeField(),
                        _buildOrderTypeDropdown(
                          "Select Order Type",
                          selectedOrderType,
                          orderTypes,
                          (val) {
                            setState(() => selectedOrderType = val);
                          },
                        ),

                        _buildTextField(
                          "Select Service Project ",
                          _beneficiaryController,
                        ),
                        _buildDropdown(
                          "Project Assign Employee ",
                          selectedEmployee,
                          ["Muhammad Imran"],
                          (val) {
                            setState(() => selectedEmployee = val);
                          },
                        ),
                        _buildTextField(
                          "Service Beneficiary ",
                          _clientController,
                        ),
                        _buildTextField(
                          "Order Quote Price ",
                          _quotePriceController,
                        ),
                        _buildTextField("Received Funds", _fundsController),
                        _buildTextField(
                          "Record Payment I’d ",
                          _paymentIdController,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        CustomButton(
                          text: "Editing",
                          backgroundColor: Colors.blue.shade900,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Stop",
                          backgroundColor: Colors.black,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Submit",
                          backgroundColor: Colors.red,
                          onPressed: () {},
                        ),
                        const Spacer(), // Pushes the icon to the right

                        Material(
                          elevation: 8,
                          color: Colors.blue, // Set background color here
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(
                              Icons.print,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Printed"),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.black87,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Title
                    Row(
                      children: const [
                        Text(
                          "Stage – 01",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("SID–10000001"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _field(
                          "Date and Time",
                          DateFormat(
                            "dd-MM-yyyy – hh:mm a",
                          ).format(selectedDateTime),
                          icon: Icons.calendar_month,
                        ),
                        _field(
                          "Reminder Date and Time",
                          DateFormat(
                            "dd-MM-yyyy – hh:mm a",
                          ).format(selectedDateTime),
                          icon: Icons.calendar_month,
                        ),
                        _field(
                          "Services Department ",
                          "FBR – Federal Board of Revenue",
                        ),
                        _field("Services Status Update ", "Pending for review"),
                        _field("Local Status ", "In Progress"),
                        _field("Tracking Status Tag", "Xyz Status"),
                        _noteText("Dynamic Attribute Sign"),
                        _field("Application I’d – 1", ""),
                        _noteText("Dynamic Application ID Sign"),

                        _field(
                          "Received Funds",
                          "XXX",
                          fillColor: Colors.green.shade100,
                        ),
                        _field(
                          "Pending Funds",
                          "XXX",
                          fillColor: Colors.red.shade100,
                        ),
                        _field(
                          "Project Cost",
                          "XXX",
                          fillColor: Colors.blue.shade100,
                        ),
                        _field("Record Payment I’d ", "TID 00001-01"),
                        _field("Received Funds", "300"),
                        _field("Step Cost", "500"),
                        _field("Additional Profit", "50"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons
                    Row(
                      children: [
                        CustomButton(
                          text: "Close Project",
                          backgroundColor: Colors.black,
                          icon: Icons.lock_open_outlined,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Next Step",
                          backgroundColor: Colors.blue,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Submit",
                          backgroundColor: Colors.red,
                          onPressed: () {},
                        ),
                        const Spacer(), // Pushes the icon to the right
                        Material(
                          elevation: 8,
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: IconButton(
                              icon: Icon(
                                Icons.print,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Printed"),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.black87,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                // Handle print action
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        onTap: _selectedDateTime,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Date and Time",
            labelStyle: TextStyle(color: Colors.red),
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_month, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: TextStyle(fontSize: 14),
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
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
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
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
        ),
        items:
            options.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildLabeledFieldWithHint({
    required String label,
    required String hint,
    required DateTime selectedDateTime,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.red),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.red),
            helperText: hint,
            // This acts like a hint below the field
            helperStyle: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    String value, {
    IconData? icon,
    Color? fillColor,
  }) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        cursorColor: Colors.blue,
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red, fontSize: 16),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: icon != null ? Icon(icon, color: Colors.red) : null,
          filled: fillColor != null,
          fillColor: fillColor,
        ),
      ),
    );
  }

  Widget _noteText(String text) {
    return SizedBox(
      width: 220,
      child: Text(
        text,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOrderTypeDropdown(
    String label,
    DropdownItem? selectedValue,
    List<DropdownItem> options,
    ValueChanged<DropdownItem?> onChanged,
  ) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<DropdownItem>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,

          labelStyle: const TextStyle(color: Colors.red,),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        items:
            options.map((DropdownItem item) {
              return DropdownMenuItem<DropdownItem>(
                value: item,
                child: Text(item.label),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
