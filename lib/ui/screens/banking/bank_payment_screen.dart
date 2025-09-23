import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/banking_payment_method_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import 'banking_dialoges/add_payment_method.dart';

class BankPaymentScreen extends StatefulWidget {
  const BankPaymentScreen({super.key});

  @override
  State<BankPaymentScreen> createState() => _BankPaymentScreenState();
}

class _BankPaymentScreenState extends State<BankPaymentScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  bool _isHovering = false;
  final GlobalKey _plusKey = GlobalKey();

  // Filter options
  final List<String> statusOptions = ['All', 'Active', 'Inactive'];
  final List<String> bankOptions = [
    'All',
    'HBL Bank',
    'UBL Bank',
    'MCB Bank',
    'Allied Bank',
  ];
  final List<String> dateOptions = [
    'All',
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];

  // Selected filter values
  String? selectedStatus;
  String? selectedBank;
  String? selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Load payment methods when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(Duration(milliseconds: 200), () {
          if (mounted) {
            try {
              final provider = context.read<BankingPaymentMethodProvider>();
              provider.getAllPaymentMethods();
            } catch (e) {
              print('Error accessing provider: $e');
            }
          }
        });
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

  // Apply filters to the payment methods
  void _applyFilters() {
    final provider = context.read<BankingPaymentMethodProvider>();

    // Apply filters to provider
    provider.setFilters(
      bankName:
          selectedBank != null && selectedBank != 'All' ? selectedBank : null,
      status:
          selectedStatus != null && selectedStatus != 'All'
              ? selectedStatus
              : null,
    );
  }

  // Clear all filters
  void _clearFilters() {
    setState(() {
      selectedStatus = null;
      selectedBank = null;
      selectedDateRange = null;
    });

    final provider = context.read<BankingPaymentMethodProvider>();
    provider.clearFilters();
  }

  // Delete payment method
  void _deletePaymentMethod(
    BuildContext context,
    Map<String, dynamic> paymentMethod,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => const ConfirmationDialog(
            title: 'Confirm Deletion',
            content: 'Are you sure you want to delete this payment method?',
            cancelText: 'Cancel',
            confirmText: 'Delete',
          ),
    );

    if (shouldDelete == true) {
      final provider = context.read<BankingPaymentMethodProvider>();
      await provider.deletePaymentMethod(
        paymentMethodRefId: paymentMethod['payment_method_ref_id'],
      );
    }
  }

  // Edit payment method
  void _editPaymentMethod(
    BuildContext context,
    Map<String, dynamic> paymentMethod,
  ) {
    // TODO: Implement edit functionality
    showDialog(
      context: context,
      builder:
          (context) => AddPaymentMethodDialog(paymentMethodData: paymentMethod),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch to automatically rebuild when provider changes
    final provider = context.watch<BankingPaymentMethodProvider>();

    // If no data and not loading, try to load data
    if (provider.paymentMethods.isEmpty &&
        !provider.isLoading &&
        provider.errorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          provider.getAllPaymentMethods();
        }
      });
    }

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
                            // Status Filter
                            CustomDropdown(
                              hintText: "Status",
                              selectedValue: selectedStatus,
                              onChanged: (newValue) {
                                setState(() => selectedStatus = newValue!);
                                _applyFilters();
                              },
                              items: statusOptions,
                            ),
                            // Bank Filter
                            CustomDropdown(
                              hintText: "Bank Name",
                              selectedValue: selectedBank,
                              onChanged: (newValue) {
                                setState(() => selectedBank = newValue!);
                                _applyFilters();
                              },
                              items: bankOptions,
                            ),
                            // Date Filter
                            CustomDropdown(
                              hintText: "Dates",
                              selectedValue: selectedDateRange,
                              onChanged: (newValue) async {
                                if (newValue == 'Custom Range') {
                                  // TODO: Implement custom date range picker
                                  setState(() => selectedDateRange = newValue!);
                                } else {
                                  setState(() => selectedDateRange = newValue!);
                                  _applyFilters();
                                }
                              },
                              items: dateOptions,
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
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
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
                                provider.getAllPaymentMethods();
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Add Payment Method Button
                        Card(
                          elevation: 8,
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          child: Tooltip(
                            message: 'Add Payment Method',
                            waitDuration: const Duration(milliseconds: 2),
                            child: GestureDetector(
                              key: _plusKey,
                              onTap: () {
                                showAddPaymentMethodDialog(context);
                              },
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
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
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Show loading indicator
            if (provider.isLoading)
              Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading payment methods...'),
                    ],
                  ),
                ),
              )
            // Show error message
            else if (provider.errorMessage != null)
              Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        provider.errorMessage ?? 'An error occurred',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          provider.getAllPaymentMethods();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            // Show success message
            else if (provider.successMessage != null)
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.successMessage ??
                            'Operation completed successfully',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.green),
                      onPressed: () {
                        provider.clearMessages();
                      },
                    ),
                  ],
                ),
              ),

            SizedBox(height: 15),

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
                            constraints: const BoxConstraints(minWidth: 1180),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(0.5),
                                1: FlexColumnWidth(0.6),
                                2: FlexColumnWidth(0.6),
                                3: FlexColumnWidth(1),
                                4: FlexColumnWidth(1),
                                5: FlexColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                  ),
                                  children: [
                                    _buildHeader("Date"),
                                    _buildHeader("Bank Name"),
                                    _buildHeader("Title Name"),
                                    _buildHeader("Account No/IBN"),
                                    _buildHeader("Mobile/Email"),
                                    _buildHeader("Other Actions"),
                                  ],
                                ),
                                if (provider.filteredPaymentMethods.isNotEmpty)
                                  ...provider.filteredPaymentMethods.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final paymentMethod = entry.value;
                                    return TableRow(
                                      decoration: BoxDecoration(
                                        color:
                                            index.isEven
                                                ? Colors.grey.shade200
                                                : Colors.grey.shade100,
                                      ),
                                      children: [
                                        _buildCell2(
                                          _formatDate(
                                            paymentMethod['created_at'] ??
                                                paymentMethod['updated_at'],
                                          ),
                                          _formatTime(
                                            paymentMethod['created_at'] ??
                                                paymentMethod['updated_at'],
                                          ),
                                          centerText2: true,
                                        ),
                                        _buildCell(
                                          paymentMethod['bank_name'] ?? 'N/A',
                                        ),
                                        _buildCell(
                                          paymentMethod['account_title'] ??
                                              'N/A',
                                        ),
                                        _buildCell2(
                                          "ACC ${paymentMethod['account_num'] ?? 'N/A'}",
                                          "IBN ${paymentMethod['iban'] ?? 'N/A'}",
                                          copyable: true,
                                        ),
                                        _buildCell2(
                                          paymentMethod['registered_phone'] ??
                                              'N/A',
                                          paymentMethod['registered_email'] ??
                                              'N/A',
                                        ),
                                        _buildActionCell(
                                          onEdit:
                                              () => _editPaymentMethod(
                                                context,
                                                paymentMethod,
                                              ),
                                          onDelete:
                                              () => _deletePaymentMethod(
                                                context,
                                                paymentMethod,
                                              ),
                                        ),
                                      ],
                                    );
                                  }).toList()
                                else if (!provider.isLoading)
                                  TableRow(
                                    children: List.generate(
                                      6,
                                      (index) => TableCell(
                                        child: Container(
                                          height: 60,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.inbox_outlined,
                                                  color: Colors.grey.shade400,
                                                  size: 24,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'No payment methods available',
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
                  Text(
                    text2,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
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

  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onDraft,
  }) {
    return Row(
      children: [
        /*IconButton(
          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),*/
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),

        /*IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: Colors.red,
          ),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),*/
      ],
    );
  }
}
