import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../dialogs/date_picker.dart';
import '../../dialogs/tags_class.dart';
import 'create_order_dialog.dart';

class CreateOrders extends StatefulWidget {
  const CreateOrders({super.key});

  @override
  State<CreateOrders> createState() => _CreateOrdersState();
}

class _CreateOrdersState extends State<CreateOrders> {
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
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                          onEdit: () {},
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

/*
class DropdownItem {
  final String id;
  final String label;

  DropdownItem(this.id, this.label);

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label;

  @override
  int get hashCode => id.hashCode ^ label.hashCode;
}

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  List<DropdownItem> orderTypes = [
    DropdownItem("001", "Services Base"),
    DropdownItem("002", "Project Base"),
  ];
  DropdownItem? selectedOrderType;

  DateTime selectedDateTime = DateTime.now();

  final _clientController = TextEditingController(text: "Sample Client");
  final _beneficiaryController = TextEditingController(
    text: "Passport Renewal",
  );
  final _quotePriceController = TextEditingController(text: "500");
  final _fundsController = TextEditingController(text: "300");
  final _paymentIdController = TextEditingController(text: "TID 00001–01");

  String? selectedEmployee = "Muhammad Imran";

  @override
  void initState() {
    super.initState();
    selectedOrderType = orderTypes[0];
  }

  Future<void> _selectedDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Project Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text("ORN. 00001–0000001"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Input Fields Wrap
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildDateTimeField(),
                        _buildOrderTypeDropdown(
                          "Select Order Type",
                          selectedOrderType,
                          orderTypes,
                          (val) {
                            setState(() => selectedOrderType = val);
                          },
                        ),

                        _buildTextField(
                          "Select Service Project ",
                          _beneficiaryController,
                        ),
                        _buildDropdown(
                          "Project Assign Employee ",
                          selectedEmployee,
                          ["Muhammad Imran"],
                          (val) {
                            setState(() => selectedEmployee = val);
                          },
                        ),
                        CustomTextField(
                          label: "Service Beneficiary ",
                          controller: _clientController,
                          hintText: '',
                        ),
                        _buildTextField(
                          "Order Quote Price ",
                          _quotePriceController,
                        ),
                        _buildTextField("Received Funds", _fundsController),
                        _buildTextField(
                          "Record Payment I’d ",
                          _paymentIdController,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        CustomButton(
                          text: "Editing",
                          backgroundColor: Colors.blue.shade900,
                          icon: Icons.lock_open,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Stop",
                          backgroundColor: Colors.black,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Submit",
                          backgroundColor: Colors.red,
                          onPressed: () {},
                        ),
                        const Spacer(), // Pushes the icon to the right

                        Material(
                          elevation: 8,
                          color: Colors.blue, // Set background color here
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(
                              Icons.print,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Printed"),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.black87,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Title
                    Row(
                      children: [
                        Text(
                          "Stage – 01",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("SID–10000001"),
                        Spacer(),
                        Material(
                          elevation: 3,
                          shadowColor: Colors.grey.shade900,
                          shape: CircleBorder(),
                          color: Colors.blue,
                          child: Tooltip(
                            message: 'Create orders',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: 40,
                                width: 40,
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _field(
                          "Date and Time",
                          DateFormat(
                            "dd-MM-yyyy – hh:mm a",
                          ).format(selectedDateTime),
                          icon: Icons.calendar_month,
                        ),
                        _field(
                          "Reminder Date and Time",
                          DateFormat(
                            "dd-MM-yyyy – hh:mm a",
                          ).format(selectedDateTime),
                          icon: Icons.calendar_month,
                        ),
                        _field(
                          "Services Department ",
                          "FBR – Federal Board of Revenue",
                        ),
                        _field("Services Status Update ", "Pending for review"),
                        _field("Local Status ", "In Progress"),
                        _field("Tracking Status Tag", "Xyz Status"),
                        _noteText("Dynamic Attribute Sign"),
                        _field("Application I’d – 1", ""),
                        _noteText("Dynamic Application ID Sign"),

                        _field(
                          "Received Funds",
                          "XXX",
                          fillColor: Colors.green.shade100,
                        ),
                        _field(
                          "Pending Funds",
                          "XXX",
                          fillColor: Colors.red.shade100,
                        ),
                        _field(
                          "Project Cost",
                          "XXX",
                          fillColor: Colors.blue.shade100,
                        ),
                        _field("Record Payment I’d ", "TID 00001-01"),
                        _field("Received Funds", "300"),
                        _field("Step Cost", "500"),
                        _field("Additional Profit", "50"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons
                    Row(
                      children: [
                        CustomButton(
                          text: "Close Project",
                          backgroundColor: Colors.black,
                          icon: Icons.lock_open_outlined,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Next Step",
                          backgroundColor: Colors.blue,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Submit",
                          backgroundColor: Colors.red,
                          onPressed: () {},
                        ),
                        const Spacer(), // Pushes the icon to the right
                        Material(
                          elevation: 8,
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: IconButton(
                              icon: Icon(
                                Icons.print,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Printed"),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.black87,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                // Handle print action
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: _selectedDateTime,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Date and Time",
            labelStyle: TextStyle(color: Colors.red),
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_month, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: controller,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
        ),
        items:
            options.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildLabeledFieldWithHint({
    required String label,
    required String hint,
    required DateTime selectedDateTime,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.red),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.red),
            helperText: hint,
            // This acts like a hint below the field
            helperStyle: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    String value, {
    IconData? icon,
    Color? fillColor,
  }) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        cursorColor: Colors.blue,
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red, fontSize: 16),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: icon != null ? Icon(icon, color: Colors.red) : null,
          filled: fillColor != null,
          fillColor: fillColor,
        ),
      ),
    );
  }

  Widget _noteText(String text) {
    return SizedBox(
      width: 220,
      child: Text(
        text,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOrderTypeDropdown(
    String label,
    DropdownItem? selectedValue,
    List<DropdownItem> options,
    ValueChanged<DropdownItem?> onChanged,
  ) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<DropdownItem>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,

          labelStyle: const TextStyle(color: Colors.red),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        items:
            options.map((DropdownItem item) {
              return DropdownMenuItem<DropdownItem>(
                value: item,
                child: Text(item.label),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
*/
