import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:abc_consultant/ui/dialogs/tags_class.dart';
import 'package:abc_consultant/ui/screens/projects/create_order_dialog.dart';
import 'package:abc_consultant/ui/screens/projects/create_order_screen.dart';
import 'package:abc_consultant/providers/projects_provider.dart';
import 'package:abc_consultant/providers/short_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dialogs/custom_fields.dart';
import '../../dialogs/date_picker.dart';

class ProjectScreen extends StatefulWidget {
  final VoidCallback onNavigateToCreateOrder;

  const ProjectScreen({super.key, required this.onNavigateToCreateOrder});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectsProvider = context.read<ProjectsProvider>();
      projectsProvider.getCombinedProjectsAndShortServices();
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

  List<Map<String, dynamic>> getStats(ProjectsProvider provider) {
    final summary = provider.summaryData;
    if (summary != null) {
      return [
        {'label': 'Short Services', 'value': summary['total_short_services']?.toString() ?? '0'},
        {'label': 'New Projects', 'value': summary['new_projects']?.toString() ?? '0'},
        {'label': 'In Progress', 'value': summary['in_progress_projects']?.toString() ?? '0'},
        {'label': 'Completed', 'value': summary['completed_projects']?.toString() ?? '0'},
        {'label': 'Stop Project', 'value': summary['stopped_projects']?.toString() ?? '0'},
      ];
    }
    return [
      {'label': 'Short Services', 'value': '0'},
      {'label': 'New Projects', 'value': '0'},
      {'label': 'In Progress', 'value': '0'},
      {'label': 'Completed', 'value': '0'},
      {'label': 'Stop Project', 'value': '0'},
    ];
  }

  final List<String> categories = ['All', 'New', 'In Progress', 'Completed', 'Stop'];
  String? selectedCategory;

  final List<String> categories1 = ['No Tags', 'Tag 001', 'Tag 002', 'Sample Tag'];
  String? selectedCategory1;

  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;

  final List<String> categories3 = ['All', 'Toady', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];
  String? selectedCategory3;

