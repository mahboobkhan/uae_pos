import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/banking_payments_provider.dart';
import '../../../utils/app_colors.dart';
import '../../dialogs/date_picker.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final bankingPaymentsProvider = context.read<BankingPaymentsProvider>();
        bankingPaymentsProvider.clearFilters();
        bankingPaymentsProvider.getAllBankingPayments();
      }
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

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

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  // Filter options
  final List<String> statusOptions = ['All', 'Pending', 'Completed'];
  final List<String> paymentTypeOptions = ['All', 'In', 'Out'];
  final List<String> typeOptions = ['All', 'Employee', 'Short Service', 'Office Expenses', 'Project'];
  final List<String> dateOptions = ['All', 'Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];

  // Selected filter values
  String? selectedStatus;
  String? selectedPaymentType;
  String? selectedType;
  String? selectedDateRange;

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
              // Filter Bar
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
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow:
                        _isHovering
                            ? [
                              BoxShadow(
                                color: Colors.blue,
                                blurRadius: 4,
                                spreadRadius: 0.2,
                                offset: const Offset(0, 1),
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
                              // Status Filter
                              CustomDropdown(
                                hintText: "Status",
                                selectedValue: selectedStatus,
                                items: statusOptions,
                                onChanged: (newValue) {
                                  setState(() => selectedStatus = newValue!);
                                  _applyFilters();
                                },
                              ),
                              // Payment Type Filter
                              CustomDropdown(
                                hintText: "Payment Type",
                                selectedValue: selectedPaymentType,
                                items: paymentTypeOptions,
                                onChanged: (newValue) {
                                  setState(() => selectedPaymentType = newValue!);
                                  _applyFilters();
                                },
                              ),
                              // Type Filter
                              CustomDropdown(
                                hintText: "Type",
                                selectedValue: selectedType,
                                items: typeOptions,
                                onChanged: (newValue) {
                                  setState(() => selectedType = newValue!);
                                  _applyFilters();
                                },
                              ),
                              // Date Filter
                              CustomDropdown(
                                hintText: "Dates",
                                selectedValue: selectedDateRange,
                                items: dateOptions,
                                onChanged: (newValue) async {
                                  if (newValue == 'Custom Range') {
                                    final selectedRange = await showDateRangePickerDialog(context);
                                    if (selectedRange != null) {
                                      final start = selectedRange.startDate ?? DateTime.now();
                                      final end = selectedRange.endDate ?? start;
                                      final formattedRange =
                                          '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';
                                      setState(() {
                                        selectedDateRange = formattedRange;
                                      });
                                      _applyCustomDateRange(start, end);
                                    }
                                  } else {
                                    setState(() => selectedDateRange = newValue!);
                                    _applyFilters();
                                  }
                                },
                                icon: const Icon(Icons.calendar_month, size: 18),
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
                                  final bankingProvider = context.read<BankingPaymentsProvider>();
                                  bankingProvider.getAllBankingPayments();
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
              // Banking Payments Table
              Consumer<BankingPaymentsProvider>(
                builder: (context, bankingProvider, child) {
                  if (bankingProvider.isLoading) {
                    return Container(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading banking payments...'),
                          ],
                        ),
                      ),
                    );
                  }

                  if (bankingProvider.errorMessage != null) {
                    return Container(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: AppColors.redColor),
                            SizedBox(height: 16),
                            Text(
                              bankingProvider.errorMessage!,
                              style: TextStyle(color: AppColors.redColor, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => bankingProvider.getAllBankingPayments(),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final payments = bankingProvider.payments;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  constraints: const BoxConstraints(minWidth: 1180),
                                  child: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(0.8),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(0.8),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(1),
                                    },
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(color: Colors.red.shade50),
                                        children: [
                                          _buildHeader("Date"),
                                          _buildHeader("Payment Ref"),
                                          _buildHeader("Type"),
                                          _buildHeader("Reference"),
                                          _buildHeader("Amount"),
                                          _buildHeader("Status"),
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
                                                payment['payment_ref_id']?.toString() ?? 'N/A',
                                                copyable: true,
                                              ),
                                              _buildCell(payment['type']?.toString().toUpperCase() ?? 'N/A'),
                                              _buildCell(payment['client_ref']?.toString() ?? 'N/A', copyable: true),
                                              _buildPriceWithAdd(
                                                bankingProvider.formatAmount(payment['paid_amount']) ?? 'N/A',
                                              ),
                                              _buildCell(
                                                payment['status']?.toString().toUpperCase() ?? 'N/A',
                                                copyable: false,
                                              ),
                                            ],
                                          );
                                        })
                                      else
                                        TableRow(
                                          children: List.generate(
                                            6,
                                            (index) => TableCell(
                                              child: SizedBox(
                                                height: 60,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.inbox_outlined, color: Colors.grey.shade400, size: 24),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'No payments available',
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
          style: const TextStyle(color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 12),
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
          Flexible(child: Text(text, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
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

  Widget _buildCell2(String text1, String text2, {bool copyable = false, bool centerText2 = false}) {
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
                    Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                    if (copyable)
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(Icons.copy, size: 14, color: Colors.blue[700]),
                        ),
                      ),
                  ],
                ),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54))),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.copy, size: 8, color: Colors.blue[700]),
                      ),
                    ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildPriceWithAdd(String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/dirham_symble.svg', height: 12, width: 12),
          Text(' $price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (showPlus)
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue)),
              child: const Icon(Icons.add, size: 13, color: Colors.blue),
            ),
        ],
      ),
    );
  }

  /// Apply filters to banking payments
  void _applyFilters() {
    final bankingProvider = context.read<BankingPaymentsProvider>();

    // Convert UI filter values to API parameters
    String? statusFilter;
    String? paymentTypeFilter;
    String? typeFilter;
    String? startDateFilter;
    String? endDateFilter;

    // Status filter
    if (selectedStatus != null && selectedStatus != 'All') {
      statusFilter = selectedStatus!.toLowerCase();
    }

    // Payment type filter
    if (selectedPaymentType != null && selectedPaymentType != 'All') {
      paymentTypeFilter = selectedPaymentType!.toLowerCase();
    }

    // Type filter
    if (selectedType != null && selectedType != 'All') {
      switch (selectedType) {
        case 'Employee':
          typeFilter = 'employee';
          break;
        case 'Short Service':
          typeFilter = 'short_service';
          break;
        case 'Office Expenses':
          typeFilter = 'expense';
          break;
        case 'Project':
          typeFilter = 'project';
          break;
      }
    }

    // Date filter
    if (selectedDateRange != null && selectedDateRange != 'All') {
      final now = DateTime.now();
      switch (selectedDateRange) {
        case 'Today':
          startDateFilter = DateFormat('yyyy-MM-dd').format(now);
          endDateFilter = DateFormat('yyyy-MM-dd').format(now);
          break;
        case 'Yesterday':
          final yesterday = now.subtract(Duration(days: 1));
          startDateFilter = DateFormat('yyyy-MM-dd').format(yesterday);
          endDateFilter = DateFormat('yyyy-MM-dd').format(yesterday);
          break;
        case 'Last 7 Days':
          final weekAgo = now.subtract(Duration(days: 7));
          startDateFilter = DateFormat('yyyy-MM-dd').format(weekAgo);
          endDateFilter = DateFormat('yyyy-MM-dd').format(now);
          break;
        case 'Last 30 Days':
          final monthAgo = now.subtract(Duration(days: 30));
          startDateFilter = DateFormat('yyyy-MM-dd').format(monthAgo);
          endDateFilter = DateFormat('yyyy-MM-dd').format(now);
          break;
      }
    }

    // Apply filters to provider
    bankingProvider.setFilters(
      type: typeFilter,
      paymentType: paymentTypeFilter,
      status: statusFilter,
      dateFrom: startDateFilter,
      dateTo: endDateFilter,
    );

    // Refresh payments with filters
    bankingProvider.getAllBankingPayments();
  }

  /// Apply custom date range filter
  void _applyCustomDateRange(DateTime startDate, DateTime endDate) {
    final bankingProvider = context.read<BankingPaymentsProvider>();

    bankingProvider.setFilters(
      dateFrom: DateFormat('yyyy-MM-dd').format(startDate),
      dateTo: DateFormat('yyyy-MM-dd').format(endDate),
    );

    bankingProvider.getAllBankingPayments();
  }

  /// Clear all filters
  void _clearFilters() {
    setState(() {
      selectedStatus = null;
      selectedPaymentType = null;
      selectedType = null;
      selectedDateRange = null;
    });

    final bankingProvider = context.read<BankingPaymentsProvider>();
    bankingProvider.clearFilters();
    bankingProvider.getAllBankingPayments();
  }
}
