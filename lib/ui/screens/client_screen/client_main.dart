import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';

class ClientMain extends StatefulWidget {
  const ClientMain({super.key});

  @override
  State<ClientMain> createState() => _ClientMainState();
}

class _ClientMainState extends State<ClientMain> {
  List<String> _tags = ["Tag1", "Tag2"];

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;
  String? customerValue;
  String? tagValue;
  String? paymentValue;
  String? dateValue;
  String? profileAddCategory;

  final List<String> categories = [
    'Company',
    'Individual',
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
  final List<String> categories4 = ['Individual', 'Company'];
  String selectedCategory4 = '';


  final List<String> categories3 = [
    'All',
    'Toady',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];
  String? selectedCategory3;

  final List<Map<String, dynamic>> stats = [
    {'label': 'Clients', 'value': '220'},
    {'label': 'Pending Projects', 'value': '4'},
    {'label': 'In Progress', 'value': '5'},
    {'label': 'Delivered', 'value': '150'},
    {'label': 'Complaints', 'value': '5'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return  Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- Stats Boxes ----
                SizedBox(
                  height: 120,
                  child: Row(
                    children:
                        stats.map((stat) {
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

                const SizedBox(height: 20),

                /// ---- Filters Row ----
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
                                  hintText: "Client Type",
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
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    size: 18,
                                  ),
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
                              shape:  CircleBorder(),
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
                                        items: [
                                          const PopupMenuItem<String>(
                                            value: 'Company',
                                            child: Text('Company'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'Individual',
                                            child: Text('Individual'),
                                          ),
                                        ],
                                      );

                                      if (selected != null) {
                                        setState(() => selectedCategory4 = selected);

                                        if (selected == 'Company') {
                                          showCompanyDialog(context);
                                        } else if (selected == 'Individual') {
                                          showIndividualProfileDialog(context);
                                        }
                                      }

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
                            Material(
                              elevation: 8,
                              shadowColor: Colors.grey.shade900,
                              shape:  CircleBorder(),
                              color: Colors.blue,
                              child: Tooltip(
                                message: 'Create orders',
                                waitDuration: Duration(milliseconds: 2),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: const Center(
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// ---- Table Data ----
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
                                  _buildHeader("Client Type"),
                                  _buildHeader("Customer Ref I'd"),
                                  _buildHeader("Tag Details"),
                                  _buildHeader("Number/Email"),
                                  _buildHeader("Project Status"),
                                  _buildHeader("Payment Pending"),
                                  _buildHeader("Total Revived"),
                                  _buildHeader("Other Actions"),
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
                                    _buildCell("Company"),
                                    _buildCell("Sample Customer \nxxxxxx345",copyable: true),
                                    _buildTagsCell(_tags, context),
                                    _buildCell("+9727364676723"),
                                    _buildCell("0/3 Running"),
                                    _buildCell("300"),
                                    _buildCell("900"),
                                    _buildCell("Edit Profile - order Type"),
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
        ),
      );

  }
  Widget _buildTagsCell(List<String> tags, BuildContext context) {
    final colors = [Colors.purple, Colors.green, Colors.blue];

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
                  Text(
                    tags[i],
                    style: TextStyle(
                      color: colors[i % colors.length],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await showAddTagDialog(context);
              if (result != null) {
                setState(() {
                  _tags.add(result['tag']); // Add new tag to list
                });
              }
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              ),
              child: const Icon(Icons.add, size: 14, color: Colors.blue),
            ),
          ),
        ],
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

Widget _buildHeader(String text) {
  return Container(
    height: 50, // 👈 Set your desired header height here
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
        fontSize: 12,
      ),
      textAlign: TextAlign.start,
    ),
  );
}


Widget _buildPriceWithAdd(String price) {
  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
    margin: const EdgeInsets.only(right: 8.0), // match column spacing
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // space between text and icon
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(price, style: const TextStyle(fontSize: 13, color: Colors.black)),
        const Icon(Icons.add, size: 16, color: Colors.red),
      ],
    ),
  );
}

