import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/date_picker.dart';

class PreferencesScreen extends StatefulWidget {

  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _editFileNameController.dispose();
    _editIssueDateController.dispose();
    _editExpiryDateController.dispose();
    super.dispose();
  }
  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
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
  final List<String> categories3 = [
    'All',
    'Toady',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];
  String? selectedCategory3;
  bool _isHovering = false;

  // Edit dialog controllers
  final _editFileNameController = TextEditingController();
  final _editIssueDateController = TextEditingController();
  final _editExpiryDateController = TextEditingController();


  String formatDateTime(DateTime? dt) {
    final now = DateTime.now();
    return DateFormat('dd-MM-yyyy – hh:mm a').format(dt ?? now);
  }

  Future<void> _pickEditDateTime(bool isIssueDate) async {
    DateTime now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final formatted = DateFormat('dd-MM-yyyy – hh:mm a').format(selectedDateTime);

    setState(() {
      if (isIssueDate) {
        _editIssueDateController.text = formatted;
      } else {
        _editExpiryDateController.text = formatted;
      }
    });
  }

  void  _showEditDialog(String fileName, String issueDate, String expiryDate) {
    print('Edit dialog called with: $fileName, $issueDate, $expiryDate');
    
    // Pre-populate the controllers with current values
    _editFileNameController.text = fileName;
    _editIssueDateController.text = issueDate;
    _editExpiryDateController.text = expiryDate;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit File Details'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _editFileNameController,
                  decoration: const InputDecoration(
                    labelText: 'File Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _editIssueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Issue Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _pickEditDateTime(true),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _editExpiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _pickEditDateTime(false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you can save the edited values
                // For now, just close the dialog
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File details updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FAB pressed - testing dialog');
          _showEditDialog(
            "Test File", 
            "01-01-2025", 
            "31-12-2025"
          );
        },
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 45,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
                          elevation: 4,
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Refresh',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: const Center(child: Icon(Icons.refresh, color: Colors.white, size: 20)),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          color: Colors.orange,
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Clear Filters',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: const Center(child: Icon(Icons.clear, color: Colors.white, size: 20)),
                              ),
                            ),
                          ),
                        ),
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
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 1150),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            controller: _verticalController,
                            child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(0.8),
                                1: FlexColumnWidth(1.5),
                                2: FlexColumnWidth(1),
                                3: FlexColumnWidth(1),
                                4: FlexColumnWidth(1.3),
                                5: FlexColumnWidth(1),
                                6: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                  ),
                                  children: [
                                    _buildHeader("File Id"),
                                    _buildHeader("File Name"),
                                    _buildHeader("Issue Date"),
                                    _buildHeader("Expiry Date"),
                                    _buildHeader("Source Form"),
                                    _buildHeader("Download Price"),
                                    _buildHeader("Action"),
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
                                      _buildCell("xxxxxxxx", copyable: true),
                                      _buildCell("xxxxxxxxxx", copyable: true),
                                      _buildCell("12-2-2025"),
                                      _buildCell("12-2-2025"),
                                      _buildCell("N/A"),
                                      _buildCell("Click Download"),
                                      _buildActionCell(
                                        onEdit: () {
                                          print('Edit button pressed');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Edit button clicked!')),
                                          );
                                          _showEditDialog(
                                            "xxxxxxxxxx", // File name
                                            "12-2-2025",  // Issue date
                                            "12-2-2025",  // Expiry date
                                          );
                                        },
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
            )

          ],
        ),
      ),
    );
  }


  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
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

  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✏️ Edit Button with Tooltip
          Tooltip(
            message: 'Edit',
            waitDuration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: onEdit ?? () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.edit, size: 20, color: Colors.blue),
              ),
            ),
          ),

        ],
      ),
    );
  }

}



