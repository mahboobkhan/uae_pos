import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../utils/clipboard_utils.dart';
import '../../../providers/employee_payments_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import 'employee_dialoges/employe_profile.dart';
import '../../dialogs/tags_class.dart';

class EmployeeFinance extends StatefulWidget {
  const EmployeeFinance({super.key});

  @override
  State<EmployeeFinance> createState() => _EmployeeFinanceState();
}

class _EmployeeFinanceState extends State<EmployeeFinance> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final employeePaymentsProvider = context.read<EmployeePaymentsProvider>();
        employeePaymentsProvider.clearFilters();
        employeePaymentsProvider.getAllEmployeePayments();
      }
    });
  }

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
  final GlobalKey _plusKey = GlobalKey();
  final List<String> categories = [
    'All',
    'salary',
    'pay',
    'bonus',
    'advance',
    'return',
  ];
  final List<String> categories1 = [
    'All',
    'This Month',
    'Last Month',
    'This Year',
    'Last Year',
  ];
  final List<String> categories2 = ['All', 'Low Amount', 'High Amount'];
  final List<String> categories3 = [
    'All',
    'Recent',
    'Oldest',
  ];

  String? selectedCategory;
  String? selectedCategory1;
  String? selectedCategory2;
  String? selectedCategory3;
  bool _isHovering = false;

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '00-00-0000';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return '00-00-0000';
    }
  }

  String _formatTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '00-00';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '00-00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
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
                              hintText: "Payment Type",
                              items: categories,
                              onChanged: (newValue) {
                                setState(() => selectedCategory = newValue!);
                                _applyFilters();
                              },
                            ),
                            CustomDropdown(
                              selectedValue: selectedCategory1,
                              hintText: "Date Range",
                              items: categories1,
                              onChanged: (newValue) {
                                setState(() => selectedCategory1 = newValue!);
                                _applyFilters();
                              },
                            ),
                            CustomDropdown(
                              selectedValue: selectedCategory2,
                              hintText: "Amount Range",
                              items: categories2,
                              onChanged: (newValue) {
                                setState(() => selectedCategory2 = newValue!);
                                _applyFilters();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // Clear Filters Button
                        Card(
                          elevation: 4,
                          color: Colors.orange,
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Clear Filters',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                _clearFilters();
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
                        // Refresh Button
                        Card(
                          elevation: 4,
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Refresh',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                final employeePaymentsProvider = context.read<EmployeePaymentsProvider>();
                                employeePaymentsProvider.getAllEmployeePayments();
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
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Employee Payments Table
            Consumer<EmployeePaymentsProvider>(
              builder: (context, employeePaymentsProvider, child) {
                if (employeePaymentsProvider.isLoading) {
                  return Container(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading employee payments...'),
                        ],
                      ),
                    ),
                  );
                }

                if (employeePaymentsProvider.errorMessage != null) {
                  return Container(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            employeePaymentsProvider.errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => employeePaymentsProvider.getAllEmployeePayments(),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final payments = employeePaymentsProvider.employeePayments;

                return Padding(
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
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1.2),
                                    4: FlexColumnWidth(1.3),
                                    5: FlexColumnWidth(1.3),
                                    6: FlexColumnWidth(1.3),
                                  },
                                  children: [
                                    // Header Row
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                      ),
                                      children: [
                                        _buildHeader("Date"),
                                        _buildHeader("Employee Ref"),
                                        _buildHeader("Payment Type"),
                                        _buildHeader("Month/Year"),
                                        _buildHeader("Amount"),
                                        _buildHeader("Description"),
                                        _buildHeader("Actions"),
                                      ],
                                    ),
                                    if (payments.isNotEmpty)
                                      ...payments.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final payment = entry.value;
                                        return TableRow(
                                          decoration: BoxDecoration(
                                            color: index.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                          ),
                                          children: [
                                            _buildCell2(
                                              _formatDate(payment['created_at'] ?? payment['updated_at']),
                                              _formatTime(payment['created_at'] ?? payment['updated_at']),
                                              copyable: false,
                                            ),
                                            _buildCell(
                                              payment['employee_ref_id']?.toString() ?? 'N/A',
                                              copyable: true,
                                            ),
                                            _buildCell(
                                              employeePaymentsProvider.getPaymentTypeLabel(payment['type']?.toString() ?? ''),
                                            ),
                                            _buildCell(payment['month_year']?.toString() ?? 'N/A'),
                                            _buildPriceWithAdd( employeePaymentsProvider.formatAmount(payment['amount'])),
                                            _buildCell(payment['description']?.toString() ?? 'N/A'),
                                            _buildCell("N/A"),
                                          ],
                                        );
                                      }).toList()
                                    else
                                      TableRow(
                                        children: List.generate(
                                          7,
                                          (index) => TableCell(
                                            child: Container(
                                              height: 60,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.inbox_outlined, color: Colors.grey.shade400, size: 24),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'No employee payments available',
                                                      style: TextStyle(
                                                        color: Colors.grey.shade600,
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 12,
                                                      ),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

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


  Widget _buildPriceWithAdd( String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SvgPicture.asset('icons/dirham_symble.svg', height: 12, width: 12),
          Text(' $price',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
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
  Widget _buildCell(String text, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
  Widget _buildCell3(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text1, style: const TextStyle(fontSize: 12)),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    ClipboardUtils.copyToClipboard(text1, context, message: 'Text 1 copied');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
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
                    ClipboardUtils.copyToClipboard(text2, context, message: 'Text 2 copied');
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
  Widget _buildCell2(String text1,
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

  /// Apply filters to employee payments
  void _applyFilters() {
    final employeePaymentsProvider = context.read<EmployeePaymentsProvider>();

    // Convert UI filter values to API parameters
    String? typeFilter;
    String? startDateFilter;
    String? endDateFilter;
    String? sortByFilter;
    String? sortOrderFilter;

    // Payment type filter
    if (selectedCategory != null && selectedCategory != 'All') {
      typeFilter = selectedCategory!.toLowerCase();
    }

    // Date range filter
    if (selectedCategory1 != null && selectedCategory1 != 'All') {
      final now = DateTime.now();
      switch (selectedCategory1) {
        case 'This Month':
          startDateFilter = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
          endDateFilter = DateFormat('yyyy-MM-dd').format(now);
          break;
        case 'Last Month':
          final lastMonth = DateTime(now.year, now.month - 1, 1);
          final lastMonthEnd = DateTime(now.year, now.month, 0);
          startDateFilter = DateFormat('yyyy-MM-dd').format(lastMonth);
          endDateFilter = DateFormat('yyyy-MM-dd').format(lastMonthEnd);
          break;
        case 'This Year':
          startDateFilter = DateFormat('yyyy-MM-dd').format(DateTime(now.year, 1, 1));
          endDateFilter = DateFormat('yyyy-MM-dd').format(now);
          break;
        case 'Last Year':
          final lastYear = now.year - 1;
          startDateFilter = DateFormat('yyyy-MM-dd').format(DateTime(lastYear, 1, 1));
          endDateFilter = DateFormat('yyyy-MM-dd').format(DateTime(lastYear, 12, 31));
          break;
      }
    }

    // Sort filter
    if (selectedCategory3 != null && selectedCategory3 != 'All') {
      sortByFilter = 'created_at';
      sortOrderFilter = selectedCategory3 == 'Recent' ? 'DESC' : 'ASC';
    }

    // Apply filters to provider
    employeePaymentsProvider.setFilters(
      type: typeFilter,
      startDate: startDateFilter,
      endDate: endDateFilter,
      sortBy: sortByFilter,
      sortOrder: sortOrderFilter,
    );

    // Refresh payments with filters
    employeePaymentsProvider.getAllEmployeePayments();
  }

  /// Clear all filters
  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedCategory1 = null;
      selectedCategory2 = null;
      selectedCategory3 = null;
    });

    final employeePaymentsProvider = context.read<EmployeePaymentsProvider>();
    employeePaymentsProvider.clearFilters();
    employeePaymentsProvider.getAllEmployeePayments();
  }

}




