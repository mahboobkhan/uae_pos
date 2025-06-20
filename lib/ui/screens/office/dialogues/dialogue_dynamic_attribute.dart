import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogueDynamicAddition extends StatefulWidget {
  const DialogueDynamicAddition({super.key});

  @override
  State<DialogueDynamicAddition> createState() =>
      _DialogueDynamicAdditionState();
}

class _DialogueDynamicAdditionState extends State<DialogueDynamicAddition> {
  DateTime selectedDateTime = DateTime.now();
  String? selectedExpense;

  late TextEditingController _pasteTIDController;
  late TextEditingController _expanseValueController;
  late TextEditingController _customNoteController;
  late TextEditingController _allocateBalanceController;

  @override
  void initState() {
    super.initState();
    _pasteTIDController = TextEditingController();
    _expanseValueController = TextEditingController();
    _customNoteController = TextEditingController();
    _allocateBalanceController = TextEditingController();
  }

  @override
  void dispose() {
    _pasteTIDController.dispose();
    _expanseValueController.dispose();
    _customNoteController.dispose();
    _allocateBalanceController.dispose();
    super.dispose();
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  "Dynamic Attribute Addition",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),

                // Input Fields
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildDateTimeField(),
                    _buildTextField("TID", _pasteTIDController),
                    _buildTextField("Expanse Value", _expanseValueController),

                    _buildDropdown(
                      "Select Expense Type",
                      selectedExpense,
                      ["Hostel Rent Personal"],
                      (val) => setState(() => selectedExpense = val),
                    ),
                    _buildTextField(
                      "Allocate Balance",
                      _allocateBalanceController,
                    ),
                    _buildTextField("Note", _customNoteController, width: 450),
                  ],
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    _buildColoredButton("Editing", Colors.blue, context),
                    const SizedBox(width: 10),
                    _buildColoredButton("Stop", Colors.black, context),
                    const SizedBox(width: 10),
                    _buildColoredButton("Submit", Colors.red, context),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.print,
                          color: Colors.white,
                          size: 20,
                        ),
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
}

Widget _buildTextField(
  String label,
  TextEditingController controller, {
  double width = 220,
}) {
  return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
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

Widget _buildColoredButton(String text, Color color, BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text(text),
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

void showDynamicAttributeDialogue(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Center(
          child: const DialogueDynamicAddition(),
        ), // No extra Dialog wrapper
  );
}
