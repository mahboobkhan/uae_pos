import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../providers/expense_provider.dart';
import '../../../providers/designation_delete_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import '../banking/banking_dialoges/unified_office_expense_dialog.dart';

class OfficeMiscellaneous extends StatefulWidget {
  const OfficeMiscellaneous({super.key});

  @override
  State<OfficeMiscellaneous> createState() => _OfficeMiscellaneousState();
}

class _OfficeMiscellaneousState extends State<OfficeMiscellaneous> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;
  DateTime selectedDateTime = DateTime.now();

  /*
  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
*/
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses(expenseType: 'Miscellaneous Office Expense');
    });
    super.initState();
  }

  final List<String> categories = ['All', 'New', 'Pending', 'Completed', 'Stop'];
  String? selectedCategory;
  final List<String> categories1 = ['No Tags', 'Tag 001', 'Tag 002', 'Sample Tag'];
  String? selectedCategory1;
  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;
  final List<String> categories3 = ['All', 'Toady', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];

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
                              /*  CustomDropdown(
                                hintText: "Customer Type",
                                selectedValue: selectedCategory,
                                items: categories,
                                onChanged: (newValue) {
                                  setState(() => selectedCategory = newValue!);
                                },
                              ),*/
                              /*CustomDropdown(
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
                              ),*/
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
                              Provider.of<ExpenseProvider>(context, listen: false)
                                  .fetchExpenses(expenseType: 'Miscellaneous Office Expense');
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  height: 370,
                  child: Consumer<ExpenseProvider>(
                    builder: (context, provider, child) {
                      if (provider.state == RequestState.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.state == RequestState.error) {
                        return Center(child: Text(provider.errorMessage ?? "Error"));
                      }

                      if (provider.expenses.isEmpty) {
                        return const Center(child: Text("No expenses found"));
                      }

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
                                  constraints: const BoxConstraints(minWidth: 1150),
                                  child: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(1),
                                      // 6: FlexColumnWidth(1),
                                    },
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(color: Colors.red.shade50),
                                        children: [
                                          _buildHeader("TID"),
                                          _buildHeader("Expenses Value"),
                                          // _buildHeader("Drop Down Tag"),
                                          _buildHeader("Payment Status"),
                                          _buildHeader("Allocate"),
                                          _buildHeader("Note"),
                                          _buildHeader("Other"),
                                        ],
                                      ),
                                      // Dynamic Rows
                                      ...provider.expenses.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final e = entry.value;
                                        return TableRow(
                                          decoration: BoxDecoration(
                                            color: index.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                          ),
                                          children: [
                                            _buildCell2(e.expenseType, e.tid, copyable: true),
                                            _buildCell(e.expenseAmount.toString()),
                                            // _buildCell('nil'),
                                            _buildCell(e.paymentStatus),
                                            _buildCell(e.allocatedAmount.toString()),
                                            _buildCell(e.note),
                                            _buildActionCell(
                                              onDelete: () async {
                                                final expenseProvider = Provider.of<ExpenseProvider>(
                                                  context,
                                                  listen: false,
                                                );

                                                // Reset before new delete
                                                expenseProvider.resetState();

                                                await expenseProvider.deleteExpense(e.tid);

                                                if (expenseProvider.state == RequestState.success) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        expenseProvider.response?.message ??
                                                            "Expense deleted successfully",
                                                      ),
                                                    ),
                                                  );

                                                  // Refresh list
                                                  expenseProvider.fetchExpenses(
                                                    expenseType: 'Miscellaneous Office Expense',
                                                  );
                                                } else if (expenseProvider.state == RequestState.error) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        expenseProvider.response?.message ?? "Delete failed",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              onEdit: () async {
                                                final result = await showUnifiedOfficeExpenseDialog(
                                                  context,
                                                  expenseData: {
                                                    "tid": e.tid,
                                                    "expense_type": e.expenseType,
                                                    "expense_name": e.expenseName,
                                                    "expense_amount": e.expenseAmount,
                                                    "note": e.note,
                                                    "tag": e.tag,
                                                    "payment_status": e.paymentStatus,
                                                    "allocated_amount": e.allocatedAmount,
                                                    "pay_by_manager": e.payByManager,
                                                    "received_by_person": e.receivedByPerson,
                                                    "service_tid": e.serviceTid,
                                                    "payment_type": e.paymentType,
                                                    "bank_ref_id": e.bankRefId,
                                                    "expense_date": e.expenseDate,
                                                  },
                                                  isEditMode: true,
                                                );

                                                if (result == true) {
                                                  Provider.of<ExpenseProvider>(
                                                    context,
                                                    listen: false,
                                                  ).fetchExpenses(expenseType: 'Miscellaneous Office Expense');
                                                }
                                              },
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
                    },
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
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
          icon: const Icon(Icons.delete, size: 20, color: Colors.blue),
          tooltip: 'delete',
          onPressed: onDelete ?? () {},
        ),*/
      ],
    );
  }
}
