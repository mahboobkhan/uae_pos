
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart' show CustomTextField, InfoBox;
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
  final _beneficiaryController = TextEditingController();
  final _fundsController = TextEditingController(text: "");
  String? selectedOrderType;
  String? searchClient;
  String? selectedServiceProject;
  String? selectedEmployee;
  List<DropdownItem> orderTypes = [
    DropdownItem("001", "Services Base"),
    DropdownItem("002", "Project Base"),
  ];

  DateTime selectedDateTime = DateTime.now();

  final _clientController = TextEditingController(text: "Sample Client");

  final _quotePriceController = TextEditingController(text: "500");
  final _paymentIdController = TextEditingController(text: "TID 00001–01");



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
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Colors.red),
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
                        _buildDropdown(
                          "Search Client ",

                          searchClient,
                          ["Show Search Result" ,""],
                              (val) {
                            setState(() => searchClient = val);
                          },
                        ),
                        _buildDropdown(
                          "Order Type ",
                          selectedOrderType,
                          ["Services Base" ," Project base"],
                              (val) {
                            setState(() => selectedOrderType = val);
                          },
                        ),
                        _buildDropdown(
                          "Service Project ",
                          selectedServiceProject,
                          ["Passport Renewal","Development","Id Card"],
                              (val) {
                            setState(() => selectedServiceProject = val);
                          },
                        ),
                        CustomTextField(label: "Service Beneficiary", controller: _beneficiaryController,hintText: "xyz",),
                        CustomTextField(label: "Order Quote Price",controller:  _fundsController,hintText: '500',),

                        InfoBox(
                          label: 'Muhammad Imran',
                          value: 'Assign Employee',
                        ),
                        InfoBox(
                          label: '500',
                          value: 'Received Funds',
                        ),
                        InfoBox(
                          label: 'xxxxxxxx',
                          value: 'Transaction Id',
                        ),              ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        CustomButton(
                          text: "Editing",
                          backgroundColor: Colors.blue.shade900,
                          icon: Icons.lock_open,
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
                          backgroundColor: Colors.green,
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
                      children: [
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
                        Spacer(),
                        Material(
                          elevation: 3,
                          shadowColor: Colors.grey.shade900,
                          shape: CircleBorder(),
                          color: Colors.blue,
                          child: Tooltip(
                            message: 'Create orders',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: const Center(
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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

          labelStyle: const TextStyle(color: Colors.red),
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
          labelText: label?.isNotEmpty == true ? label : null, // ✅ optional label
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
        items: options
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
