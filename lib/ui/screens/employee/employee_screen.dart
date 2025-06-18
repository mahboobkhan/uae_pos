import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    _buildDropdown(selectedCategory, "Employee Type", categories, (newValue) => setState(() => selectedCategory = newValue)),
                    _buildDropdown(selectedCategory1, "Select Tags", categories1, (newValue) => setState(() => selectedCategory1 = newValue)),
                    _buildDropdown(selectedCategory2, "Payment Status", categories2, (newValue) => setState(() => selectedCategory2 = newValue)),
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
              Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16),
                child: Table(
                  border: TableBorder.all(color: Colors.white),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(0.5),
                    5: FlexColumnWidth(0.5),
                    6: FlexColumnWidth(0.5),
                    7: FlexColumnWidth(1),
                    8: FlexColumnWidth(1),
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                      children: [
                        _buildHeader("Employee Type"),
                        _buildHeader("Employee Name Ref I'd"),
                        _buildHeader("Tags Details"),
                        _buildHeader("Contact Number /Email"),
                        _buildHeader("Salary"),
                        _buildHeader("Advance"),
                        _buildHeader("Bonuses"),
                        _buildHeader("Other Actions"),
                      ],
                    ),
                    // Sample Data Row
                    TableRow(
                      children: [
                        _buildCell("12-02-2025\nHalf Time"),
                        _buildCell(
                          "Sample Employee\nxxxxxxxxx245",
                          copyable: true,
                        ),
                        _buildCell("Sample Tags"),
                        _buildCell("+32182666134"),
                        _buildCell("10000"),
                        _buildCell("300"),
                        _buildCell("100"),
                        _buildCell("Profile Bank Account"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
      children: [
        _buildHeader("Date"),
        _buildHeader("Employee Name\nReference id"),
        _buildHeader("Job Positions"),
        _buildHeader("Payment Mode"),
        _buildHeader("Salary"),
        _buildHeader("Advance"),
        _buildHeader("Bonuses"),
        _buildHeader("Pending"),
        _buildHeader("Total ID"),
        _buildHeader("Other"),
      ],
    );
  }

  Widget _buildDropdown(String? selectedValue, String hint, List<String> items, ValueChanged<String?> onChanged, {Icon icon = const Icon(Icons.arrow_drop_down)}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 140,
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            icon: icon,
            hint: Text(hint),
            style: const TextStyle(fontSize: 10),
            onChanged: onChanged,
            items: items.map((value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
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
                padding: const EdgeInsets.only(left: 32),
                child: Icon(Icons.copy, size: 16, color: Colors.grey[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagsCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

}
