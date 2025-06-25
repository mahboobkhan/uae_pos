import 'package:abc_consultant/ui/screens/office/dialogues/dialogue_dynamic_attribute.dart';
import 'package:abc_consultant/ui/screens/office/dialogues/dialogue_fixed_office_expense.dart';
import 'package:abc_consultant/ui/screens/office/dialogues/dialogue_maintainance.dart';
import 'package:abc_consultant/ui/screens/office/dialogues/dialogue_miscellaneous.dart';
import 'package:abc_consultant/ui/screens/office/dialogues/dialogue_supplies_office.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../dialogs/custom_dialoges.dart';

class OfficeExpenseScreen extends StatefulWidget {
  const OfficeExpenseScreen({super.key});

  @override
  State<OfficeExpenseScreen> createState() => _OfficeExpenseScreenState();
}

class _OfficeExpenseScreenState extends State<OfficeExpenseScreen> {
  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  final List<Map<String, dynamic>> stats = [
    {'label': 'Revenue', 'value': '25K'},
    {'label': 'Users', 'value': '1.2K'},
    {'label': 'Orders', 'value': '320'},
    {'label': 'Visits', 'value': '8.5K'},
    {'label': 'Returns', 'value': '102'},
  ];

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
            SizedBox(
              height: 120,
              child: Row(
                children:
                stats.map((stat) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Material(
                        elevation: 12,
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white70,
                        shadowColor: Colors.black,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                stat['value'],
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                stat['label'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),
            MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow:
                      _isHovering
                          ? [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 4,
                              spreadRadius: 0.2,
                              offset: const Offset(0, 1),
                            ),
                          ]
                          : [],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomDropdown(
                              hintText: "Customer Type",
                              selectedValue: selectedCategory,
                              items: categories,
                              onChanged: (newValue) {
                                setState(() => selectedCategory = newValue!);
                              },
                            ),
                            CustomDropdown(
                              hintText: "Select Tags",
                              selectedValue: selectedCategory1,
                              items: categories1,
                              onChanged: (newValue) {
                                setState(() => selectedCategory1 = newValue!);
                              },
                            ),
                            CustomDropdown(
                              hintText: "Payment Status",
                              selectedValue: selectedCategory2,
                              items: categories2,
                              onChanged: (newValue) {
                                setState(() => selectedCategory2 = newValue!);
                              },
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  shadowColor: Colors.grey.shade700,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.11,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: const TextField(
                                      style: TextStyle(fontSize: 12),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        hintStyle: TextStyle(fontSize: 12),
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Card(
                                  elevation: 4,
                                  shape: const CircleBorder(),
                                  // Make the card circular
                                  shadowColor: Colors.grey.shade700,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle, // Circular shape
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () => showFixedOfficeExpanseDialogue(context),
                        child: Tooltip(
                          message: 'Add Fixed Office Expense',
                          child: Icon(Icons.attach_money, color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap:
                          () => showOfficeMaintainanceExpanseDialogue(context),
                      child: Tooltip(
                        message: 'Add Office Maintenance',

                        child: Icon(Icons.build, color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () => showOfficeSuppliesDialogue(context),
                      child: Tooltip(
                        message: 'Add Office Supplies',
                        child: Icon(Icons.shopping_bag, color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () => showMiscellaneousDialogue(context),
                      child: Tooltip(
                        message: 'Add Miscellaneous',
                        child: Icon(Icons.category, color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () => showDynamicAttributeDialogue(context),
                      child: Tooltip(
                        message: 'Add Dynamic Attribute',
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 225,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 1180, // Force horizontal scrolling
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder.all(color: Colors.white, width: 2),
                        defaultVerticalAlignment:
                        TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(0.8),
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.4),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                          7: FlexColumnWidth(1.5),
                        },
                        children: [
                          // Header Row
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                            ),
                            children: [
                              _buildHeader("Date"),
                              _buildHeader("Expance Type "),
                              _buildHeader("Expense Limit"),
                              _buildHeader("Expences"),
                              _buildHeader("Note"),
                              _buildHeader("Tags"),
                              _buildHeader("Manage"),
                              _buildHeader("Action"),
                            ],
                          ),
                          // Sample Data Row
                          for(int i =0;i<20; i++)
                            TableRow(
                              decoration: BoxDecoration(
                                color: i.isEven
                                    ? Colors.grey.shade300
                                    :Colors.grey.shade50,
                              ),
                              children: [
                                _buildCell2("12-02-2025", "02:59 pm"),
                                _buildCell("Electric Bill"),
                                _buildCell("xxxxxxx567"),
                                _buildCell("xxxxxxx"),
                                _buildCell("Sample Note"),
                                _buildCell("etc"),
                                _buildCell("Imran"),
                                _buildCell("Edit "),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
  Widget _buildCell2(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1, style: const TextStyle(fontSize: 12)),
                Text(
                  text2,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Icon(Icons.copy, size: 16, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }



  Widget _buildHeader(String text) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  Widget _buildCell(String text, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }


  // Ya custom dialog
  // void showCustomExpenseDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         backgroundColor: Colors.grey[200],
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.all(16),
  //           child: Container(
  //             width: 900,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: List.generate(
  //                 5,
  //                 (index) => _buildExpenseRow(context, index),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildExpenseRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildLabelWithDate("1.${_getTitle(index)}", context),
          ),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
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
