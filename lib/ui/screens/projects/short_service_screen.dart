import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../dialogs/tags_class.dart';

class ShortServiceScreen extends StatefulWidget {
  const ShortServiceScreen({super.key});

  @override
  State<ShortServiceScreen> createState() => _ShortServiceScreenState();
}

class _ShortServiceScreenState extends State<ShortServiceScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                      //  Scrollable Row with dropdowns
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
                                icon: const Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Fixed Right Action Buttons
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
                                        showServicesProjectPopup(context);
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
                                  0: FlexColumnWidth(0.2),
                                  1: FlexColumnWidth(0.3),
                                  2: FlexColumnWidth(0.3),
                                  3: FlexColumnWidth(0.3),
                                  4: FlexColumnWidth(0.3),
                                  5: FlexColumnWidth(0.2),
                                  6: FlexColumnWidth(0.3),
                                  7: FlexColumnWidth(0.4),
                                },
                                children: [
                                  // Header Row
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                    ),
                                    children: [
                                      _buildHeader("Date"),
                                      _buildHeader("Service Beneficiary "),
                                      _buildHeader("Tags Details"),
                                      _buildHeader("Service"),
                                      _buildHeader("Pending"),
                                      _buildHeader("Manage"),
                                      _buildHeader("Ref Id"),
                                      _buildHeader("More Actions"),
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
                                        _buildCell2(
                                          "12-02-2025",
                                          "02:59 pm",
                                          centerText2: true,
                                        ),
                                        _buildCell3(
                                          "User ",
                                          "xxxxxxxxx245",
                                          copyable: true,
                                        ),
                                        TagsCellWidget(initialTags: currentTags),
                                        _buildCell("Repairing"),
                                        _buildPriceWithAdd("AED-", "300"),
                                        _buildCell("Mr. Imran"),
                                        _buildCell(
                                          "xxxxxxxxx245",
                                          copyable: true,
                                        ),
                                        _buildActionCell(
                                          onEdit: () {},
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
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
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
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
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
                          size: 14,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                ],
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
                          size: 14,
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
  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
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
      ],
    );
  }
}
