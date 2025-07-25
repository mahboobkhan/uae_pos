import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../Model/SidebarItem.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/date_picker.dart';
import '../../utils/utils.dart';

class EmployeesRoleScreen extends StatefulWidget {
  const EmployeesRoleScreen({super.key});

  @override
  State<EmployeesRoleScreen> createState() => _EmployeesRoleScreenState();
}

class _EmployeesRoleScreenState extends State<EmployeesRoleScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  bool _isHovering = false;

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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 700,
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
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(2),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                    ),
                                    children: [
                                      _buildHeader("Name"),
                                      _buildHeader("Desigination"),
                                      _buildHeader("Role"),
                                      _buildHeader("Access"),
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
                                        _buildCell3(
                                          "Muhammad Imran",
                                          "xxxxxxxxxx",
                                          copyable: true,
                                        ),
                                        _buildCell1("PB-02 - 1"),
                                        _buildCell("Role"),
                                        _buildActionCell(
                                          onEdit: () {},
                                          onDelete: () {},
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

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                _showLockUnlockDialog(context);
              },
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue, // clickable style
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
  /*void showMenuLockDialog(BuildContext context, List<SidebarItem> sidebarItems) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Access'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sidebarItems.length,
            itemBuilder: (context, index) {
              final item = sidebarItems[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Menu Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Switch(
                        value: item.isLocked ?? false,
                        onChanged: (value) {
                          item.isLocked = value;
                          (context as Element).markNeedsBuild(); // Refresh dialog
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Submenus
                  ...List.generate(item.submenus.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.submenus[i]),
                          Switch(
                            value: item.submenuLocks?[i] ?? false,
                            onChanged: (value) {
                              item.submenuLocks?[i] = value;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Save logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Access updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }*/

  void _showLockUnlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Grant Access',style: TextStyle(fontWeight: FontWeight.bold),),
          content: SizedBox(
            width: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sidebarItems.length,
              itemBuilder: (context, index) {
                final item = sidebarItems[index];

                item.isLocked ??= true; // Default value
                return ExpansionTile(
                  title: Row(
                    children: [
                      Icon(item.icon, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Transform.scale(
                        scale: 0.5,
                        child: Switch(
                          value: !(item.isLocked ?? true),
                          onChanged: (val) {
                            item.isLocked = !val;
                            (context as Element).markNeedsBuild();
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.red,
                        ),
                      ),

                    ],
                  ),
                  children: List.generate(item.submenus.length, (subIndex) {
                    item.submenuLockStates ??= List.generate(item.submenus.length, (_) => true);

                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: 32, right: 8),
                      title: Text(item.submenus[subIndex], style: const TextStyle(fontSize: 13)),
                      trailing: Transform.scale(
                        scale: 0.5,
                        child: Switch(
                          value: !item.submenuLockStates![subIndex],
                          onChanged: (val) {
                            item.submenuLockStates![subIndex] = !val;
                            (context as Element).markNeedsBuild();
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.red,
                        ),
                      ),

                    );
                  }),
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Aligns buttons to the right
                children: [
                  TextButton(
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: 'Submit',
                    backgroundColor: Colors.green,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
/*
  actions: [
  Padding(
  padding: const EdgeInsets.only(right: 12.0, bottom: 8),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.end, // Aligns buttons to the right
  children: [
  TextButton(
  child: const Text(
  'Close',
  style: TextStyle(color: Colors.grey),
  ),
  onPressed: () => Navigator.of(context).pop(),
  ),
  const SizedBox(width: 8),
  CustomButton(
  text: 'Submit',
  backgroundColor: Colors.green,
  onPressed: () {},
  ),
  ],
  ),
  ),
  ],
*/


  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onDraft,
  }) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.block, size: 20, color: Colors.red),
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.check_circle, size: 20, color: Colors.green),
          onPressed: onDelete ?? () {},
        ),
      ],
    );
  }
  Widget _buildCell1(String text, {bool copyable = false}) {
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

}
