import 'package:flutter/material.dart';

import 'custom_dialoges.dart';

void showIndividualProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.transparent,
        child: Material(
          elevation: 12,
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 820,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: IndividualProfileDialog(),
          ),
        ),
      );
    },
  );
}

class IndividualProfileDialog extends StatefulWidget {
  @override
  State<IndividualProfileDialog> createState() =>
      _IndividualProfileDialogState();
}

class _IndividualProfileDialogState extends State<IndividualProfileDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedJobType2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Individual Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "ORN. 00001-0000001",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(top: 4.0,left: 4),
              child: Text("12-02-2025", style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _buildStatusBar(),
              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  _buildTextField("Client Name"),
                  _buildTextField("Emiratis I'd"),
                  _buildTextField("Email I'd"),
                  _buildTextField("Contact Number"),
                  _buildTextField("Contact Number - 2"),
                  _buildTextField("Note/Extra"),
                  _buildTextField("Physical Address"),
                  _buildTextField("E-Channel Name(Website link)"),
                  _buildTextField("E-Channel Login I'd"),
                  _buildTextField("E-Channel Login Password"),
                  _buildTextField("Advance Payment TID"),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Add More",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildPaymentRow(),
              const SizedBox(height: 10),
              _buildDocumentUploadRow(),
              const SizedBox(height: 10),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          // Label color
          isDense: true,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            // Red border on focus
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomDropdownField(
          label: "Type",
          items: ['Regular', 'Walking'],
          selectedValue: selectedJobType2,
          onChanged: (value) {
            setState(() {
              selectedJobType2 = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildPaymentTile("Pending Payments", "9700", Colors.red),
        _buildPaymentTile("Advance Payment", "10,000", Colors.green),
      ],
    );
  }

  Widget _buildPaymentTile(String title, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadRow() {
    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.check_circle, color: Colors.green, size: 24),
        CustomButton(
          text: 'Upload File',
          onPressed: () {},
          backgroundColor: Colors.green,
          icon: Icons.file_copy_outlined,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomButton(
          text: 'Editing',
          onPressed: () {},
          backgroundColor: Colors.blue,
        ),
        const SizedBox(width: 20),
        CustomButton(
          text: 'Submit',
          onPressed: () {},
          backgroundColor: Colors.red,
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Color borderColor;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    this.label,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 56, // <-- Matches default TextField height
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isDense: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
        ),
        hint: hintText != null ? Text(hintText!) : null,
        icon: const Icon(Icons.arrow_drop_down),
        items:
            items.map((item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
