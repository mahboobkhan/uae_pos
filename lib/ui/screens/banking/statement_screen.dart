import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;
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
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: _isHovering
                      ? [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 4,
                      spreadRadius: 0.1,
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
                              hintText: "Status",
                              selectedValue: selectedCategory,
                              onChanged: (newValue) =>
                                  setState(() => selectedCategory = newValue!),
                              items: categories,
                            ),
                            CustomDropdown(
                              hintText: "Select Tags",
                              selectedValue: selectedCategory1,
                              onChanged: (newValue) =>
                                  setState(() => selectedCategory1 = newValue!),
                              items: categories,
                            ),
                            CustomDropdown(
                              hintText: "Payment Status",
                              selectedValue: selectedCategory2,
                              onChanged: (newValue) =>
                                  setState(() => selectedCategory2 = newValue!),
                              items: categories,
                            ),
                            const SizedBox(width: 12),
                            /// Search Box
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
                              elevation: 6,
                              shape: const CircleBorder(),
                              color: Colors.red,
                              child: const SizedBox(
                                height: 30,
                                width: 30,
                                child: Icon(Icons.search, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        /// Plus Button with Menu
                        Card(
                          elevation: 8,
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          child: Builder(
                            builder: (context) => Tooltip(
                              message: 'Show menu',
                              waitDuration: const Duration(milliseconds: 2),
                              child: GestureDetector(
                                key: _plusKey,
                                onTap: () async {
                                  final RenderBox renderBox =
                                  _plusKey.currentContext!.findRenderObject()
                                  as RenderBox;
                                  final Offset offset =
                                  renderBox.localToGlobal(Offset.zero);

                                  final selected = await showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      offset.dx,
                                      offset.dy + renderBox.size.height,
                                      offset.dx + 30,
                                      offset.dy,
                                    ),
                                    items: const [
                                      PopupMenuItem<String>(
                                        value: 'Short Services',
                                        child: Text('Short Services'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Add Services',
                                        child: Text('Add Services'),
                                      ),
                                    ],
                                  );
                                },
                                child: const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Icon(Icons.add, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 1150, // Force horizontal scrolling
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,

                      child: Table(
                        border: TableBorder.all(
                          color: Colors.white,
                          width: 2,
                        ),                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(1.4),
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(1.2),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1.5),
                          5: FlexColumnWidth(1.3),
                          6: FlexColumnWidth(1.5),
                          7: FlexColumnWidth(1.3),
                          8: FlexColumnWidth(1.7),
                          9: FlexColumnWidth(1.5),
                          10: FlexColumnWidth(1.2),
                        },
                        children: [
                          // Header Row
                          TableRow(
                            decoration:  BoxDecoration(color: Colors.red.shade50),
                            children: [
                              _buildHeader("Bank Id"),
                              _buildHeader("Banificery Name"),
                              _buildHeader("Bank Name"),
                              _buildHeader("Title Name"),
                              _buildHeader("Account Name"),
                              _buildHeader("Account IBN"),
                              _buildHeader("Mobile/Email"),
                              _buildHeader("Ref I,d/TID"),
                              _buildHeader("Transaction Type "),
                              _buildHeader("Note"),
                              _buildHeader("Cash Value"),
                            ],
                          ),
                          // Sample Data Row
                          for (int i = 0; i < 20; i++)
                            TableRow(
                              decoration: BoxDecoration(
                                color:
                                i.isEven
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade50,
                              ),
                            children: [
                              _buildCell("xxxxxxxxxxxx325"),
                              _buildCell("Imran"),
                              _buildCell("UDC BAnk"),
                              _buildCell("XYZ"),
                              _buildCell("ACC XXXXXXXX345"),
                              _buildCell("xxxxxxx245"),
                              _buildCell("NIL"),
                              _buildCell("xxxxxxx245 "),
                              _buildCell("xxxxx"),
                              _buildCell("N/A"),
                              _buildCell("4000"),
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
  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(fontSize: 14)),
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
}
