import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
  final GlobalKey _plusKey = GlobalKey();
  final List<String> categories = [
    'All',
    'Full time job',
    'half time job',
    'Old employee',
  ];
  final List<String> categories1 = [
    'All',
    'Name 1 - Manager',
    'Name 1 - Manager',
    'Name 1 - Manager',
  ];
  final List<String> categories2 = ['All', 'paid', 'Pending'];
  final List<String> categories3 = [
    'All',
    'This Month',
    'Last Month',
    'Select on Calender',
  ];

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
                                offset: Offset(0, 1),
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
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Card(
                            elevation: 8,
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            child: Builder(
                              builder:
                                  (context) => Tooltip(
                                    message: 'Show menu',
                                    waitDuration: const Duration(
                                      milliseconds: 2,
                                    ),
                                    child: GestureDetector(
                                      key: _plusKey,
                                      onTap: () async {
                                        final RenderBox renderBox =
                                            _plusKey.currentContext!
                                                    .findRenderObject()
                                                as RenderBox;
                                        final Offset offset = renderBox
                                            .localToGlobal(Offset.zero);

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
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              constraints: const BoxConstraints(minWidth: 1200),
                              child: Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(0.8),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1.5),
                                  4: FlexColumnWidth(1.3),
                                  5: FlexColumnWidth(1.3),
                                  6: FlexColumnWidth(1.3),
                                  7: FlexColumnWidth(1),
                                  8: FlexColumnWidth(1),
                                  9: FlexColumnWidth(1.5),
                                },
                                children: [
                                  // Header Row
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                    ),
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
                                      decoration: BoxDecoration(
                                        color: i.isEven
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade100,
                                      ),
                                      children: [
                                        _buildCell2("12-02-2025", "02:59 pm", centerText2: true),
                                        _buildCell3("Sample Customer ", "xxxxxxxxx245", copyable: true),
                                        _buildCell("Manager"),
                                        _buildCell3("Bank Transfer", "TID xxxxxxx234", copyable: true),
                                        _buildPriceWithAdd("AED-", "100000"),
                                        _buildPriceWithAdd("AED-", "300", showPlus: true),
                                        _buildPriceWithAdd("AED-", "2000", showPlus: true),
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
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
                    child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildCell2(String text1,
      String text2, {
        bool copyable = false,
        bool centerText2 = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: const TextStyle(fontSize: 12)),
          centerText2
              ? Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
                if (copyable)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: "$text1\n$text2"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.copy,
                        size: 14,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
              ],
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  text2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: "$text1\n$text2"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.copy,
                      size: 8,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
            ],
          ),
        ],
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
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildPriceWithAdd(String curr, String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            curr,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(price,style: TextStyle(fontSize: 12),),
          const Spacer(),
          if (showPlus)
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              ),
              child: const Icon(Icons.add, size: 13, color: Colors.blue),
            ),
        ],
      ),
    );
  }

}
