import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';

import '../../../dialogs/custom_fields.dart';


class DialogueBankTransaction extends StatefulWidget {
  const DialogueBankTransaction({super.key});

  @override
  State<DialogueBankTransaction> createState() => _DialogueBankTransactionState();
}

class _DialogueBankTransactionState extends State<DialogueBankTransaction> {
  String? selectedBank;
  String? selectedPaymentType;

  late TextEditingController _amountController;
  late TextEditingController _searchController;
  late TextEditingController _paymentByController;
  late TextEditingController _receivedByController;
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _amountController = TextEditingController();
    _paymentByController = TextEditingController();
    _receivedByController = TextEditingController();
    _serviceTIDController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paymentByController.dispose();
    _receivedByController.dispose();
    _serviceTIDController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Client Transactions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "TID. 00001-292382",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _formattedDate(),
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.close, size: 25,color: Colors.red,),
                        // Smaller icon
                        padding: EdgeInsets.zero,
                        // Remove default padding
                        constraints: const BoxConstraints(),
                        // Remove minimum size
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomDropdownField(
                    label: 'Select Bank',
                    selectedValue: selectedBank,
                    options: ['HBL', 'UBL', 'OTHER'],
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value;
                      });
                    },
                  ),
                  CustomDropdownField(
                    label: "Payment",
                    selectedValue: selectedPaymentType,
                    options: ["In", "Out"],
                    onChanged: (value) => setState(() => selectedPaymentType = value),
                  ),
                  CustomTextField(label: "Amount",controller:  _amountController,hintText: '300',),
                  _buildTextFieldSearch("Select Project", _searchController,),
                  CustomTextField(label: "Payment By", controller:_paymentByController, hintText: "John Doe", ),
                  CustomTextField(label: "Received By", controller:_receivedByController,hintText: 'Auto fill'),
                  CustomTextField(label: "Service TID",controller:  _serviceTIDController,hintText: 'Bank Transation ID ',),
                  CustomTextField(label: "Note", controller: _noteController,hintText: 'xxxx',),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    onPressed: () {},
                    text: "Editing",
                    backgroundColor: Colors.blue,

                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    onPressed: () {},
                    text: "Submit",
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  }

  Widget _buildTextField(String label, TextEditingController controller, {
    bool enabled = true,
    double width = 220,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    double width = 220,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red)
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          border: const OutlineInputBorder(),
        ),
        items: options
            .map((String val) => DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

void showBankTransactionDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const DialogueBankTransaction(),
  );
}

Widget _buildTextFieldSearch(
    String label,
    TextEditingController controller, {
      bool enabled = true,
      double width = 220,
    }) {
  return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        suffixIcon: Icon(Icons.search, color: Colors.grey),
      ),
    ),
  );
}
