import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final List<String> categories = ['All', 'Full time job', 'half time job', 'Old employee'];
  final List<String> categories1 = ['All', 'Name 1 - Manager', 'Name 1 - Manager', 'Name 1 - Manager'];
  final List<String> categories2 = ['All', 'paid', 'Pending'];
  final List<String> categories3 = ['All', 'This Month', 'Last Month', 'Select on Calender'];

  String? selectedCategory;
  String? selectedCategory1;
  String? selectedCategory2;
  String? selectedCategory3;
  bool _isHovering = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow:
                    _isHovering
                        ? [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: 4,
                        spreadRadius: 0.1,
                        offset: Offset(0, 1),
                      ),
                    ]
                        : [],
                  ),

                  child: Row(
                    children: [
                      CustomDropdown(
                        selectedValue: selectedCategory,
                        hintText: "Employee Type",
                        items: categories,
                        onChanged: (newValue) {
                          setState(() => selectedCategory = newValue!);
                        },
                      ),
                      CustomDropdown(
                        selectedValue: selectedCategory1,
                        hintText: "Employee List",
                        items: categories1,
                        onChanged: (newValue) {
                          setState(() => selectedCategory1 = newValue!);
                        },
                      ),
                      CustomDropdown(
                        selectedValue: selectedCategory2,
                        hintText: "Payment Status",
                        items: categories2,
                        onChanged: (newValue) {
                          setState(() => selectedCategory2 = newValue!);
                        },
                      ),
                      Spacer(),
                      PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(value: 'Short Employee', child: Text('Short Employee')),
                          const PopupMenuItem<String>(value: 'Add Employee', child: Text('Add Employee')),
                        ],
                        child: Container(
                          width: 35,
                          height: 35,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Center(child: Icon(Icons.add, color: Colors.white, size: 20)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 1200
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border: TableBorder.all(color: Colors.white),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(0.8),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1.3),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                          },
                          children: [
                            // Header Row
                            TableRow(
                              decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                              children: [
                                _buildHeader("Date"),
                                _buildHeader("Employee Name\nReference id "),
                                _buildHeader("Job Positions"),
                                _buildHeader("Payment Mode"),
                                _buildHeader("Salary"),
                                _buildHeader("Advance"),
                                _buildHeader("Bonuses "),
                                _buildHeader("Pending"),
                                _buildHeader("Total "),
                                _buildHeader("Others"),
                              ],
                            ),
                            // Sample Row
                            for (int i = 0; i < 20; i++)
                              TableRow(
                                children: [
                                  _buildCell("12-02-2025\n02:59 pm"),
                                  _buildCell(
                                    "xxxxxxxxx245",
                                    copyable: true,
                                  ),
                                  _buildCell("Manager"),
                                  _buildCell("Bank Transfer/By Hand/n TID xxxxxxx234"
                                      ),
                                  _buildCell("100000"),
                                  _buildCell("300"),
                                  _buildCell("2000"),
                                  _buildCell("N/A"),
                                  _buildCell("1400"),
                                  _buildCell("xxxxxxxxx245", copyable: true),
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
      ),
    );
  }



  Widget _buildHeader(String text) {
    return Container(
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle( color: Colors.red), textAlign: TextAlign.center),
    );
  }

  Widget _buildCell(String text, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
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
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.copy, size: 16, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }


}
