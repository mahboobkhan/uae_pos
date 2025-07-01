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

  Future<void> _selectDateTime() async {
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
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  children: const [
                    Text(
                      "Create New Order",
                      style: TextStyle(
                        fontSize: 22,
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
                )
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildDateTimeField(),
                _buildTextField("Client (Search/Type) ", _clientController),
                _buildDropdown("Order Type ", selectedOrderType, ["Services Base / Project base"], (val) {
                  setState(() => selectedOrderType = val);
                }),
                _buildDropdown("Service Project ", selectedServiceProject, ["Passport Renewal"], (val) {
                  setState(() => selectedServiceProject = val);
                }),
                _buildDropdown("Assign Employee", selectedEmployee, ["Muhammad Imran"], (val) {
                  setState(() => selectedEmployee = val);
                }),
                _buildTextField("Service Beneficiary", _beneficiaryController),
                _buildTextField("Quote Price ", _quotePriceController),
                _buildTextField("Received Funds", _fundsController),
                _buildTextField("Payment ID", _paymentIdController),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
              CustomButton(text: "Save Draft",backgroundColor: Colors.blue, onPressed: (){

              }),
                const SizedBox(width: 20),
                CustomButton(text: "Submit",backgroundColor: Colors.red, onPressed: (){

                }),
              ],
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
            labelStyle: const TextStyle(fontSize: 12),
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_month_outlined, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 12),
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
          labelStyle: const TextStyle(fontSize: 12),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: const OutlineInputBorder(
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
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        onChanged: onChanged,
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e,style: TextStyle(fontSize: 12),))).toList(),
      ),
    );
  }
}
