import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectScreen extends StatefulWidget {
  final VoidCallback onNavigateToCreateOrder;


  const ProjectScreen({super.key, required this.onNavigateToCreateOrder});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();

}

class _ProjectScreenState extends State<ProjectScreen> {
  List<String> _tags = ["Tag1", "Tag2"];

  final List<Map<String, dynamic>> stats = [
    {'label': 'Revenue', 'value': '25K'},
    {'label': 'Users', 'value': '1.2K'},
    {'label': 'Orders', 'value': '320'},
    {'label': 'Visits', 'value': '8.5K'},
    {'label': 'Returns', 'value': '102'},
  ];

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

  final List<String> categories4 = ['Services Project', 'Short Services'];
  String selectedCategory4 = '';

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 10),
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
                      const Spacer(),

                      // Plus Icon behaving like a dropdown
                      Builder(
                        builder:
                            (context) => Tooltip(
                              message: 'Show menu',
                              waitDuration: Duration(milliseconds: 2),
                              child: GestureDetector(
                                key: _plusKey,
                                onTap: () async {
                                  final RenderBox renderBox =
                                      _plusKey.currentContext!.findRenderObject()
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
                              
                                  if (selected != null) {
                                    setState(() => selectedCategory4 = selected);
                                    if (selected == 'Add Services') {
                                      showShortServicesPopup(context);
                                    } else if (selected == 'Short Services') {
                                      showServicesProjectPopup(context);
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
                                    color: Colors.blue,
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
                      Tooltip(
                        message: 'Create orders',
                        waitDuration: Duration(milliseconds: 2),
                        child: GestureDetector(
                          onTap: widget.onNavigateToCreateOrder,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
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
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
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
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1.2),
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
                                _buildHeader("Quotation "),
                                _buildHeader("Manage"),
                                _buildHeader("Ref Id"),
                                _buildHeader("More Actions"),
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
                                  _buildTagsCell(_tags,context),
                                  _buildCell("In progress"),
                                  _buildCell2("PB-02 - 1 ", ' 23-days'),
                                  _buildPriceWithAdd("AED-", "300"),
                                  _buildCell("500"),
                                  _buildCell("Mr. Imran"),
                                  _buildCell("xxxxxxxxx245", copyable: true),
                                  _buildActionCell(
                                    onEdit: () {},
                                    onDelete: () {},
                                    onDraft: () {},
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
            ],
          ),
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

  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onDraft,
  }) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.drafts, size: 18, color: Colors.orange),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),
      ],
    );
  }
}
