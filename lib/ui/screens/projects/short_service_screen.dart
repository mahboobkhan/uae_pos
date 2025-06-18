import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                _buildDropdown(selectedCategory, "Status", categories, (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                }),
                _buildDropdown(selectedCategory1, "Select Tags", categories1, (newValue) {
                  setState(() {
                    selectedCategory1 = newValue!;
                  });
                }),
                _buildDropdown(selectedCategory2, "Payment Status", categories2, (newValue) {
                  setState(() {
                    selectedCategory2 = newValue!;
                  });
                }),
                _buildDropdown(
                  selectedCategory3,
                  "Dates",
                  categories3,
                      (newValue) {
                    setState(() {
                      selectedCategory3 = newValue!;
                    });
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

          // 🔷 Table Below Filter
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
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
                        _buildHeader("Service Beneficiary Order Type"),
                        _buildHeader("Tags Details"),
                        _buildHeader("Status"),
                        _buildHeader("Stage"),
                        _buildHeader("Payment Pending"),
                        _buildHeader("Quotation Price"),
                        _buildHeader("Manage"),
                        _buildHeader("Ref Id"),
                      ],
                    ),
                    // Sample Row
                    TableRow(
                      children: [
                        _buildCell("12-02-2025\n02:59 pm"),
                        _buildCell("Sample Customer\nxxxxxxxxx245", copyable: true),
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
        ],
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
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
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
                padding: const EdgeInsets.only(left: 32),
                child: Icon(Icons.copy, size: 16, color: Colors.grey[700]),
              ),
            ),
        ],
      ),
    );
  }
}
