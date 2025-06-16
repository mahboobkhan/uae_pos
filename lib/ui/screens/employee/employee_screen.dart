import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: [
                  _buildDropdown(selectedCategory, "Employee Type", categories, (newValue) => setState(() => selectedCategory = newValue)),
                  _buildDropdown(selectedCategory1, "Employee List", categories1, (newValue) => setState(() => selectedCategory1 = newValue)),
                  _buildDropdown(selectedCategory2, "Payment Status", categories2, (newValue) => setState(() => selectedCategory2 = newValue)),
                  _buildDropdown(selectedCategory3, "Duration", categories3, (newValue) => setState(() => selectedCategory3 = newValue), icon: const Icon(Icons.calendar_month, size: 18)),
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
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(80),
                      1: FixedColumnWidth(120),
                      2: FixedColumnWidth(120),
                      3: FixedColumnWidth(120),
                      4: FixedColumnWidth(120),
                      5: FixedColumnWidth(120),
                      6: FixedColumnWidth(120),
                      7: FixedColumnWidth(120),
                      8: FixedColumnWidth(120),
                      9: FixedColumnWidth(120),
                    },
                    children: [
                      _buildTableHeader(),
                      _buildTableRow(),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  TableRow _buildTableRow() {
    return TableRow(
      children: [
        _buildCell("12-06-2025"),
        _buildCell("John Doe\n+123456789"),
        _buildTagsCell("Manager"),
        _buildCell("Bank Transfer/By Hand TID xxxxxxxxxx"),
        _buildCell("10000"),
        _buildCell("3,000"),
        _buildCell("5,000"),
        _buildCell("N/A"),
        _buildCell("1400"),
        _buildCell("N/A"),
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
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red), textAlign: TextAlign.center),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

  Widget _buildTagsCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

}
