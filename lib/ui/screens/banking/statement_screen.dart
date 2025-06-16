import 'package:flutter/material.dart';
class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final List<Map<String, dynamic>> stats = [
    {'label': 'BANK TRX', 'value': '32'},
    {'label': 'CASH IN', 'value': '32'},
    {'label': 'CASH OUT', 'value': '32'},
    {'label': 'CASH VIA BANK', 'value': '32'},
    {'label': 'OTHERS RESOURCE', 'value': '32'},
  ];

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: Row(
                children: stats.map((stat) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
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
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(12),
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
                      const SizedBox(width: 12),
                      Row(
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
                      const Spacer(),
                      Container(
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
                    ],
                  ),
                ),

                // bank  transaction wala sections
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset:  Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bank Transactions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Text(
                        "TID. 00001-2000000201",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildInput("Select Bank/Platform", hint: "Bank/Violet/Other Platform"),
                          _buildInput("Cash In/Out"),
                          _buildInputField("Amount Type here"),
                          _buildInput("Payment By Auto/Edit "),
                          _buildInput("Received by Auto"),
                          _buildInput("Services TId"),
                          _buildInput("Note "),
                                                 ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade900,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            child: const Text("Editing", style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            child: const Text("Submit", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                  7: FlexColumnWidth(1),
                  8: FlexColumnWidth(1),
                  9: FlexColumnWidth(1),
                  10: FlexColumnWidth(1),
                },
                children: [
                  // Header Row
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                    children: [
                      _buildHeader("Bank Id"),
                      _buildHeader("Banificery Name"),
                      _buildHeader("BAnk Name"),
                      _buildHeader("Title Name"),
                      _buildHeader("Account Name"),
                      _buildHeader("Account IBN"),
                      _buildHeader("Mobile/Email"),
                      _buildHeader("Ref I,d/TID"),
                      _buildHeader("Transaction Type "),
                      _buildHeader("Note"),
                      _buildHeader("Cash Value")

                    ],
                  ),
                  // Sample Data Row
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.white),
                    children: [
                      _buildCell("12-02-2025\n02:59 pm"),
                      _buildCell(""),
                      _buildCell("UDC BAnk"),
                      _buildCell("XYZ"),
                      _buildCell("ACC XXXXXXXX345"),
                      _buildCell("@gmail.com"),
                      _buildCell("xxxxxx76"),
                      _buildCell("Cash In"),
                      _buildCell("xxxxxxxxx245"),
                      _buildCell("50000"),
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
  static Widget _buildInput(String label, {String? hint}) {
    return SizedBox(
      width: 210,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
  static Widget _buildInputField(String label, {String? hint}) {
    return SizedBox(
      width: 210,
        child: TextField(
          keyboardType: TextInputType.number, // 🔢 Numeric keypad show karega
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            labelText: label,
            labelStyle: const TextStyle(color: Colors.red),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black54),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        )
    );
  }
  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(fontSize: 14)),
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
}
