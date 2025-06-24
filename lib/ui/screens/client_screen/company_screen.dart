import 'package:abc_consultant/ui/screens/client_screen/add_individual_profile.dart';
import 'package:abc_consultant/ui/screens/client_screen/add_comapny_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  List<String> _tags = ["Tag1", "Tag2"];

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;
  String? customerValue;
  String? tagValue;
  String? paymentValue;
  String? dateValue;
  String? profileAddCategory;

  final List<String> categories = [
    'Owner',
    'Employee',
  ];
  String? selectedCategory;
  final List<String> categories1 = [
    'No Tags',
    'Tag 001',
    'Tag 002',
    'Sample Tag',
  ];
  String? selectedCategory1;
  final List<String> categories2 = ['Pending', 'Paid'];
  String? selectedCategory2;
  final List<String> categories3 = ["Today", "This Week", "This Month"];
  String? selectedCategory3;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return
       Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- Stats Boxes ----
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
                                  hintText: "Individual Type",
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
                                CustomDropdown(
                                  hintText: "Dates",
                                  selectedValue: selectedCategory3,
                                  items: categories3,
                                  onChanged: (newValue) {
                                    setState(() => selectedCategory3 = newValue!);
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
                                      Icons.edit,
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
                              0: FlexColumnWidth(0.8),
                              1: FlexColumnWidth(1.5),
                              2: FlexColumnWidth(1.5),
                              3: FlexColumnWidth(1.4),
                              4: FlexColumnWidth(1),
                              5: FlexColumnWidth(1),
                              6: FlexColumnWidth(1),
                              7: FlexColumnWidth(1.5),
                              8: FlexColumnWidth(1),
                            },
                            children: [
                              // Header Row
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                ),
                                children: [
                                  _buildHeader("Client Type"),
                                  _buildHeader("Customer Name"),
                                  _buildHeader("Tag Details"),
                                  _buildHeader("Number/Email"),
                                  _buildHeader("Project Status"),
                                  _buildHeader("Payment Pending"),
                                  _buildHeader("Total Revived"),
                                  _buildHeader("Other Actions"),
                                  _buildHeader("Ref I'd"),
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
                                    _buildCell("+9727364676723",copyable: true),
                                    _buildCell("0/3 Running"),
                                    _buildCell("300"),
                                    _buildCell("7000"),
                                    _buildCell("Edit Profile -Order History"),
                                    _buildCell("xxxxx456"),
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
        ));
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




