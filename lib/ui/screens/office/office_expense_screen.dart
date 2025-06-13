import 'package:abc_consultant/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OfficeExpenseScreen extends StatefulWidget {
  const OfficeExpenseScreen({super.key});

  @override
  State<OfficeExpenseScreen> createState() => _OfficeExpenseScreenState();
}

class _OfficeExpenseScreenState extends State<OfficeExpenseScreen> {
  DateTime selectedDateTime = DateTime.now();
  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  final List<String> categories = [
    'All',
    'New',
    'Pending',
    'Completed',
    'Stop',
  ];
  String? selectedCategory;
  final List<String> categories1 = [
    'No Tags',
    'Tag 001',
    'Tag 002',
    'Sample Tag',
  ];
  String? selectedCategory1;
  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;
  final List<String> categories3 = [
    'All',
    'Toady',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                child: Row(
                  children: [
                    buildCenteredTextContainer(
                      title: "32",
                      subtitle: "Fixed Expenses",
                    ),
                    buildCenteredTextContainer(
                      title: "32",
                      subtitle: "Maintanence",
                    ),
                    buildCenteredTextContainer(
                      title: "32",
                      subtitle: "Supplies",
                    ),
                    buildCenteredTextContainer(
                      title: "32",
                      subtitle: "Miscellaneous",
                    ),
                    buildCenteredTextContainer(
                      title: "32",
                      subtitle: "Other Expenses",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Dropdowns
                    _buildDropdown(
                      selectedCategory,
                      "Customer Type",
                      categories,
                      (newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),

                    _buildDropdown(
                      selectedCategory1,
                      "Select Tags",
                      categories1,
                      (newValue) {
                        setState(() {
                          selectedCategory1 = newValue!;
                        });
                      },
                    ),
                    _buildDropdown(
                      selectedCategory2,
                      "Payment Status",
                      categories2,
                      (newValue) {
                        setState(() {
                          selectedCategory2 = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.11,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.red, width: 1.5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: const TextField(
                            style: TextStyle(fontSize: 12),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(fontSize: 12),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 280),
                    GestureDetector(
                      onTap: () {
                        showCustomExpenseDialog(context);
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(color: Colors.white),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FixedColumnWidth(90),
                  1: FixedColumnWidth(130),
                  2: FixedColumnWidth(130),
                  3: FixedColumnWidth(130),
                  4: FixedColumnWidth(130),
                  5: FixedColumnWidth(130),
                  6: FixedColumnWidth(130),
                  7: FixedColumnWidth(130),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                    children: [
                      _buildHeader("Date"),
                      _buildHeader("Expanse Type"),
                      _buildHeader("Expense Limit"),
                      _buildHeader("Expenses"),
                      _buildHeader("Note"),
                      _buildHeader("Tags"),
                      _buildHeader("Manage"),
                      _buildHeader("Action"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildCell("12-02-2025\n02:59 pm"),
                      _buildCell("Electric Bill"),
                      _buildCell("xxxxxx"),
                      _buildCell("xxxxxxxx"),
                      _buildCell("Sample Note"),
                      _buildCell("etc"),
                      _buildCell("Mr.Imran"),
                      _buildCell("Edit"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String? selectedValue,
    String hintText,
    List<String> items,
    ValueChanged<String?> onChanged, {
    Icon icon = const Icon(Icons.arrow_drop_down),
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 140,
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            icon: icon,
            hint: Text(hintText),
            style: TextStyle(fontSize: 10),
            onChanged: onChanged,
            items:
                items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: EdgeInsets.zero,
                      child: Text(value),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  // Ya custom dialog
  void showCustomExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.grey[200],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 900,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => _buildExpenseRow(context, index),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildLabelWithDate("1.${_getTitle(index)}",context)),
          const SizedBox(width: 6),
          _buildTextField("1.Paste TID"),
          const SizedBox(width: 6),
          _buildTextField("1.Expenses Value"),
          const SizedBox(width: 6),
          _buildTextField("1.Custom Note"),
          const SizedBox(width: 6),
          _buildTextField("1.Dropdown to Tag"),
          const SizedBox(width: 6),
          _buildTextField("Allocate Balance/ Remaining Balance"),
          const SizedBox(width: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onPressed: () {},
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  Widget _buildLabelWithDate(String title, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _pickDateTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat("dd-MM-yyyy — hh:mm a").format(selectedDateTime),
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.calendar_month, size: 14, color: Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTextField(String label) {
    return SizedBox(
      width: 120,
      height: 40,
      child: TextField(
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 10, color: Colors.red),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
    );
  }

  String _getTitle(int index) {
    const titles = [
      "Fixed Office Expense",
      "Office Maintenance",
      "Office Supplies",
      "Miscellaneous",
      "Dynamic Attribute Addition",
    ];
    return titles[index];
  }
}
