import 'package:flutter/material.dart';

class BankingScreen extends StatefulWidget {
  const BankingScreen({super.key});

  @override
  State<BankingScreen> createState() => _BankingScreenState();
}

class _BankingScreenState extends State<BankingScreen> {
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
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
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
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showAddPaymentDialog(context);
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(color: Colors.white),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                  6: FlexColumnWidth(1),
                },
                children: [
                  // Header Row
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                    children: [
                      _buildHeader("Bank Id"),
                      _buildHeader("Bank Name"),
                      _buildHeader("Title Name"),
                      _buildHeader("Account/IBN"),
                      _buildHeader("Mobile/Email"),
                      _buildHeader("Ref I'd"),
                      _buildHeader("Action"),
                    ],
                  ),
                  // Sample Data Row
                  TableRow(
                    children: [
                      _buildCell("xxxxx"),
                      _buildCell("UDC Bank"),
                      _buildCell('xxxxxx'),
                      _buildCell("ACC xxxxxxxx345\nIBN xxxxxxx345"),
                      _buildCell("0626626626"),
                      _buildCell("xxxxxx345"),
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
        style: const TextStyle( color: Colors.red),
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

  void _showAddPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width: 1000,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // Light grey background
            border: Border.all(color: Colors.red, width: 2), // Red border
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                children: const [
                  Text(
                    "Add Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "BID. 00001",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _buildInput("Select Platform", hint: "Bank/Violet/Other Platform"),
                  _buildInput("Platform/Bank Name/Cash As Hand"),
                  _buildInput("Title Name"),
                  _buildInput("Account No"),
                  _buildInput("IBN"),
                  _buildInput("Email I'd"),
                  _buildInput("Mobile Number"),
                  _buildInput("Tag Add"),
                  _buildInput("Bank Address Physical Address",
                      hint: "Address, Town, City, Postal Code, Country"),
                ],
              ),
              const SizedBox(height: 20),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text("Editing", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text("Submit", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, {String? hint}) {
    return SizedBox(
      width: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.red)),
          const SizedBox(height: 4),
          TextField(
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: hint ?? '',
              hintStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
