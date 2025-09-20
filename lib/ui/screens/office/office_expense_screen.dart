import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../expense/delete_expense_provider.dart';
import '../../../expense/expense_provider.dart';
import '../../../utils/request_state.dart' show RequestState;
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/tags_class.dart';
import 'dialogues/dialogue_edit_expense.dart';

class OfficeExpenseScreen extends StatefulWidget {
  const OfficeExpenseScreen({super.key});

  @override
  State<OfficeExpenseScreen> createState() => _OfficeExpenseScreenState();
}

class _OfficeExpenseScreenState extends State<OfficeExpenseScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<ExpensesProvider>(context, listen: false).fetchExpenses();
    });
    super.initState();
  }

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];
  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  final List<Map<String, dynamic>> stats = [
    {'label': 'Revenue', 'value': '25K'},
    {'label': 'Users', 'value': '1.2K'},
    {'label': 'Orders', 'value': '320'},
    {'label': 'Visits', 'value': '8.5K'},
    {'label': 'Returns', 'value': '102'},
  ];

  DateTime selectedDateTime = DateTime.now();

  final List<String> categories = ['All', 'New', 'Pending', 'Completed', 'Stop'];
  String? selectedCategory;
  final List<String> categories1 = ['No Tags', 'Tag 001', 'Tag 002', 'Sample Tag'];
  String? selectedCategory1;
  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;
  final List<String> categories3 = ['All', 'Toady', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expensesProvider, child) {
        if (expensesProvider.state == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (expensesProvider.state == RequestState.error) {
          return Center(child: Text(expensesProvider.errorMessage ?? "Error"));
        }

        if (expensesProvider.expenses.isEmpty) {
          return const Center(child: Text("No expenses found"));
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
                    children:
                        stats.map((stat) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Material(
                                elevation: 12,
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white70,
                                shadowColor: Colors.black,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          stat['value'],
                                          style: const TextStyle(
                                            fontSize: 28,
                                            color: Colors.white,
                                            fontFamily: 'Courier',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FittedBox(child: Text(stat['label'], style: const TextStyle(fontSize: 14, color: Colors.white))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
                      boxShadow: _isHovering ? [BoxShadow(color: Colors.blue, blurRadius: 4, spreadRadius: 0.2, offset: const Offset(0, 1))] : [],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CustomDropdown(
                                  hintText: "Customer Type",
                                  selectedValue: selectedCategory,
                                  items: categories,
                                  onChanged: (newValue) {
                                    setState(() => selectedCategory = newValue!);
                                  },
                                ),
                                CustomDropdown(
                                  hintText: "Select Tags",
                                  selectedValue: selectedCategory1,
                                  items: categories1,
                                  onChanged: (newValue) {
                                    setState(() => selectedCategory1 = newValue!);
                                  },
                                ),
                                CustomDropdown(
                                  hintText: "Payment Status",
                                  selectedValue: selectedCategory2,
                                  items: categories2,
                                  onChanged: (newValue) {
                                    setState(() => selectedCategory2 = newValue!);
                                  },
                                ),
                              ],
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
                                  minWidth: MediaQuery.of(context).size.width, // dynamic width
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  controller: _verticalController,
                                  child: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(0.8),
                                      1: FlexColumnWidth(1.5),
                                      2: FlexColumnWidth(1.5),
                                      3: FlexColumnWidth(1.4),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(1),
                                      6: FlexColumnWidth(1),
                                      7: FlexColumnWidth(1),
                                    },
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(color: Colors.red.shade50),
                                        children: [
                                          _buildHeader("Date"),
                                          _buildHeader("Name"),
                                          _buildHeader("Amount"),
                                          _buildHeader("Type"),
                                          _buildHeader("Note"),
                                          _buildHeader("Tags"),
                                          _buildHeader("Manage"),
                                          _buildHeader("Action"),
                                        ],
                                      ),
                                      // Sample Data Rows
                                      ...expensesProvider.expenses.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final e = entry.value;
                                        return TableRow(
                                          decoration: BoxDecoration(color: index.isEven ? Colors.grey.shade200 : Colors.grey.shade100),
                                          children: [
                                            _buildCell2(e.updatedAt, ''),
                                            _buildCell(e.expenseName),
                                            _buildCell(e.expenseAmount.toString()),
                                            _buildCell(e.expenseType),
                                            _buildCell(e.note),
                                            TagsCellWidget(initialTags: currentTags),
                                            _buildCell(e.editBy),
                                            _buildActionCell(
                                              onEdit: () async {
                                                final result = await showDialog(
                                                  context: context,
                                                  builder:
                                                      (_) => DialogueEditOfficeExpense(
                                                        expenseData: {
                                                          "tid": e.tid,
                                                          "expense_type": e.expenseType,
                                                          "expense_name": e.expenseName,
                                                          "expense_amount": e.expenseAmount,
                                                          "note": e.note,
                                                          "tag": e.tag,
                                                          "payment_status": e.paymentStatus,
                                                          "allocated_amount": e.allocatedAmount, // 👈 ye add karna hai
                                                          "allocated_amount": e.allocatedAmount, // 👈 ye add karna hai
                                                        },
                                                      ),
                                                );

                                                if (result == true) {
                                                  Provider.of<ExpensesProvider>(context, listen: false).fetchExpenses();
                                                }
                                              },
                                              onDelete: () async {
                                                final deleteProvider = Provider.of<DeleteExpenseProvider>(context, listen: false);

                                                final expenseProvider = Provider.of<ExpensesProvider>(context, listen: false);

                                                // Reset before new delete
                                                deleteProvider.reset();

                                                await deleteProvider.deleteExpense(e.tid);

                                                if (deleteProvider.state == RequestState.success) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(deleteProvider.response?.message ?? "Expense deleted successfully")),
                                                  );

                                                  // Refresh list
                                                  expenseProvider.fetchExpenses();
                                                } else if (deleteProvider.state == RequestState.error) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(SnackBar(content: Text(deleteProvider.response?.message ?? "Delete failed")));
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
          Flexible(child: Text(text, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
              },
              child: Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.copy, size: 12, color: Colors.blue[700])),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.edit, size: 20, color: Colors.blue), tooltip: 'Edit', onPressed: onEdit ?? () {}),
        IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), tooltip: 'Delete', onPressed: onDelete ?? () {}),
        /* IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: Colors.red,
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
        child: Text(text, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
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
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: const EdgeInsets.only(left: 8.0), child: Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54))),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      child: Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.copy, size: 14, color: Colors.blue[700])),
                    ),
                ],
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54))),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      child: Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.copy, size: 8, color: Colors.blue[700])),
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

  const _HoverableTag({Key? key, required this.tag, required this.color, required this.onDelete}) : super(key: key);

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
            decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(12)),
            child: Text(widget.tag, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 12)),
          ),
          if (_hovering)
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(onTap: widget.onDelete, child: Container(child: const Icon(Icons.close, size: 12, color: Colors.black))),
            ),
        ],
      ),
    );
  }
}
