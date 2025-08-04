import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/signup_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/tags_class.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  List<Map<String, dynamic>> tags = [];

  void _loadTags() async {
    final provider = Provider.of<SignupProvider>(context, listen: false);
    try {
      final result = await provider.getAllTags("user_123");
      setState(() {
        tags = result;
      });
    } catch (e) {
      print("Error loading tags: $e");
      // Optionally show a snackbar or alert
    }
  }


  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];

  final List<String> categories = ['All', 'Full time job', 'Half time job', 'Previous'];
  final List<String> categories1 = ['All', 'Manager', 'Supervisor', 'Employee'];
  final List<String> categories2 = ['All', 'paid', 'Pending'];

  String? selectedCategory;
  String? selectedCategory1;
  String? selectedCategory2;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                                hintText: "Employee Type",
                                items: categories,
                                onChanged: (newValue) {
                                  setState(() => selectedCategory = newValue!);
                                },
                              ),
                              CustomDropdown(
                                selectedValue: selectedCategory1,
                                hintText: "Designation",
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
                            ],
                          ),
                        ),
                      ),
/*
                      Row(
                        children: [
                          Card(
                            elevation: 8,
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            child: Builder(
                              builder:
                                  (context) => Tooltip(
                                    message: 'Show menu',
                                    waitDuration: const Duration(
                                      milliseconds: 2,
                                    ),
                                    child: GestureDetector(
                                      key: _plusKey,
                                      onTap: () async {
                                        EmployeeProfileDialog(context,null);
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
                                            Icons.people_alt,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
*/
                    ],
                  ),
                ),
              ),
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
                              constraints: const BoxConstraints(minWidth: 1200),
                              child: Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(0.8),
                                  1: FlexColumnWidth(1.2),
                                  2: FlexColumnWidth(1.2),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1.5),
                                  5: FlexColumnWidth(1.3),
                                  6: FlexColumnWidth(1.3),
                                  /*6: FlexColumnWidth(1.3),
                                  7: FlexColumnWidth(1),*/
                                  7: FlexColumnWidth(1),
                                  8: FlexColumnWidth(1.5),
                                },
                                children: [
                                  // Header Row
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                    ),
                                    children: [
                                      _buildHeader("Date"),
                                      _buildHeader("Employee Detail "),
                                      _buildHeader("Tags Details"),
                                      _buildHeader("Designation"),
                                      _buildHeader("Payment Mode"),
                                      _buildHeader("Salary"),
                                      _buildHeader("Advance"),
                                     /* _buildHeader("Bonuses "),
                                      _buildHeader("Pending"),*/
/*
                                      _buildHeader("Total "),
*/
                                      _buildHeader("Others"),
                                    ],
                                  ),
                                  // Sample Row
                                  for (int i = 0; i < 20; i++)
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: i.isEven
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade100,
                                      ),
                                      children: [
                                        _buildCell2("12-02-2025", "02:59 pm", centerText2: true),
                                        _buildCell("User"),
                                        TagsCellWidget(initialTags: tags),

                                        _buildCell("Manager"),
                                        _buildCell3("Bank Transfer", "TID *********456", copyable: true),
                                        _buildPriceWithAdd("AED-", "100000"),
                                        _buildPriceWithAdd1("AED-", "300", ),
                                       /* _buildPriceWithAdd("AED-", "2000", showPlus: true),
                                        _buildCell("N/A"),*/
/*
                                        _buildPriceWithAdd2("AED-"," 1400"),
*/
                                        _buildCell("**********456", copyable: true),
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
      ),
    );
  }

  /// Reusable Table Widgets
  Widget _buildHeader(String text) => Container(
    height: 40,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 8.0),
    child: Text(
      text,
      style: const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );

  Widget _buildCell3(String text1, String text2, {bool copyable = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text2,
                    style: const TextStyle(fontSize: 10, color: Colors.black54)),
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
                      child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  Widget _buildCell2(String text1, String text2,
      {bool copyable = false, bool centerText2 = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );

  Widget _buildCell(String text, {bool copyable = false}) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
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
  Widget _buildPriceWithAdd1(String curr, String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            curr,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(price,style: TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.bold),),
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


}




/*

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/signup_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/tags_class.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];

  final List<String> categories = ['All', 'Full time job', 'Half time job', 'Previous'];
  final List<String> categories1 = ['All', 'Manager', 'Supervisor', 'Employee'];
  final List<String> categories2 = ['All', 'paid', 'Pending'];

  String? selectedCategory;
  String? selectedCategory1;
  String? selectedCategory2;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // Load employees only once when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SignupProvider>(context, listen: false).fetchEmployees();
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  String _formatDateForDisplay(String apiDate) {
    try {
      final parsedDate = DateTime.parse(apiDate);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterBar(),
              const SizedBox(height: 10),
              Consumer<SignupProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.employees.isEmpty) {
                    return const Center(child: Text('No employees found'));
                  }

                  return Container(
                    height: 400,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildEmployeeTable(provider),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Filter Bar
  Widget _buildFilterBar() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(2),
          boxShadow: _isHovering
              ? [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 4,
              spreadRadius: 0.1,
              offset: const Offset(0, 1),
            )
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
                      hintText: "Employee Type",
                      items: categories,
                      onChanged: (newValue) =>
                          setState(() => selectedCategory = newValue!),
                    ),
                    CustomDropdown(
                      selectedValue: selectedCategory1,
                      hintText: "Designation",
                      items: categories1,
                      onChanged: (newValue) =>
                          setState(() => selectedCategory1 = newValue!),
                    ),
                    CustomDropdown(
                      selectedValue: selectedCategory2,
                      hintText: "Payment Status",
                      items: categories2,
                      onChanged: (newValue) =>
                          setState(() => selectedCategory2 = newValue!),
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

  /// Employee Table
  Widget _buildEmployeeTable(SignupProvider provider) {
    return ScrollbarTheme(
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
                constraints: const BoxConstraints(minWidth: 1200),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(0.8),
                    1: FlexColumnWidth(1.2),
                    2: FlexColumnWidth(1.2),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1.5),
                    5: FlexColumnWidth(1.3),
                    6: FlexColumnWidth(1.3),
                    7: FlexColumnWidth(1),
                    8: FlexColumnWidth(1.5),
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.red.shade50),
                      children: [
                        _buildHeader("Date"),
                        _buildHeader("Employee Detail"),
                        _buildHeader("Tags Details"),
                        _buildHeader("Designation"),
                        _buildHeader("Payment Mode"),
                        _buildHeader("Salary"),
                        _buildHeader("Advance"),
                        _buildHeader("Others"),
                      ],
                    ),
                    // Data Rows
                    ...provider.employees.map((employee) {
                      final index = provider.employees.indexOf(employee);
                      return TableRow(
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? Colors.grey.shade200
                              : Colors.grey.shade100,
                        ),
                        children: [
                          _buildCell2(
                            _formatDateForDisplay(employee['joining_date'] ?? ''),
                            '',
                            centerText2: true,
                          ),
                          _buildCell(employee['employee_name'] ?? ''),
                          TagsCellWidget(initialTags: currentTags),
                          _buildCell(employee['emp_designation'] ?? ''),
                          _buildCell3(
                            employee['payment_method'] ?? '',
                            employee['bank_account'] != null
                                ? 'TID ****${employee['bank_account'].toString().substring(
                                employee['bank_account'].toString().length - 3)}'
                                : '',
                            copyable: true,
                          ),
                          _buildPriceWithAdd(
                              "AED-", employee['salary']?.toString() ?? '0'),
                          _buildPriceWithAdd1(
                              "AED-", employee['advance']?.toString() ?? '0'),
                          _buildCell(
                            employee['emirate_id']?.toString() ?? '',
                            copyable: true,
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable Table Widgets
  Widget _buildHeader(String text) => Container(
    height: 40,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 8.0),
    child: Text(
      text,
      style: const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );

  Widget _buildCell3(String text1, String text2, {bool copyable = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text2,
                    style: const TextStyle(fontSize: 10, color: Colors.black54)),
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
                      child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  Widget _buildCell2(String text1, String text2,
      {bool copyable = false, bool centerText2 = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );

  Widget _buildCell(String text, {bool copyable = false}) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
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

  Widget _buildPriceWithAdd(String curr, String price,
      {bool showPlus = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(curr,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold)),
            Text(price,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildPriceWithAdd1(String curr, String price,
      {bool showPlus = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(curr,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold)),
            Text(price,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
}


 */