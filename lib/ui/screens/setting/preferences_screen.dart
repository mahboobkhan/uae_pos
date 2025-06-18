import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _tagController = TextEditingController();
  final _docNameController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();


  DateTime? issueDate;
  DateTime? expiryDate;

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
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];
  String? selectedCategory3;

  Future<void> _pickDateTime(bool isIssueDate) async {
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
        issueDate = selectedDateTime;
        _issueDateController.text = formatted;
      } else {
        expiryDate = selectedDateTime;
        _expiryDateController.text = formatted;
      }
    });
  }

  String formatDateTime(DateTime? dt) {
    final now = DateTime.now();
    return DateFormat('dd-MM-yyyy – hh:mm a').format(dt ?? now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
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
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.11,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.red, width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: const TextField(
                          style: TextStyle(fontSize: 12),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: 12),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
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
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Column(
                        children: [
                          Text(
                            'Files Backup',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Tid OOOOOOOOOOOO43  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _buildInputField(_docNameController, 'File Name'),
                          _buildInputField(_tagController, 'Tag 1'),
                          _buildInputField(_nameController, 'Name'),
                          _buildInputField(_emailController, 'Email'),
                          _buildInputField(_mobileController, 'Phone Number'),
                          _buildDateField('Issue Date Notification', _issueDateController, () => _pickDateTime(true)),
                          _buildDateField('Expiry Date Notification', _expiryDateController, () => _pickDateTime(false)),

                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            onPressed: () {},
                            child: const Text('Upload File', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            onPressed: () {},
                            child: const Text('Download', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            onPressed: () {},
                            child: const Text('Submit', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
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
                  // Header Row
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
                    children: [
                      _buildHeader("File Id"),
                      _buildHeader("File Name"),
                      _buildHeader("Tag"),
                      _buildHeader("Issue Date"),
                      _buildHeader("Expiry Date"),
                      _buildHeader("Source Form"),
                      _buildHeader("Download Price"),
                      _buildHeader("Action"),
                    ],
                  ),
                  // Sample Data Row
                  TableRow(
                    children: [
                      _buildCell("xxxxx"),
                      _buildCell(
                        "Password",
                        copyable: true,
                      ),
                      _buildCell("Sample Tags",),
                      _buildCell("12-2-2025"),
                      _buildCell("12-2-2025"),
                      _buildCell("N/A"),
                      _buildCell("Click Download With Pswd"),
                      _buildCell("Edit"),
                    ],
                  ),
                ],
              ),
            ),

          ],
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
            style: const TextStyle(fontSize: 10),
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

  Widget _buildInputField(TextEditingController controller, String label) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, VoidCallback onTap) {
    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.red),
              suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.red),
              border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildHeader(String text) {
    return Container(
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


}
