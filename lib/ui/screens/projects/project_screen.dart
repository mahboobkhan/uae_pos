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
  final List<Map<String, dynamic>> stats = [
    {'label': 'Revenue', 'value': '25K'},
    {'label': 'Users', 'value': '1.2K'},
    {'label': 'Orders', 'value': '320'},
    {'label': 'Visits', 'value': '8.5K'},
    {'label': 'Returns', 'value': '102'},
  ];

  final List<String> categories = ['All', 'New', 'Pending', 'Completed', 'Stop'];
  String? selectedCategory;

  final List<String> categories1 = ['No Tags', 'Tag 001', 'Tag 002', 'Sample Tag'];
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

  final GlobalKey _plusKey = GlobalKey(); // key for plus icon dropdown

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
                  children: stats.map((stat) {
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
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    _buildCustomDropdown(
                      selectedValue: selectedCategory,
                      hintText: "Status",
                      items: categories,
                      onChanged: (newValue) {
                        setState(() => selectedCategory = newValue!);
                      },
                    ),
                    _buildCustomDropdown(
                      selectedValue: selectedCategory1,
                      hintText: "Select Tags",
                      items: categories1,
                      onChanged: (newValue) {
                        setState(() => selectedCategory1 = newValue!);
                      },
                    ),
                    _buildCustomDropdown(
                      selectedValue: selectedCategory2,
                      hintText: "Payment Status",
                      items: categories2,
                      onChanged: (newValue) {
                        setState(() => selectedCategory2 = newValue!);
                      },
                    ),
                    _buildCustomDropdown(
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
                      builder: (context) => GestureDetector(
                        key: _plusKey,
                        onTap: () async {
                          final RenderBox renderBox = _plusKey.currentContext!.findRenderObject() as RenderBox;
                          final Offset offset = renderBox.localToGlobal(Offset.zero);

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
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: widget.onNavigateToCreateOrder,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),

              // Table
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(color: Colors.white),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(0.8),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1.3),
                    6: FlexColumnWidth(1),
                    7: FlexColumnWidth(1),
                    8: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                      children: [
                        _buildHeader("Date"),
                        _buildHeader("Service Beneficiary Order Type"),
                        _buildHeader("Tags Details"),
                        _buildHeader("Status"),
                        _buildHeader("Stage"),
                        _buildHeader("Payment Pending"),
                        _buildHeader("Quotation Price"),
                        _buildHeader("Manage"),
                        _buildHeader("Ref Id"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildCell("12-02-2025\n02:59 pm"),
                        _buildCell("Sample Customer\nxxxxxxxxx245", copyable: true),
                        _buildTagsCell(["Sample Tags", "Sample", "Tages123"]),
                        _buildCell("In progress"),
                        _buildCell("PB-02 - 23days"),
                        _buildPriceWithAdd("300"),
                        _buildCell("500"),
                        _buildCell("Mr. Imran"),
                        _buildCell("xxxxxxxxx245", copyable: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String? selectedValue,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    Icon? icon,
  }) {
    final GlobalKey _key = GlobalKey();

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: GestureDetector(
        onTap: () async {
          final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
          final Offset offset = renderBox.localToGlobal(Offset.zero);
          final double width = renderBox.size.width;

          final selected = await showMenu<String>(
            context: _key.currentContext!,
            position: RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + renderBox.size.height,
              offset.dx + width,
              offset.dy,
            ),
            items: items.map((item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
          );

          if (selected != null) {
            onChanged(selected);
          }
        },
        child: Container(
          key: _key,
          width: 140,
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedValue ?? hintText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: selectedValue == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              icon ?? const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
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
              style: const TextStyle(fontSize: 14),
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
                padding: const EdgeInsets.only(left: 32),
                child: Icon(Icons.copy, size: 16, color: Colors.grey[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagsCell(List<String> tags) {
    final colors = [Colors.purple, Colors.green, Colors.blue];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Wrap(
        spacing: 4,
        children: [
          for (int i = 0; i < tags.length; i++)
            Text(
              tags[i],
              style: TextStyle(
                color: colors[i % colors.length],
                fontWeight: FontWeight.w600,
              ),
            ),
          const Icon(Icons.add, size: 16, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildPriceWithAdd(String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(price),
          const Spacer(),
          const Icon(Icons.add, size: 16, color: Colors.red),
        ],
      ),
    );
  }
}
