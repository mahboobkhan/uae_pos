import 'package:flutter/material.dart';

import '../../../dialogs/custom_dialoges.dart';

String? selectedPlatform;
List<String> platformList = ['Bank', 'Violet', 'Other'];

void showAddPaymentMethodDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading + BID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Add Payment Method",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "BID. 00001",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 25,color: Colors.red,),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Row 1
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownWithPlus1(
                        context: context,
                        label: "Select Platform",
                        value: selectedPlatform,
                        items: platformList,
                        onChanged: (newValue) {
                          // Update selectedPlatform state in parent
                        },
                        onAddPressed: () {
                          showInstituteManagementDialog(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField1(
                        label: 'Platform/Bank Name',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField1(
                        label: 'Title Name',
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Row 2
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField1(
                        label: 'Account No',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField1(
                        label: 'IBN',
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField1(
                        label: 'Email Id',
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Row 3
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField1(
                        label: 'Mobile Number',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField1(
                        label: "Tag Add",
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField1(
                        label: 'Bank Address Physical Address',
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomButton(
                      text: "Editing",
                      onPressed: () {},
                      backgroundColor: Colors.red,
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: "Submit",
                      onPressed: () {},
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDropdownWithPlus1({
  required BuildContext context,
  required String label,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
  required VoidCallback onAddPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 5,
    child: Stack(
      children: [
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 13, color: Colors.red),
            filled: true,
            fillColor: Colors.grey.shade200,
            // match with text field
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.fromLTRB(
              12,
              14,
              48,
              14,
            ), // match vertical padding
          ),
          isDense: true,
          style: const TextStyle(fontSize: 13),
          items:
          items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        Positioned(
          right: 4,
          top: 6,
          bottom: 6,
          child: GestureDetector(
            onTap: onAddPressed,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: const Icon(Icons.add, size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

void _showEditDialog(
    BuildContext context,
    StateSetter setState,
    List<String> institutes,
    int index,
    TextEditingController editController,
    ) {
  editController.text = institutes[index];
  showDialog(
    context: context,
    builder: (editContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 250, // Smaller width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Colors.blue,
                controller: editController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blue),
                  ),
                  labelText: 'Edit institute',
                  labelStyle: TextStyle(color: Colors.blue),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(editContext),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      if (editController.text.trim().isNotEmpty) {
                        setState(() {
                          institutes[index] = editController.text.trim();
                        });
                        Navigator.pop(editContext);
                      }
                    },
                    text: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showInstituteManagementDialog(BuildContext context) {
  final List<String> institutes = [];
  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  int? editingIndex;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ), // Slightly smaller radius
            ),
            contentPadding: const EdgeInsets.all(12), // Reduced padding
            insetPadding: const EdgeInsets.all(20), // Space around dialog
            content: SizedBox(
              width: 300, // Fixed width
              height: 400, // Fixed height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Compact header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Institutes',
                        style: TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        // Smaller icon
                        padding: EdgeInsets.zero,
                        // Remove default padding
                        constraints: const BoxConstraints(),
                        // Remove minimum size
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compact input field
                  SizedBox(
                    height: 40,
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: addController,
                      decoration: InputDecoration(
                        hintText: "Add institute...",
                        isDense: true,
                        // Makes the field more compact
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        // Border when focused
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.blue,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (addController.text.trim().isNotEmpty) {
                              setState(() {
                                institutes.add(addController.text.trim());
                                addController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Compact list
                  Expanded(
                    child:
                    institutes.isEmpty
                        ? const Center(
                      child: Text(
                        'No institutes',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: institutes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            dense: true,
                            // Makes tiles more compact
                            visualDensity: VisualDensity.compact,
                            // Even more compact
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            title: Text(
                              institutes[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: SizedBox(
                              width:
                              80, // Constrained width for buttons
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed:
                                        () => _showEditDialog(
                                      context,
                                      setState,
                                      institutes,
                                      index,
                                      editController,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      setState(() {
                                        institutes.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildTextField1({
  required String label,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: Colors.red),
      filled: true,
      fillColor: Colors.grey.shade200,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.red), // focused border
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    keyboardType: keyboardType,
    onChanged: onChanged,
  );
}
