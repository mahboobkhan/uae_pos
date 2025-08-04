import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

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
                  boxShadow:
                      _isHovering
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
                              onChanged:
                                  (newValue) => setState(
                                    () => selectedCategory = newValue!,
                                  ),
                              items: categories,
                            ),
                            CustomDropdown(
                              hintText: "Select Tags",
                              selectedValue: selectedCategory1,
                              onChanged:
                                  (newValue) => setState(
                                    () => selectedCategory1 = newValue!,
                                  ),
                              items: categories1,
                            ),
                            CustomDropdown(
                              hintText: "Payment Status",
                              selectedValue: selectedCategory2,
                              onChanged:
                                  (newValue) => setState(
                                    () => selectedCategory2 = newValue!,
                                  ),
                              items: categories2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 400,
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbVisibility: MaterialStateProperty.all(true),
                    thumbColor: MaterialStateProperty.all(Colors.grey),
                    thickness: MaterialStateProperty.all(8),
                    radius: const Radius.circular(4),
                  ),
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    child: Scrollbar(
                      controller: _horizontalController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: _verticalController,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 1150),
                            child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(1.5),
                                1: FlexColumnWidth(1.5),
                                2: FlexColumnWidth(1.2),
                                3: FlexColumnWidth(1),
                                4: FlexColumnWidth(1.5),
                                5: FlexColumnWidth(1.3),
                                6: FlexColumnWidth(1.5),
                                7: FlexColumnWidth(1.3),
                                8: FlexColumnWidth(1.7),
                                9: FlexColumnWidth(1.5),
                                10: FlexColumnWidth(1.4),
                              },
                              children: [
                                // Header Row
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                  ),
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
                                      color: i.isEven
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade100,
                                    ),
                                    children: [
                                      _buildCell("xxxxxxxxx325", copyable: true),
                                      _buildCell("Mr.Imran"),
                                      _buildCell("UDC BAnk"),
                                      _buildCell("XYZ"),
                                      _buildCell("ACC XXXXXXXX345"),
                                      _buildCell("xxxxxxx245"),
                                      _buildCell3("0000000000", "@gmail.com"),
                                      _buildCell3("xxxxxxx245 ", "TID xxxxxxx"),
                                      _buildCell("xxxxx"),
                                      _buildCell("N/A"),
                                      _buildPriceWithAdd("AED-", "4000",),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
                child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPriceWithAdd(String curr, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            curr,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(price,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.green),
          ),
          const Spacer(),
/*
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue),
            ),
            child: const Icon(Icons.add, size: 13, color: Colors.blue),
          ),
*/
        ],
      ),
    );
  }
  Widget _buildCell3(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text2,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
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
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

}
