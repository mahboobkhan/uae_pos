import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:abc_consultant/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<Map<String, dynamic>> stats = [
    {'label': 'Revenue', 'value': '25K'},
    {'label': 'Users', 'value': '1.2K'},
    {'label': 'Orders', 'value': '320'},
    {'label': 'Visits', 'value': '8.5K'},
    {'label': 'Returns', 'value': '102'},
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
  final List<String> categories4 = ['Services Project', 'Short Services'];
  String selectedCategory4 = '';

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
              SizedBox(height: 20),
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
                    // Dropdowns
                    _buildDropdown(selectedCategory, "Status", categories, (
                      newValue,
                    ) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    }),

                    _buildDropdown(
                      selectedCategory1,
                      "Select Tags",
                      categories1,
                      (newValue) {
                        setState(() {
                          selectedCategory1 = newValue!;
                        });
                      },
                    ),
                    _buildDropdown(
                      selectedCategory2,
                      "Payment Status",
                      categories2,
                      (newValue) {
                        setState(() {
                          selectedCategory2 = newValue!;
                        });
                      },
                    ),
                    _buildDropdown(
                      selectedCategory3,
                      "Dates",
                      categories3,
                      (newValue) {
                        setState(() {
                          selectedCategory3 = newValue!;
                        });
                      },
                      icon: const Icon(Icons.calendar_month, size: 18),
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      onSelected: (String newValue) {
                        setState(() {
                          selectedCategory4 = newValue;
                        });
                        if (newValue == 'Short Services') {
                          showShortServicesPopup(context);
                        } else if (newValue == 'Add Services') {
                          showServicesProjectPopup(context);
                        }
                      },

                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Short Services',
                              child: Text('Short Services'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Add Services',
                              child: Text('Add Services'),
                            ),
                          ],
                      child: Container(
                        width: 35,
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    Icon(Icons.edit_outlined, color: Colors.green),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(color: Colors.white),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                    6: FlexColumnWidth(1),
                    7: FlexColumnWidth(1),
                    8: FlexColumnWidth(1),
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                      children: [
                        _buildHeader("Bank Id"),
                        _buildHeader("Bank Name"),
                        _buildHeader("Title Name"),
                        _buildHeader("Account/IBN"),
                        _buildHeader("Mobile/Email"),
                        _buildHeader("Ref I'd"),
                        _buildHeader("Action"),
                        _buildHeader("Manage"),
                        _buildHeader("Ref Id"),
                      ],
                    ),
                    // Sample Data Row
                    TableRow(
                      children: [
                        _buildCell("12-02-2025\n02:59 pm"),
                        _buildCell("Sample Customer\nxxxxxxxxx245"),
                        _buildTagsCell(["Sample Tags", "Sample", "Tages123"]),
                        _buildCell("In progress"),
                        _buildCell("PB-02 - 23days"),
                        _buildPriceWithAdd("300"),
                        _buildCell("500"),
                        _buildCell("Mr. Imran"),
                        _buildCell("xxxxxxxxx245"),
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

  Widget _buildDropdown(
    String? selectedValue,
    String hintText,
    List<String> items,
    ValueChanged<String?> onChanged, {
    Icon icon = const Icon(Icons.arrow_drop_down),
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 140,
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            icon: icon,
            hint: Text(hintText),
            style: TextStyle(fontSize: 10),
            onChanged: onChanged,
            items:
                items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: EdgeInsets.zero,
                      child: Text(value),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(fontSize: 14)),
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
