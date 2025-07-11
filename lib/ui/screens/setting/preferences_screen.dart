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
  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];
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
    'Toady',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];
  String? selectedCategory3;
  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

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
                          elevation: 8,
                          color: Colors.blue,
                          shape: CircleBorder(),
                          child: Builder(
                            builder:
                                (context) =>
                                Tooltip(
                                  message: 'Show menu',
                                  waitDuration: Duration(milliseconds: 2),
                                  child: GestureDetector(
                                    key: _plusKey,
                                    onTap:() {},
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
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Card(
              elevation: 4, // Controls shadow depth
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              'Tid OOOOOOOOOOOO43',
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
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        /*  border: TableBorder.all(
                            color: Colors.white,
                            width: 1,
                          ),*/
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

                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                            ),
                            children: [
                              _buildHeader("File Id"),
                              _buildHeader("File Name "),
                              _buildHeader("Tag Details"),
                              _buildHeader("Issue Date"),
                              _buildHeader("Expiry Date"),
                              _buildHeader("Source Form"),
                              _buildHeader("Download Price "),
                              _buildHeader("Action"),

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
                                _buildCell(
                                  "xxxxxxxx",copyable: true,
                                ),
                                _buildCell(
                                  "xxxxxxxxxx",
                                  copyable: true,
                                ),
                                _buildTagsCell(currentTags, context),
                                _buildCell("12-2-2025"),
                                _buildCell("12-2-2025"),
                                _buildCell("N/A"),
                                _buildCell("Click Download "),
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

          ],
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
              suffixIcon: const Icon(Icons.calendar_month, size: 18, color: Colors.red),
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
    VoidCallback? onDraft,
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
/*
        IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: Colors.red,
          ),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),
*/
      ],
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


