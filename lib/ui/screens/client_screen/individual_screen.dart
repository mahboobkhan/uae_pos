import 'package:abc_consultant/ui/screens/client_screen/add_individual_profile.dart';
import 'package:abc_consultant/ui/screens/client_screen/add_comapny_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({super.key});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  List<String> _tags = ["Tag1", "Tag2"];

  String? customerValue;
  String? tagValue;
  String? paymentValue;
  String? dateValue;
  String? profileAddCategory;
  final List<String> categories = [
    'Individual',
    'Assistant',
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
                                  hintText: "Individual Type",
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
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    height: 400,
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
                            ),
                            defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                            columnWidths: const {
                              0: FlexColumnWidth(0.8),
                              1: FlexColumnWidth(1.5),
                              2: FlexColumnWidth(1.5),
                              3: FlexColumnWidth(1),
                              4: FlexColumnWidth(1),
                              5: FlexColumnWidth(1.3),
                              6: FlexColumnWidth(1),
                              7: FlexColumnWidth(1),

                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                ),
                                children: [
                                  _buildHeader("Date"),
                                  _buildHeader("Service Beneficiary "),
                                  _buildHeader("Tags Details"),
                                  _buildHeader("Status"),
                                  _buildHeader("Stage"),
                                  _buildHeader("Payment Pending"),
                                  _buildHeader("Manage "),
                                  _buildHeader("Ref Id"),
                                ],
                              ),
                              for (int i = 0; i < 20; i++)
                                TableRow(
                                  decoration: BoxDecoration(
                                    color:
                                    i.isEven
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade50,
                                  ),
                                  children: [
                                    _buildCell2("12-02-2025", "02:59 pm"),
                                    _buildCell(
                                      "Sample Customer \nxxxxxxxxx245",
                                      copyable: true,
                                    ),
                                    _buildTagsCell(_tags, context),
                                    _buildCell("In progress"),
                                    _buildCell2("PB-02 - 1 ", ' 23-days'),
                                    _buildCell("Pending"),
                                    _buildCell("M.Imran"),
                                    _buildCell("xxxxxx566 ",copyable: true),

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
  Widget _buildCell2(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1, style: const TextStyle(fontSize: 12)),
                Text(
                  text2,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
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
                padding: const EdgeInsets.only(left: 6),
                child: Icon(Icons.copy, size: 16, color: Colors.blue[700]),
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


 // /// ---- Profile Add Menu ----
                      // PopupMenuButton<String>(
                      //   onSelected: (String newValue) {
                      //     setState(() {
                      //       profileAddCategory = newValue;
                      //     });
                      //     if (newValue == 'Company') {
                      //       showAddCompanyProfileDialogue(context);
                      //     } else {
                      //       showAddIndividualProfileDialogue(context);
                      //     }
                      //   },
                      //   itemBuilder:
                      //       (BuildContext context) => <PopupMenuEntry<String>>[
                      //         const PopupMenuItem<String>(
                      //           value: 'Company',
                      //           child: Text('Add Company Profile'),
                      //         ),
                      //         const PopupMenuItem<String>(
                      //           value: 'Individual',
                      //           child: Text('Add Individual'),
                      //         ),
                      //       ],
                      //   child: Container(
                      //     width: 35,
                      //     height: 35,
                      //     margin: const EdgeInsets.symmetric(horizontal: 10),
                      //     decoration: const BoxDecoration(
                      //       color: Colors.red,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: const Center(
                      //       child: Icon(
                      //         Icons.add,
                      //         color: Colors.white,
                      //         size: 20,
                      //       ),
                      //     ),
                      //   ),
                      // ),