  final List<String> categories4 = ['Services Project', 'Short Services'];
  String selectedCategory4 = '';

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  void _clearFilters(ProjectsProvider provider) {
    setState(() {
      selectedCategory = null;
      selectedCategory1 = null;
      selectedCategory2 = null;
      selectedCategory3 = null;
    });
    provider.clearFilters();
    provider.getCombinedProjectsAndShortServices();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsProvider>(
      builder: (context, projectsProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: RefreshIndicator(
            onRefresh: () async {
              await projectsProvider.getCombinedProjectsAndShortServices();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Row(
                        children:
                            getStats(projectsProvider).map((stat) {
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
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
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
                                          FittedBox(
                                            fit: BoxFit.scaleDown,

                                            child: Text(
                                              stat['label'],
                                              style: const TextStyle(fontSize: 14, color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                        projectsProvider.setFilters(status: newValue);
                                        projectsProvider.getCombinedProjectsAndShortServices();
                                      },
                                    ),
                                    /*CustomDropdown(
                                      selectedValue: selectedCategory1,
                                      hintText: "Select Tags",
                                      items: categories1,
                                      onChanged: (newValue) {
                                        setState(() => selectedCategory1 = newValue!);
                                      },
                                    ),*/
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
                                          final selectedRange = await showDateRangePickerDialog(context);

                                          if (selectedRange != null) {
                                            final start = selectedRange.startDate ?? DateTime.now();
                                            final end = selectedRange.endDate ?? start;

                                            final formattedRange =
                                                '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';

                                            setState(() {
                                              selectedCategory3 = formattedRange;
                                            });

                                            // Update filters with date range
                                            projectsProvider.setFilters(
                                              startDate: DateFormat('yyyy-MM-dd').format(start),
                                              endDate: DateFormat('yyyy-MM-dd').format(end),
                                            );
                                            projectsProvider.getCombinedProjectsAndShortServices();
                                          }
                                        } else {
                                          setState(() => selectedCategory3 = newValue!);
                                          // Clear date filters for non-custom ranges
                                          projectsProvider.setFilters(startDate: null, endDate: null);
                                          projectsProvider.getCombinedProjectsAndShortServices();
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
                                      onTap: () => _clearFilters(projectsProvider),
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
                                      onTap: () => projectsProvider.getCombinedProjectsAndShortServices(),
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
                                /*Card(
                                  elevation: 8,
                                  color: Colors.blue,
                                  shape: CircleBorder(),
                                  child: Builder(
                                    builder:
                                        (context) => Tooltip(
                                          message: 'Show menu',
                                          waitDuration: Duration(milliseconds: 2),
                                          child: GestureDetector(
                                            key: _plusKey,
                                            onTap: () async {
                                              final RenderBox renderBox =
                                                  _plusKey.currentContext!.findRenderObject() as RenderBox;
                                              final Offset offset = renderBox.localToGlobal(Offset.zero);

                                              final selected = await showMenu<String>(
                                                context: context,
                                                position: RelativeRect.fromLTRB(
                                                  offset.dx - 120,
                                                  offset.dy + renderBox.size.height,
                                                  offset.dx,
                                                  offset.dy,
                                                ),
                                                items: [
                                                  const PopupMenuItem<String>(
                                                    value: 'Short Services',
                                                    child: Text('Short Services'),
                                                  ),
                                                  const PopupMenuItem<String>(
                                                    value: 'Add Services',
                                                    child: Text('Add Services'),
                                                  ),
                                                ],
                                              );

                                              if (selected != null) {
                                                setState(() => selectedCategory4 = selected);
                                                if (selected == 'Add Services') {
                                                  showShortServicesPopup(context);
                                                } else if (selected == 'Short Services') {
                                                  showServicesProjectPopup(context);
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              margin: const EdgeInsets.symmetric(horizontal: 10),
                                              decoration: const BoxDecoration(shape: BoxShape.circle),
                                              child: const Center(
                                                child: Icon(Icons.add, color: Colors.white, size: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
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
                                        showDialog(context: context, builder: (context) => CreateOrderDialog());
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: const Center(
                                          child: Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),*/
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: 300,
                        child:
                            projectsProvider.isLoading
                                ? Center(child: CircularProgressIndicator())
                                : ScrollbarTheme(
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
                                            constraints: const BoxConstraints(minWidth: 1250),
                                            child: Table(
                                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                              columnWidths: const {
                                                0: FlexColumnWidth(1),
                                                1: FlexColumnWidth(1.5),
                                                2: FlexColumnWidth(1),
                                                3: FlexColumnWidth(1.5),
                                                4: FlexColumnWidth(1),
                                                5: FlexColumnWidth(1.3),
                                                6: FlexColumnWidth(1.3),
                                                7: FlexColumnWidth(1.3),
                                                8: FlexColumnWidth(1.3),
                                                9: FlexColumnWidth(1),
                                                10: FlexColumnWidth(1.4),
                                              },
                                              children: [
                                                TableRow(
                                                  decoration: BoxDecoration(color: Colors.red.shade50),
                                                  children: [
                                                    _buildHeader("Date"),
                                                    _buildHeader("Ref Id"),
                                                    _buildHeader("Type"),
                                                    _buildHeader("Client"),
                                                    _buildHeader("Status"),
                                                    _buildHeader("Stage"),
                                                    _buildHeader("Pending"),
                                                    _buildHeader("Quotation"),
                                                    _buildHeader("Steps Cost"),
                                                    _buildHeader("Manage"),
                                                    _buildHeader("More Actions"),
                                                  ],
                                                ),
                                                if (projectsProvider.combinedData.isEmpty)
                                                  TableRow(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        child: Center(child: Text("No data available")),
                                                      ),
                                                      for (int i = 1; i < 11; i++) Container(height: 50),
                                                    ],
                                                  )
                                                else
                                                  for (int i = 0; i < projectsProvider.combinedData.length; i++)
                                                    _buildDataRow(projectsProvider.combinedData[i], i),
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
          ),
        );
      },
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
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
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

  Widget _buildPriceWithAdd(String curr, String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(curr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          Text(price, style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
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
              Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54)),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
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

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete, VoidCallback? onDraft}) {
    return Row(
      children: [
        // IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), tooltip: 'Delete', onPressed: onDelete ?? () {}),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        /*IconButton(
          icon: Image.asset('assets/icons/img_3.png', width: 20, height: 20, color: Colors.blue),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),*/
      ],
    );
  }

  String getDaysDifference(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '0-days';
    try {
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(createdDate);
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      if (days == 0) {
        if (hours == 0) {
          return 'Today';
        } else {
          return '${hours}h ago';
        }
      } else if (days == 1) {
        return 'Yesterday';
      } else {
        return '$days-days';
      }
    } catch (e) {
      return '0-days';
    }
  }

  String getTotalStepsCost(Map<String, dynamic> project) {
    if (project['stage_totals'] != null && project['stage_totals']['total_step_cost'] != null) {
      return project['stage_totals']['total_step_cost'].toString();
    }
    return '0.00';
  }

  String calculatePendingPayment(Map<String, dynamic> project) {
    final double quotationAmount = double.tryParse(project['quotation']?.toString() ?? '0') ?? 0;
    final double paidAmount = double.tryParse(project['paid_payment']?.toString() ?? '0') ?? 0;

    double totalStepsCost = 0.0;
    if (project['stage_totals'] != null && project['stage_totals']['total_step_cost'] != null) {
      totalStepsCost = double.tryParse(project['stage_totals']['total_step_cost'].toString()) ?? 0.0;
    }

    final double totalAmount = quotationAmount > totalStepsCost ? quotationAmount : totalStepsCost;
    final double remaining = totalAmount - paidAmount;

    return remaining.toStringAsFixed(2);
  }

  TableRow _buildDataRow(Map<String, dynamic> item, int index) {
    final isProject = item['type'] == 'project';
    final isEven = index.isEven;

    String date = '';
    String time = '';
    String clientName = '';
    String clientDetails = '';
    String status = '';
    String stageMain = '';
    String stageSub = '';
    String pendingAmount = '';
    String quotationAmount = '';
    String stepsCost = '';
    String managerName = '';
    String refId = '';
    String typeLabel = '';

    if (isProject) {
      // Project data structure
      final createdAt = DateTime.tryParse(item['created_at'] ?? '');
      date = createdAt != null ? DateFormat('dd-MM-yyyy').format(createdAt) : '';
      time = createdAt != null ? DateFormat('hh:mm a').format(createdAt) : '';

      final client = item['client_id'];
      clientName = client['name'] ?? '';
      clientDetails = client['client_ref_id'] ?? '';

      status = item['status'] ?? '';
      stageMain =
          item['stage_totals'] != null ? (item['stage_totals']['latest_stage_ref_id']?.toString() ?? 'N/A') : 'N/A';
      stageSub = getDaysDifference(item['created_at']);
      typeLabel = 'Project';

      pendingAmount = calculatePendingPayment(item);
      quotationAmount = item['quotation'] ?? '0';
      stepsCost = getTotalStepsCost(item);

      final user = item['user_id'];
      managerName = user['name'] ?? '';
      refId = item['project_ref_id'] ?? '';
    } else {
      // Short service data structure
      final createdAt = DateTime.tryParse(item['created_at'] ?? '');
      date = createdAt != null ? DateFormat('dd-MM-yyyy').format(createdAt) : '';
      time = createdAt != null ? DateFormat('hh:mm a').format(createdAt) : '';

      clientName = item['client_name'] ?? '';
      clientDetails = item['ref_id'] ?? '';

      status = 'Completed'; // Short services are typically completed
      stageMain = 'Short Service';
      stageSub = '';
      typeLabel = 'Short Service';

      pendingAmount = '0.00'; // Short services are usually paid upfront
      quotationAmount = item['cost'] ?? '0';
      stepsCost = 'N/A';

      managerName = item['manager_name'] ?? '';
      refId = item['ref_id'] ?? '';
    }
    return TableRow(
      decoration: BoxDecoration(color: isEven ? Colors.grey.shade200 : Colors.grey.shade100),
      children: [
        _buildCell2(date, time, centerText2: true),
        _buildCell(refId, copyable: true),
        _buildCell(typeLabel),
        _buildCell3(clientName, clientDetails, copyable: true),
        _buildCell(status),
        _buildCell2(stageMain, stageSub.isEmpty ? ' ' : stageSub),
        _buildPriceWithAdd("AED-", pendingAmount),
        _buildPriceWithAdd("AED-", quotationAmount),
        isProject ? _buildPriceWithAdd("AED-", stepsCost) : _buildCell('N/A'),
        _buildCell(managerName),
        _buildActionCell(
          onEdit: () {
            if (isProject) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrderScreen(projectData: item)));
            } else {
              _editShortService(context, item);
            }
          },
          onDelete: () {
            showDialog<bool>(
              context: context,
              builder:
                  (context) => const ConfirmationDialog(
                    title: 'Confirm Deletion',
                    content: 'Are you sure you want to delete this?',
                    cancelText: 'Cancel',
                    confirmText: 'Delete',
                  ),
            ).then((shouldDelete) {
              if (shouldDelete == true) {
                // TODO: Implement delete functionality
                print("Item deleted: $refId");
              }
            });
          },
          onDraft: () {},
        ),
      ],
    );
  }

  /// Edit short service (reused from ShortServiceScreen)
  void _editShortService(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String clientName = service['client_name'] ?? '';
        String cost = service['cost'] ?? service['pending_payment'] ?? '';
        String managerName = service['manager_name'] ?? '';

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SizedBox(
            width: 400,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "EDIT SHORT SERVICE",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Ref ID: ${service['ref_id'] ?? 'N/A'}",
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField1(label: 'CLIENT NAME', text: clientName, onChanged: (val) => clientName = val),
                      const SizedBox(height: 12),
                      CustomTextField1(
                        label: 'COST (AED)',
                        keyboardType: TextInputType.number,
                        text: cost,
                        onChanged: (val) => cost = val,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField1(label: 'MANAGER NAME', text: managerName, onChanged: (val) => managerName = val),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () async {
                              if (clientName.isNotEmpty && cost.isNotEmpty && managerName.isNotEmpty) {
                                try {
                                  final provider = context.read<ShortServicesProvider>();
                                  await provider.updateShortService(
                                    refId: service['ref_id'],
                                    clientName: clientName,
                                    cost: cost,
                                    managerName: managerName,
                                  );

                                  if (provider.errorMessage == null) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(provider.successMessage ?? 'Service updated successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(provider.errorMessage!), backgroundColor: Colors.red),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                            child: const Text('Update', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 25, color: Colors.red),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
