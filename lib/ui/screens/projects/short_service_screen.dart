import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';

class ShortServiceScreen extends StatefulWidget {
  const ShortServiceScreen({super.key});

  @override
  State<ShortServiceScreen> createState() => _ShortServiceScreenState();
}

class _ShortServiceScreenState extends State<ShortServiceScreen> {
  // List of filter options
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
  String? selectedCategory3;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
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
                    hintText: "Status",
                    items: categories,
                    onChanged: (newValue) {
                      setState(() => selectedCategory = newValue!);
                    },
                  ),
                  CustomDropdown(
                    selectedValue: selectedCategory1,
                    hintText: "Select Tags",
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
                  CustomDropdown(
                    selectedValue: selectedCategory3,
                    hintText: "Dates",
                    items: categories3,
                    onChanged: (newValue) {
                      setState(() => selectedCategory3 = newValue!);
                    },
                    icon: const Icon(Icons.calendar_month, size: 18),
                  ),
                  const Spacer(),
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 20),
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
                      },
                      children: [
                        // Header Row
                        TableRow(
                          decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                          children: [
                            _buildHeader("Date"),
                            _buildHeader("Service Beneficiary "),
                            _buildHeader("Tags Details"),
                            _buildHeader("Status"),
                            _buildHeader("Stage"),
                            _buildHeader("Payment Pending"),
                            _buildHeader("Quotation "),
                            _buildHeader("Manage"),
                            _buildHeader("Ref Id"),
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
                            _buildCell("Sample Tags"),
                            _buildCell("In progress"),
                            _buildCell("PB-02 - 23days"),
                            _buildCell("300"),
                            _buildCell("500"),
                            _buildCell("Mr. Imran"),
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
    );
  }


  Widget _buildHeader(String text) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(color: Colors.red),
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
