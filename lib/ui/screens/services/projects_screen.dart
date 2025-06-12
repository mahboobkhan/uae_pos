import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  DateTime selectedDateTime = DateTime.now();

  final _clientController = TextEditingController(text: "Sample Client");
  final _beneficiaryController = TextEditingController(text: "Passport Renewal");
  final _quotePriceController = TextEditingController(text: "500");
  final _fundsController = TextEditingController(text: "300");
  final _paymentIdController = TextEditingController(text: "TID 00001–01");

  String? selectedOrderType = "Services Base ";
  String? selectedEmployee = "Muhammad Imran";

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
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(4),
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
                        _buildDropdown("Select Order Type", selectedOrderType, ["Services Base "], (val) {
                          setState(() => selectedOrderType = val);
                        }),
                        _buildTextField("Select Service Project ", _beneficiaryController),
                        _buildDropdown("Project Assign Employee ", selectedEmployee, ["Muhammad Imran"], (val) {
                          setState(() => selectedEmployee = val);
                        }),
                        _buildTextField("Service Beneficiary ", _clientController),
                        _buildTextField("Order Quote Price ", _quotePriceController),
                        _buildTextField("Received Funds", _fundsController),
                        _buildTextField("Record Payment I’d ", _paymentIdController),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        _buildColoredButton("Editing", Colors.blue),
                        const SizedBox(width: 10),
                        _buildColoredButton("Stop", Colors.black),
                        const SizedBox(width: 10),
                        _buildColoredButton("Submit", Colors.red),
                        const Spacer(), // Pushes the icon to the right
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.print, color: Colors.white, size: 20),
                            onPressed: () {
                              // Handle print action
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
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(4),
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
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
                        _field("Date and Time", DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime), icon: Icons.calendar_today),
                        _field("Reminder Date and Time", DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime), icon: Icons.calendar_today),
                        _field("Services Department ", "FBR – Federal Board of Revenue"),
                        _field("Services Status Update ", "Pending for review"),
                        _field("Local Status ", "In Progress"),
                        _field("Tracking Status Tag", "Xyz Status"),
                        _noteText("Dynamic Attribute Sign"),
                        _field("Application I’d – 1", ""),
                        _noteText("Dynamic Application ID Sign"),

                        _field("Received Funds", "XXX", fillColor: Colors.green.shade100),
                        _field("Pending Funds", "XXX", fillColor: Colors.red.shade100),
                        _field("Project Cost", "XXX", fillColor: Colors.blue.shade100),
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
                        _actionButton("close Project", color: Colors.black, icon: Icons.lock_open_outlined),
                        const SizedBox(width: 10),
                        _actionButton("Next Step", color: Colors.blue),
                        const SizedBox(width: 10),
                        _actionButton("Submit", color: Colors.red),
                        const Spacer(), // Pushes the icon to the right
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.print, color: Colors.white, size: 20),
                            onPressed: () {
                              // Handle print action
                            },
                          ),
                        ),
                      ],
                    ),                  ],
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
            suffixIcon: Icon(Icons.calendar_today, color: Colors.red),
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
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
        ),
        items: options.map((String value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildColoredButton(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
      ),
      onPressed: () {},
      child: Text(text),
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
            helperText: hint, // This acts like a hint below the field
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
  Widget _field(String label, String value, {IconData? icon, Color? fillColor}) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red, fontSize: 12),
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

  Widget _actionButton(String text, {required Color color, IconData? icon}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero
          ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () {},
      icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
      label: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

