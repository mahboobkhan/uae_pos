import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BankingScreen extends StatefulWidget {
  const BankingScreen({super.key});

  @override
  State<BankingScreen> createState() => _BankingScreenState();
}

class _BankingScreenState extends State<BankingScreen> {
  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

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
                    Card(
                      elevation: 8,
                      color: Colors.blue,
                      shape: CircleBorder(),
                      child: Builder(
                        builder:
                            (context) => Tooltip(
                              message: 'Show menu',
                              waitDuration: Duration(milliseconds: 2),
                              child: GestureDetector(
                                key: _plusKey,
                                onTap: () async {
                                  final RenderBox renderBox =
                                      _plusKey.currentContext!
                                              .findRenderObject()
                                          as RenderBox;
                                  final Offset offset = renderBox.localToGlobal(
                                    Offset.zero,
                                  );

                                  final selected = await showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      offset.dx,
                                      offset.dy + renderBox.size.height,
                                      offset.dx + 30,
                                      offset.dy,
                                    ),
                                    items: [
                                      const PopupMenuItem<String>(
                                        value: 'Short Services',
                                        child: Text('Short Services'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Add Services',
                                        child: Text('Add Services'),
                                      ),
                                    ],
                                  );
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 400,
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
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(0.8),
                          2: FlexColumnWidth(0.8),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                        },
                        children: [
                          // Header Row
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                            ),
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
                          for(int i =0;i<20; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color: i.isEven
                                ? Colors.grey.shade300
                                :Colors.grey.shade50,
                            ),
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
                  ),
                ),
              ),
            ),
          ],
        ),
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


}
