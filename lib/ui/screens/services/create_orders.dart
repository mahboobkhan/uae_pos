import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateOrders extends StatefulWidget {
  const CreateOrders({super.key});

  @override
  State<CreateOrders> createState() => _CreateOrdersState();
}

class _CreateOrdersState extends State<CreateOrders> {
  String? selectedOrderType;
  String? selectedServiceProject;
  String? selectedEmployee;
  DateTime selectedDateTime = DateTime.now();

  final _clientController = TextEditingController(text: "Sample Client");
  final _beneficiaryController = TextEditingController();
  final _quotePriceController = TextEditingController(text: "500");
  final _fundsController = TextEditingController(text: "500");
  final _paymentIdController = TextEditingController(text: "TID 00001-01");

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: Colors.red),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
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
                    Icon(Icons.close, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildDateTimeField(),
                    _buildTextField(
                      "Client (Search/Type) *",
                      _clientController,
                    ),
                    _buildDropdown(
                      "Order Type *",
                      selectedOrderType,
                      ["Services Base / Project base"],
                      (val) {
                        setState(() => selectedOrderType = val);
                      },
                    ),
                    _buildDropdown(
                      "Service Project *",
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
                    _buildTextField(
                      "Service Beneficiary",
                      _beneficiaryController,
                    ),
                    _buildTextField("Quote Price *", _quotePriceController),
                    _buildTextField("Received Funds", _fundsController),
                    _buildTextField("Payment ID", _paymentIdController),
                  ],
                ),
                const SizedBox(height: 30),
                // Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                        )
                      ),
                      child: Text(
                        "Save Draft",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                        )
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
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
        onTap: _selectDateTime,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Date and Time *",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
            ),
            suffixIcon: Icon(Icons.calendar_today, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime),
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
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
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
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
        ),
        onChanged: onChanged,
        items:
            options.map((e) {
              return DropdownMenuItem<String>(value: e, child: Text(e));
            }).toList(),
      ),
    );
  }
}
