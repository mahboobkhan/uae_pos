import 'package:abc_consultant/ui/screens/client_screen/add_individual_profile.dart';
import 'package:abc_consultant/ui/screens/client_screen/add_comapny_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/date_picker.dart';
import '../../dialogs/tags_class.dart';

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({super.key});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
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

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];
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
                                  onChanged: (newValue) async {
                                    if (newValue == 'Custom Range') {
                                      final selectedRange = await showDateRangePickerDialog(
                                          context);

                                      if (selectedRange != null) {
                                        final start = selectedRange.startDate ??
                                            DateTime.now();
                                        final end = selectedRange.endDate ??
                                            start;

                                        final formattedRange = '${DateFormat(
                                            'dd/MM/yyyy').format(
                                            start)} - ${DateFormat('dd/MM/yyyy')
                                            .format(end)}';

                                        setState(() {
                                          selectedCategory3 = formattedRange;
                                        });
                                      }
                                    } else {
                                      setState(() =>
                                      selectedCategory3 = newValue!);
                                    }
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
                                          color: i.isEven
                                              ? Colors.grey.shade200
                                              : Colors.grey.shade100,
                                        ),
                                        children: [
                                          _buildCell2("12-02-2025", "02:59 pm", centerText2: true),
                                          _buildCell3("User ", "xxxxxxxxx245", copyable: true),
                                          TagsCellWidget(initialTags: currentTags),
                                          _buildCell("In progress"),
                                          _buildCell2("PB-02 - 1 ", ' 23-days'),
                                          _buildCell("Pending"),
                                          _buildCell("M.Imran"),
                                          _buildCell("xxxxxx566 ", copyable: true),
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

  Widget _buildTagsCell(List<Map<String, dynamic>> tags, BuildContext context) {
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
                  _HoverableTag(
                    tag: tags[i]['tag'],
                    color: tags[i]['color'] ?? Colors.grey.shade200,
                    onDelete: () {
                      // You must call setState from the parent
                      (context as Element)
                          .markNeedsBuild(); // temporary refresh
                      tags.removeAt(i);
                    },
                  ),
              ],
            ),
          ),
          Tooltip(
            message: 'Add Tag',
            child: GestureDetector(
              onTap: () async {
                final result = await showAddTagDialog(context);
                if (result != null && result['tag']
                    .toString()
                    .trim()
                    .isNotEmpty) {
                  (context as Element).markNeedsBuild();
                  tags.add({
                    'tag': result['tag'],
                    'color': result['color'],
                  });
                }
              },
              child: Image.asset(
                width: 14,
                height: 14,
                color: Colors.blue,
                'assets/icons/img_1.png',
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

}
class _HoverableTag extends StatefulWidget {
  final String tag;
  final Color color;
  final VoidCallback onDelete;

  const _HoverableTag({
    Key? key,
    required this.tag,
    required this.color,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<_HoverableTag> createState() => _HoverableTagState();
}

class _HoverableTagState extends State<_HoverableTag> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(top: 6, right: 2),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.tag,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          if (_hovering)
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
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