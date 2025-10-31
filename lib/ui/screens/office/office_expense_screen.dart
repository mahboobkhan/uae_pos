import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../providers/expense_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/request_state.dart' show RequestState;
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/tags_class.dart';
import '../banking/banking_dialoges/unified_office_expense_dialog.dart';

class OfficeExpenseScreen extends StatefulWidget {
  const OfficeExpenseScreen({super.key});

  @override
  State<OfficeExpenseScreen> createState() => _OfficeExpenseScreenState();
}

class _OfficeExpenseScreenState extends State<OfficeExpenseScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  /// Format number to display with K, M suffixes
  String formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  /// Get shortened expense type name for display
  String _getShortExpenseTypeName(String fullName) {
    switch (fullName) {
      case 'Fixed Office Expense':
        return 'Fixed Office';
      case 'Office Maintenance Expense':
        return 'Maintenance';
      case 'Miscellaneous Office Expense':
        return 'Miscellaneous';
      case 'Office Supplies Expense':
        return 'Supplies';
      case 'Dynamic Attribute Office Expense':
        return 'Dynamic';
      default:
        return fullName.length > 15
            ? '${fullName.substring(0, 15)}...'
            : fullName;
    }
  }

  /// Get expense type amount in format "amount / total"
  String _getExpenseTypeAmount(String expenseType, dynamic expensesProvider) {
    // Find the breakdown for this expense type
    final matchingBreakdowns = expensesProvider.expenseTypeBreakdown.where(
      (item) => item.expenseType == expenseType,
    );

    double typeAmount = 0.0;
    if (matchingBreakdowns.isNotEmpty) {
      typeAmount = matchingBreakdowns.first.totalAmount;
    }

    double totalAmount = expensesProvider.totalExpenseAmount;

    return '${formatNumber(typeAmount)} / ${formatNumber(totalAmount)}';
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<ExpenseProvider>(context, listen: false).resetState();
    Future.microtask(() {
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
    });
    super.initState();
  }

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];
  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  // Dynamic stats will be generated from ExpenseProvider data

  DateTime selectedDateTime = DateTime.now();

  // Expense Type filter only
  final List<String> expenseTypeOptions = [
    'All',
    'Fixed Office Expense',
    'Office Maintenance Expense',
    'Miscellaneous Office Expense',
    'Office Supplies Expense',
    'Dynamic Attribute Office Expense',
  ];
  String? selectedExpenseType;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expensesProvider, child) {
        if (expensesProvider.state == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (expensesProvider.state == RequestState.error) {
          return Center(child: Text(expensesProvider.errorMessage ?? "Error"));
        }

        if (expensesProvider.expenses.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No Office Expenses Found",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // You can add navigation to add expense dialog here
                      // For now, just refresh the data
                      Provider.of<ExpenseProvider>(
                        context,
                        listen: false,
                      ).fetchExpenses();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      // Fixed Office Expense
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70,
                            shadowColor: Colors.black,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      _getExpenseTypeAmount(
                                        'Fixed Office Expense',
                                        expensesProvider,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const FittedBox(
                                    child: Text(
                                      'Fixed Office',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Office Maintenance Expense
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70,
                            shadowColor: Colors.black,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      _getExpenseTypeAmount(
                                        'Office Maintenance Expense',
                                        expensesProvider,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const FittedBox(
                                    child: Text(
                                      'Office Maintenance',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Miscellaneous Office Expense
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70,
                            shadowColor: Colors.black,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      _getExpenseTypeAmount(
                                        'Miscellaneous Office Expense',
                                        expensesProvider,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const FittedBox(
                                    child: Text(
                                      'Miscellaneous',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Office Supplies Expense
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70,
                            shadowColor: Colors.black,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      _getExpenseTypeAmount(
                                        'Office Supplies Expense',
                                        expensesProvider,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const FittedBox(
                                    child: Text(
                                      'Office Supplies',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Dynamic Attribute Office Expense
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70,
                            shadowColor: Colors.black,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      _getExpenseTypeAmount(
                                        'Dynamic Attribute Office Expense',
                                        expensesProvider,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const FittedBox(
                                    child: Text(
                                      'Other',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
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
                                CustomDropdown(
                                  hintText: "Expense Type",
                                  selectedValue: selectedExpenseType,
                                  items: expenseTypeOptions,
                                  onChanged: (newValue) {
                                    setState(
                                      () => selectedExpenseType = newValue!,
                                    );
                                    final provider =
                                        Provider.of<ExpenseProvider>(
                                          context,
                                          listen: false,
                                        );
                                    if (newValue == 'All' || newValue == null) {
                                      provider.fetchExpenses();
                                    } else {
                                      provider.fetchExpenses(
                                        expenseType: newValue,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Refresh',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<ExpenseProvider>(
                                  context,
                                  listen: false,
                                ).fetchExpenses();
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
                        Card(
                          elevation: 4,
                          color: Colors.orange,
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Clear Filters',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedExpenseType = null;
                                });
                                Provider.of<ExpenseProvider>(
                                  context,
                                  listen: false,
                                ).fetchExpenses();
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
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(
                                        context,
                                      ).size.width, // dynamic width
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  controller: _verticalController,
                                  child: Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(0.8),
                                      1: FlexColumnWidth(1.3),
                                      2: FlexColumnWidth(1.3),
                                      3: FlexColumnWidth(1.1),
                                      // 4: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(1),
                                      6: FlexColumnWidth(0.5),
                                    },
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                        ),
                                        children: [
                                          _buildHeader("Date"),
                                          _buildHeader("Name"),
                                          _buildHeader("Amount"),
                                          _buildHeader("Type"),
                                          _buildHeader("Note"),
                                          // _buildHeader("Tags"),
                                          _buildHeader("Manage"),
                                          _buildHeader("Action"),
                                        ],
                                      ),
                                      // Sample Data Rows
                                      ...expensesProvider.expenses.asMap().entries.map((
                                        entry,
                                      ) {
                                        final index = entry.key;
                                        final e = entry.value;
                                        return TableRow(
                                          decoration: BoxDecoration(
                                            color:
                                                index.isEven
                                                    ? Colors.grey.shade200
                                                    : Colors.grey.shade100,
                                          ),
                                          children: [
                                            _buildCell2(e.updatedAt, ''),
                                            _buildCell(e.expenseName),
                                            _buildCell(
                                              e.expenseAmount.toString(),
                                            ),
                                            _buildCell(e.expenseType),
                                            _buildCell(e.note),
                                            // TagsCellWidget(initialTags: currentTags),
                                            _buildCell(e.editBy),
                                            _buildActionCell(
                                              onEdit: () async {
                                                final result =
                                                    await showUnifiedOfficeExpenseDialog(
                                                      context,
                                                      expenseData: {
                                                        "tid": e.tid,
                                                        "expense_type":
                                                            e.expenseType,
                                                        "expense_name":
                                                            e.expenseName,
                                                        "expense_amount":
                                                            e.expenseAmount,
                                                        "note": e.note,
                                                        "tag": e.tag,
                                                        "payment_status":
                                                            e.paymentStatus,
                                                        "allocated_amount":
                                                            e.allocatedAmount,
                                                        "pay_by_manager":
                                                            e.payByManager,
                                                        "received_by_person":
                                                            e.receivedByPerson,
                                                        "service_tid":
                                                            e.serviceTid,
                                                        "payment_type":
                                                            e.paymentType,
                                                        "bank_ref_id":
                                                            e.bankRefId,
                                                        "expense_date":
                                                            e.expenseDate,
                                                      },
                                                      isEditMode: true,
                                                    );

                                                if (result == true) {
                                                  Provider.of<ExpenseProvider>(
                                                    context,
                                                    listen: false,
                                                  ).fetchExpenses();
                                                }
                                              },
                                              onDelete: () async {
                                                final expenseProvider =
                                                    Provider.of<
                                                      ExpenseProvider
                                                    >(context, listen: false);

                                                // Reset before new delete
                                                expenseProvider.resetState();

                                                await expenseProvider
                                                    .deleteExpense(e.tid);

                                                if (expenseProvider.state ==
                                                    RequestState.success) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        expenseProvider
                                                                .deleteResponse
                                                                ?.message ??
                                                            "Expense deleted successfully",
                                                      ),
                                                    ),
                                                  );

                                                  // Refresh list
                                                  expenseProvider
                                                      .fetchExpenses();
                                                } else if (expenseProvider
                                                        .state ==
                                                    RequestState.error) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        expenseProvider
                                                                .errorMessage ??
                                                            "Delete failed",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      }),
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
                ),
              ],
            ),
          ),
        );
      },
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
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        /*IconButton(
          icon: const Icon(Icons.delete, size: 20, color: AppColors.redColor),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),*/
        /* IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: AppColors.redColor,
          ),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        )*/
      ],
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
            color: AppColors.redColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
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
                  child: const Icon(Icons.close, size: 12, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
