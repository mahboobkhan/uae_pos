import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:abc_consultant/ui/dialogs/tags_class.dart';
import 'package:abc_consultant/ui/screens/projects/create_order_dialog.dart';
import 'package:abc_consultant/ui/screens/projects/create_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../dialogs/custom_fields.dart';
import '../../dialogs/date_picker.dart';

class ProjectScreen extends StatefulWidget {
  final VoidCallback onNavigateToCreateOrder;

  const ProjectScreen({super.key, required this.onNavigateToCreateOrder});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
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

  final List<Map<String, dynamic>> stats = [
    {'label': 'Short Services', 'value': '32'},
    {'label': 'New Projects', 'value': '32'},
    {'label': 'In Progress', 'value': '32'},
    {'label': 'Completed', 'value': '32'},
    {'label': 'Stop Project', 'value': '32'},
  ];

  final List<String> categories = [
    'All',
    'New',
    'In Progress',
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
                                blurRadius: 3,
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
                                onChanged: (newValue) async {
                                  if (newValue == 'Custom Range') {
                                    final selectedRange =
                                        await showDateRangePickerDialog(
                                          context,
                                        );

                                    if (selectedRange != null) {
                                      final start =
                                          selectedRange.startDate ??
                                          DateTime.now();
                                      final end =
                                          selectedRange.endDate ?? start;

                                      final formattedRange =
                                          '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';

                                      setState(() {
                                        selectedCategory3 = formattedRange;
                                      });
                                    }
                                  } else {
                                    setState(
                                      () => selectedCategory3 = newValue!,
                                    );
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
                                        final Offset offset = renderBox
                                            .localToGlobal(Offset.zero);

                                        final selected = await showMenu<String>(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                            offset.dx-120,
                                            offset.dy + renderBox.size.height,
                                            offset.dx ,
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
                                          setState(
                                            () => selectedCategory4 = selected,
                                          );
                                          if (selected == 'Add Services') {
                                            showShortServicesPopup(context);
                                          } else if (selected ==
                                              'Short Services') {
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
                            shape: CircleBorder(),
                            color: Colors.blue,
                            child: Tooltip(
                              message: 'Create orders',
                              waitDuration: Duration(milliseconds: 2),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CreateOrderDialog(),
                                  );
                                },
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
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 300,
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
                                  1: FlexColumnWidth(1.5),
                                  2: FlexColumnWidth(1.5),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(1.3),
                                  6: FlexColumnWidth(1),
                                  7: FlexColumnWidth(1),
                                  8: FlexColumnWidth(1),
                                  9: FlexColumnWidth(1.4),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                    ),
                                    children: [
                                      _buildHeader("Date"),
                                      _buildHeader("Service Beneficiary"),
                                      _buildHeader("Tags Details"),
                                      _buildHeader("Status"),
                                      _buildHeader("Stage"),
                                      _buildHeader("Pending"),
                                      _buildHeader("Quotation"),
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
                                                ? Colors.grey.shade200
                                                : Colors.grey.shade100,
                                      ),
                                      children: [
                                        _buildCell2(
                                          "12-02-2025",
                                          "02:59 pm",
                                          centerText2: true,
                                        ),
                                        _buildCell3(
                                          "User",
                                          "xxxxxxxxx245",
                                          copyable: true,
                                        ),
                                        TagsCellWidget(
                                          initialTags: currentTags,
                                        ),
                                        _buildCell("In progress"),
                                        _buildCell2("PB-02 - 1", "23-days"),
                                        _buildPriceWithAdd("AED-", "300"),
                                        _buildPriceWithAdd("AED-", "500"),
                                        _buildCell("Mr. Imran"),
                                        _buildCell(
                                          "xxxxxxxxx245",
                                          copyable: true,
                                        ),
                                        _buildActionCell(
                                          onEdit: () {Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => CreateOrderScreen()),
                                          );},
                                          onDelete: () {
                                            final shouldDelete =  showDialog<bool>(
                                              context: context,
                                              builder: (context) => const ConfirmationDialog(
                                                title: 'Confirm Deletion',
                                                content: 'Are you sure you want to delete this?',
                                                cancelText: 'Cancel',
                                                confirmText: 'Delete',
                                              ),
                                            );
                                            if (shouldDelete == true) {
                                              // 👇 Put your actual delete logic here
                                              print("Item deleted");
                                              // You can also call a function like:
                                              // await deleteItem();
                                            }
                                          },
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

  Widget _buildPriceWithAdd(String curr, String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            curr,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(price,style: TextStyle(fontSize: 12,color: Colors.green,fontWeight: FontWeight.bold),),
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
  Widget _buildCell2(
    String text1,
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
                    child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
                  ),
                ),
            ],
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
          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: Colors.blue,
          ),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),
      ],
    );
  }
}
