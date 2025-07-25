import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../dialogs/company_profile.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/date_picker.dart';
import '../../dialogs/individual_profile.dart';
import '../../dialogs/tags_class.dart';

class ClientMain extends StatefulWidget {
  const ClientMain({super.key});

  @override
  State<ClientMain> createState() => _ClientMainState();
}

class _ClientMainState extends State<ClientMain> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];
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
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      stat['value'],
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      stat['label'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
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

                const SizedBox(height: 10),

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

                                          showCompanyProfileDialog(context);

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
                                  defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FlexColumnWidth(0.8),
                                    1: FlexColumnWidth(0.8),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(1),
                                    5: FlexColumnWidth(1),
                                    6: FlexColumnWidth(0.7),
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
                                          color:
                                          i.isEven
                                              ? Colors.grey.shade200
                                              : Colors.grey.shade100,
                                        ),
                                        children: [
                                          _buildCell("Company"),
                                          _buildCell3("Sample Customer" ,"nxxxxxx345",copyable: true),
                                          TagsCellWidget(initialTags: currentTags),
                                          _buildCell("+9727364676723"),
                                          _buildCell("0/3 Running"),
                                          _buildPriceWithAdd("AED-","300"),
                                          _buildPriceWithAdd("AED-","900"),
                                          _buildActionCell(   onEdit: () {},
                                            onDelete: () {},
                                           // onDraft: () {}
                                            ),
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
                ),
              ],
            ),
          ),
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
  Widget _buildCell3(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8),
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
  Widget _buildPriceWithAdd(String curr, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue),
            ),
            child: const Icon(Icons.add, size: 13, color: Colors.blue),
          ),
          SizedBox(width: 6),
          Text(
            curr,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(price),
        ],
      ),
    );
  }
  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),
        /*IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: Colors.red,
          ),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),*/
      ],
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




