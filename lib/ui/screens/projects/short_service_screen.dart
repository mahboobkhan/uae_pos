import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';

class ShortServiceScreen extends StatefulWidget {
  const ShortServiceScreen({super.key});

  @override
  State<ShortServiceScreen> createState() => _ShortServiceScreenState();
}

class _ShortServiceScreenState extends State<ShortServiceScreen> {
  List<String> _tags = ["Tag1", "Tag2"];

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
  final GlobalKey _plusKey = GlobalKey();

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
                  // 🔽 Scrollable Row with dropdowns
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                        ],
                      ),
                    ),
                  ),

                  // 🔽 Fixed Right Action Buttons
                  Row(
                    children: [
                      Card(
                        elevation: 8,
                        color: Colors.blue,
                        shape:  CircleBorder(),
                        child: Builder(
                          builder: (context) => Tooltip(
                            message: 'Show menu',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              key: _plusKey,
                              onTap: () async {
                                final RenderBox renderBox =
                                _plusKey.currentContext!.findRenderObject() as RenderBox;
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
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.add, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 365,
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
                        0: FlexColumnWidth(0.3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(0.8),
                        3: FlexColumnWidth(0.8),
                        4: FlexColumnWidth(0.8),
                        5: FlexColumnWidth(0.8),
                      },
                      children: [
                        // Header Row
                        TableRow(
                          decoration:  BoxDecoration(
                          color: Colors.red.shade50,
                          ),
                          children: [
                            _buildHeader("Date"),
                            _buildHeader("Service Beneficiary "),
                            _buildHeader("Tags Details"),
                            _buildHeader("Pending"),
                            _buildHeader("Manage"),
                            _buildHeader("Ref Id"),
                          ],
                        ),
                        // Sample Row
                        for (int i = 0; i < 20; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color:
                              i.isEven
                                  ? Colors.grey.shade100
                                  : Colors.grey.shade50,
                            ),
                          children: [
                            _buildCell2("12-02-2025", "02:59 pm",centerText2: true),
                            _buildCell3(
                              "Sample Customer ","xxxxxxxxx245",
                              copyable: true,
                            ),
                            _buildTagsCell(_tags, context),
                            _buildPriceWithAdd("AED-","300"),
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
      height: 40,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
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
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildCell2(String text1, String text2, {bool copyable = false, bool centerText2 = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: const TextStyle(fontSize: 12),
          ),
          centerText2
              ? Center(
            child: Row(
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
                      child: Icon(Icons.copy, size: 14, color: Colors.blue[700]),
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
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
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
                    child: Icon(Icons.copy, size: 14, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
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
          Text(
            text1,
            style: const TextStyle(fontSize: 12),
          ),
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
                    child: Icon(Icons.copy, size: 14, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildTagsCell(List<String> tags, BuildContext context) {
    final backgroundColors = [
      Colors.green.shade100,
      Colors.yellow.shade100,
      Colors.orange.shade100,
      Colors.pink.shade100,
      Colors.purple.shade100,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.blue.shade100,
      Colors.lightGreen.shade200,
      Colors.pink.shade200,
      Colors.grey.shade300,
      Colors.lightBlue,
      Colors.cyan,
      Colors.lime,
      Colors.pink,
      Colors.blueGrey,
    ];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (int i = 0; i < tags.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: backgroundColors[i % backgroundColors.length],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tags[i],
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await showAddTagDialog(context);
              if (result != null && result['tag'].toString().trim().isNotEmpty) {
                setState(() {
                  _tags.add(result['tag']);
                });
              }
            },
            child: Image.asset(
              width: 18,
              height: 18,
              color: Colors.blue,
              'assets/icons/img_1.png', // Your image path
            ),
          ),
        ],
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
          Text(price),
          const Spacer(),
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
