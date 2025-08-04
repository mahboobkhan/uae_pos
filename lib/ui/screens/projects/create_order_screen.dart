import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dialogs/calender.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';

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
  String? selectedService;
  final List<String> serviceOptions = ['Cleaning', 'Consulting', 'Repairing'];
  final _beneficiaryController = TextEditingController();
  final _recordPaymentController = TextEditingController();
  final _applicationController = TextEditingController();
  final _servicesDepartment = TextEditingController();
  final _stepCost = TextEditingController();
  final _additionalProfit = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();

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

  void _selectedDateTime() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: CustomCupertinoCalendar(
            onDateTimeChanged: (date) {
              selectedDate = date;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text("Cancel",style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () {
                _issueDateController.text =
                "${selectedDate.day}-${selectedDate.month}-${selectedDate.year} "
                    "${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}";
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK",style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
              color: Colors.white,
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
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            final shouldClose = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                backgroundColor: Colors.white,
                                title: const Text("Are you sure?"),
                                content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Keep Changes ",style: TextStyle(color:Colors.blue ),),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Close",style: TextStyle(color:Colors.red ),),
                                  ),
                                ],
                              ),
                            );

                            if (shouldClose == true) {
                              Navigator.of(context).pop(); // close the dialog
                            }
                          },
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
                          ["Show Search Result", ""],
                          (val) {
                            setState(() => searchClient = val);
                          },
                        ),
                        CustomDropdownField(
                          label:
                          "Order Type ",
                          selectedValue:
                          selectedOrderType,
                          options:
                          ["Services Base", " Project base"],
                          onChanged:
                          (val) {
                            setState(() => selectedOrderType = val);
                          },
                        ),
                        CustomDropdownField(
                          label:
                          "Service Project ",
                          selectedValue:
                          selectedServiceProject,
                          options:
                          ["Passport Renewal", "Development", "Id Card"],
                          onChanged:
                          (val) {
                            setState(() => selectedServiceProject = val);
                          },
                        ),
                        CustomTextField(
                          label: "Service Beneficiary",
                          controller: _beneficiaryController,
                          hintText: "xyz",
                        ),
                        CustomTextField(
                          label: "Order Quote Price",
                          controller: _fundsController,
                          hintText: '500',
                        ),

                        InfoBox(
                          label: 'Muhammad Imran',
                          value: 'Assign Employee',
                          color: Colors.blue.shade200, // light blue fill
                        ),
                        InfoBox(
                          label: '500',
                          value: 'Received Funds',
                          color: Colors.blue.shade200, // light blue fill
                        ),
                        InfoBox(
                          label: 'xxxxxxxx',
                          value: 'Transaction Id',
                          color: Colors.yellow.shade100, // light blue fill
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        CustomButton(
                          text: "Stop",
                          backgroundColor: Colors.red,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Editing",
                          backgroundColor: Colors.blue,
                          icon: Icons.lock_open,
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
              color: Colors.white,
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
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            final shouldClose = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                backgroundColor: Colors.white,
                                title: const Text("Are you sure?"),
                                content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Keep Changes ",style: TextStyle(color:Colors.blue ),),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Close",style: TextStyle(color:Colors.red ),),
                                  ),
                                ],
                              ),
                            );

                            if (shouldClose == true) {
                              Navigator.of(context).pop(); // close the dialog
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildDateTimeField(),
                        _buildDateTimeField(),
                        InfoBoxNoColor(
                          label: "FBR",
                          value: 'Services Department ',
                        ),
                        SizedBox(
                          width: 220,
                          child: CustomDropdownWithRightAdd(
                            label: "Services Status ",
                            value: selectedService,
                            items: serviceOptions,
                            onChanged: (val) => selectedService = val,
                            onAddPressed: () {
                              showInstituteManagementDialog2(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: CustomDropdownWithRightAdd(
                            label: "Local Status ",
                            value: selectedService,
                            items: serviceOptions,
                            onChanged: (val) => selectedService = val,
                            onAddPressed: () {
                              showInstituteManagementDialog2(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: CustomDropdownWithRightAdd(
                            label: "Tracking Status ",
                            value: selectedService,
                            items: serviceOptions,
                            onChanged: (val) => selectedService = val,
                            onAddPressed: () {
                              showInstituteManagementDialog2(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Add more',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          width: 195,
                          child: CustomTextField(
                            label: "Application I’D-1",
                            hintText: "",
                            controller: _applicationController,
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          child: CustomTextField(
                            label: "Application I’D-2 ",
                            hintText: "",
                            controller: _applicationController,
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          child: CustomTextField(
                            label: "Application I’D-3",
                            hintText: "",
                            controller: _applicationController,
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          child: CustomTextField(
                            label: "Application I’D-4",
                            hintText: "",
                            controller: _applicationController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Add more',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        InfoBoxNoColor(value: "Step Cost", label: "500"),
                        CustomTextField(
                          label: "Additional Profit",
                          hintText: "50",
                          controller: _additionalProfit,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        InfoBox(
                          label: "500",
                          value: "Total Received Funds",
                          color: Colors.blue.shade200, // light blue fill
                        ),
                        InfoBox(
                          label: "300",
                          value: "Pending Funds",
                          color: Colors.blue.shade200, // light blue fill
                          // light blue fill
                        ),
                        InfoBox(
                          value: "Project Cost",
                          label: "400",
                          color: Colors.blue.shade200, // light blue fill
                        ),
                        InfoBox(
                          value: "Received Funds",
                          label: "300",
                          color: Colors.blue.shade200, // light blue fill
                        ),
                        InfoBox(
                          value: "Record Payment I’D ",
                          label: "xxxxxxxxx",
                          color: Colors.yellow.shade100,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons
                    Row(
                      children: [
                        CustomButton(
                          text: "Close Project",
                          backgroundColor: Colors.red,
                          icon: Icons.lock_open_outlined,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Editing",
                          backgroundColor: Colors.blue,
                          icon: Icons.lock_open,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Next Step",
                          backgroundColor: Colors.blue.shade200,
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

/*
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
*/

  Widget _field(
    String label,
    String value, {
    IconData? icon,
    Color? fillColor,
    TextStyle? style,
  }) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        cursorColor: Colors.blue,
        initialValue: value,
        style: style ?? const TextStyle(fontSize: 14),
        // 👈 Use it here
        readOnly: true,
        // Optional: make it non-editable
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red, fontSize: 16),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: icon != null ? Icon(icon, color: Colors.red) : null,
          filled: fillColor != null,
          fillColor: fillColor,
        ),
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
          labelText: label?.isNotEmpty == true ? label : null,
          // ✅ optional label
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
        items:
            options
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
  void showInstituteManagementDialog2(BuildContext context) {
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
                width: 363,
                height: 305,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Compact header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Services',
                          style: TextStyle(
                            fontSize: 16, // Smaller font
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    const SizedBox(height: 12),

                    // Compact input field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // align top
                      children: [
                        // TextField
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: addController,
                              cursorColor: Colors.blue,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: "Add institute...",
                                border: InputBorder.none, // remove double border
                                isDense: true,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Add Button
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),

                            ),
                            onPressed: () {
                              if (addController.text.trim().isNotEmpty) {
                                setState(() {
                                  institutes.add(addController.text.trim());
                                  addController.clear();
                                });
                              }
                            },
                            child: const Text("Add", style: TextStyle(fontSize: 14,color: Colors.white),),
                          ),
                        ),
                      ],
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
                                color: Colors.grey,
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
                                        color: Colors.green,
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
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                    ),
                    labelText: 'Edit institute',
                    labelStyle: TextStyle(
                      color: Colors.blue, ),
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
                        style: TextStyle(color: Colors.grey),
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

}
