import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/clipboard_utils.dart';
import 'company_profile.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../dialogs/date_picker.dart';
import 'individual_profile.dart';
import '../../dialogs/tags_class.dart';
import '../../dialogs/employee_list_dialog.dart';
import '../../../providers/client_profile_provider.dart';
import '../../../providers/client_organization_employee_provider.dart';

class ClientMain extends StatefulWidget {
  const ClientMain({super.key});

  @override
  State<ClientMain> createState() => _ClientMainState();
}

class _ClientMainState extends State<ClientMain> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final provider = context.read<ClientProfileProvider>();
        provider.clearFilters();
        provider.getAllClients();
      } catch (e) {
        // ignore provider lookup errors on early build
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
  bool _isHovering = false;
  String? customerValue;
  String? tagValue;
  String? paymentValue;
  String? dateValue;
  String? profileAddCategory;

  final List<String> categories = ['All', 'Individual', 'Organization'];
  String? selectedCategory;
  final List<String> categories1 = ['All', 'Regular', 'Walking'];
  String? selectedCategory1;

  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;
  final List<String> categories4 = ['Individual', 'Company'];
  String selectedCategory4 = '';

  final List<String> categories3 = ['All', 'Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];
  String? selectedCategory3;

  // Dynamic stats will be generated from clientsSummary data

  bool _isOrganization(String? type) {
    final t = (type ?? '').toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    // handles "Organization", "Organisation", "Company", "Org", etc.
    return t == 'organization' || t == 'organisation' || t == 'company' || t == 'org';
  }

  // Apply filters to the clients
  void _applyFilters() {
    final clientProvider = context.read<ClientProfileProvider>();

    // Convert UI filter values to API parameters
    String? clientTypeFilter;
    String? typeFilter;
    String? startDateFilter;
    String? endDateFilter;

    // Client type filter
    if (selectedCategory != null && selectedCategory != 'All') {
      clientTypeFilter = selectedCategory!.toLowerCase();
    }

    // Type filter (Regular/Walking)
    if (selectedCategory1 != null && selectedCategory1 != 'All') {
      typeFilter = selectedCategory1!.toLowerCase();
    }

    // Date filter
    if (selectedCategory3 != null && selectedCategory3 != 'All') {
      final now = DateTime.now();
      switch (selectedCategory3) {
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
    clientProvider.setFilters(
      clientType: clientTypeFilter,
      type: typeFilter,
      startDate: startDateFilter,
      endDate: endDateFilter,
    );

    // Debug print
    print('=== UI FILTER DEBUG ===');
    print('Selected Category: $selectedCategory');
    print('Selected Category1: $selectedCategory1');
    print('Client Type Filter: $clientTypeFilter');
    print('Type Filter: $typeFilter');
    print('Start Date Filter: $startDateFilter');
    print('End Date Filter: $endDateFilter');
    print('======================');

    // Refresh clients with filters - API will handle the filtering
    clientProvider.getAllClients();
  }

  // Clear all filters
  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedCategory1 = null;
      selectedCategory2 = null;
      selectedCategory3 = null;
    });

    final clientProvider = context.read<ClientProfileProvider>();
    clientProvider.clearFilters();
    clientProvider.getAllClients();
  }

  // Get stats from clients summary
  List<Map<String, dynamic>> _getStatsFromSummary(Map<String, dynamic>? summary) {
    if (summary == null) {
      return [
        {'label': 'Total Clients', 'value': '0'},
        {'label': 'Individual', 'value': '0'},
        {'label': 'Organization', 'value': '0'},
        {'label': 'Pending Amount', 'value': 'AED 0.00'},
        {'label': 'Received Amount', 'value': 'AED 0.00'},
      ];
    }

    return [
      {'label': 'Total Clients', 'value': summary['total_clients']?.toString() ?? '0'},
      {'label': 'Individual', 'value': summary['total_individual']?.toString() ?? '0'},
      {'label': 'Organization', 'value': summary['total_organization']?.toString() ?? '0'},
      {'label': 'Pending Amount', 'value': 'AED ${summary['total_pending_amount']?.toString() ?? '0.00'}'},
      {'label': 'Received Amount', 'value': 'AED ${summary['total_received_amount']?.toString() ?? '0.00'}'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final clientProvider = context.watch<ClientProfileProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---- Stats Boxes ----
              SizedBox(
                height: 120,
                child: Row(
                  children:
                      _getStatsFromSummary(clientProvider.clientsSummary).map((stat) {
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

              /// ---- Filters Row ----
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
                            ? [BoxShadow(color: Colors.blue, blurRadius: 4, spreadRadius: 0.1, offset: Offset(0, 1))]
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
                                hintText: "Client Type",
                                items: categories,
                                onChanged: (newValue) {
                                  setState(() => selectedCategory = newValue!);
                                  _applyFilters();
                                },
                              ),
                              CustomDropdown(
                                selectedValue: selectedCategory1,
                                hintText: "Type",
                                items: categories1,
                                onChanged: (newValue) {
                                  setState(() => selectedCategory1 = newValue!);
                                  _applyFilters();
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
                                    final selectedRange = await showDateRangePickerDialog(context);

                                    if (selectedRange != null) {
                                      final start = selectedRange.startDate ?? DateTime.now();
                                      final end = selectedRange.endDate ?? start;

                                      final formattedRange =
                                          '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';

                                      setState(() {
                                        selectedCategory3 = formattedRange;
                                      });

                                      // Apply custom date range filter
                                      final clientProvider = context.read<ClientProfileProvider>();
                                      clientProvider.setFilters(
                                        startDate: DateFormat('yyyy-MM-dd').format(start),
                                        endDate: DateFormat('yyyy-MM-dd').format(end),
                                      );
                                      // API will handle the filtering
                                      clientProvider.getAllClients();
                                    }
                                  } else {
                                    setState(() => selectedCategory3 = newValue!);
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
                                  clientProvider.getAllClients();
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
                          // Add Client Button
                          Card(
                            elevation: 8,
                            color: Colors.blue,
                            shape: CircleBorder(),
                            child: Builder(
                              builder:
                                  (context) => Tooltip(
                                    message: 'Add Client',
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
                                            offset.dx,
                                            offset.dy + renderBox.size.height,
                                            offset.dx + 30,
                                            offset.dy,
                                          ),
                                          items: [
                                            const PopupMenuItem<String>(value: 'Company', child: Text('Company')),
                                            const PopupMenuItem<String>(value: 'Individual', child: Text('Individual')),
                                          ],
                                        );

                                        if (selected != null) {
                                          setState(() => selectedCategory4 = selected);

                                          if (selected == 'Company') {
                                            await showCompanyProfileDialog(context);
                                          } else if (selected == 'Individual') {
                                            await showIndividualProfileDialog(context);
                                          }
                                          try {
                                            await context.read<ClientProfileProvider>().getAllClients();
                                          } catch (_) {}
                                        }
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                        child: const Center(child: Icon(Icons.add, color: Colors.white, size: 20)),
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

              /// ---- Table Data ----
              if (clientProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (clientProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(child: Text(clientProvider.errorMessage!, style: TextStyle(color: Colors.red))),
                        IconButton(
                          onPressed: () => clientProvider.clearMessages(),
                          icon: Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )
              else if (clientProvider.successMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(child: Text(clientProvider.successMessage!, style: TextStyle(color: Colors.green))),
                        IconButton(
                          onPressed: () => clientProvider.clearMessages(),
                          icon: Icon(Icons.close, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
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
                              constraints: const BoxConstraints(minWidth: 1150),

                              child: Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(0.8),
                                  1: FlexColumnWidth(0.8),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(1),
                                  6: FlexColumnWidth(0.7),
                                },
                                children: [
                                  // Header Row
                                  TableRow(
                                    decoration: BoxDecoration(color: Colors.red.shade50),
                                    children: [
                                      _buildHeader("Client Type"),
                                      _buildHeader("Customer Ref I'd"),
                                      // _buildHeader("Tag Details"),
                                      _buildHeader("Number/Email"),
                                      _buildHeader("Project Status"),
                                      _buildHeader("Payment Pending"),
                                      _buildHeader("Total Received"),
                                      _buildHeader("Other Actions"),
                                    ],
                                  ),
                                  if (clientProvider.filteredClients.isNotEmpty)
                                    ...clientProvider.filteredClients.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final client = entry.value;
                                      /*       final List<dynamic> tagList = (client['tags'] is List) ? client['tags'] : [];
                                      final tagsForWidget =
                                          tagList
                                              .map((t) => {'tag': t.toString(), 'color': Colors.green.shade100})
                                              .toList();*/
                                      return TableRow(
                                        decoration: BoxDecoration(
                                          color: index.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                        ),
                                        children: [
                                          _buildCell(
                                            (client['client_type'] ?? '').toString().isEmpty
                                                ? 'N/A'
                                                : ClipboardUtils.capitalizeFirstLetter(
                                                  client['client_type'].toString(),
                                                ),
                                          ),
                                          _buildCell3(
                                            client['name']?.toString() ?? 'N/A',
                                            client['client_ref_id']?.toString() ?? 'N/A',
                                            copyable: true,
                                          ),
                                          /*TagsCellWidget(
                                            initialTags: tagsForWidget.isNotEmpty ? tagsForWidget : currentTags,
                                          ),*/
                                          _buildCell3(
                                            client['phone1']?.toString() ?? 'N/A',
                                            client['email']?.toString() ?? 'N/A',
                                            copyable: true,
                                          ),
                                          // _buildCell((client['phone1'] ?? client['email'] ?? 'N/A').toString()),
                                          _buildCell(client['project_stats']['project_status'] ?? 'N/A'),
                                          _buildPriceWithAdd(
                                            'AED-',
                                            client['project_stats']['pending_amount'] ?? 'N/A',
                                          ),
                                          _buildPriceWithAdd('AED-', client['project_stats']['paid_amount'] ?? 'N/A'),
                                          _buildActionCell(
                                            onEdit: () async {
                                              final type = (client['client_type'] as String?)?.toLowerCase() ?? '';
                                              final isIndividual =
                                                  type == 'individual' || type == 'individual'; // typo-safe

                                              if (isIndividual) {
                                                await showIndividualProfileDialog(context, clientData: client);
                                              } else {
                                                await showCompanyProfileDialog(context, clientData: client);
                                              }
                                            },
                                            onDelete: () async {
                                              final shouldDelete = await showDialog<bool>(
                                                context: context,
                                                builder:
                                                    (context) => const ConfirmationDialog(
                                                      title: 'Confirm Deletion',
                                                      content: 'Are you sure you want to delete this client?',
                                                      cancelText: 'Cancel',
                                                      confirmText: 'Delete',
                                                    ),
                                              );
                                              if (shouldDelete == true) {
                                                final ref = client['client_ref_id']?.toString();
                                                if (ref != null && ref.isNotEmpty) {
                                                  await context.read<ClientProfileProvider>().deleteClient(
                                                    clientRefId: ref,
                                                  );
                                                }
                                              }
                                            },
                                            onAddEmployee:
                                                _isOrganization(client['client_type']?.toString())
                                                    ? () async {
                                                      final clientRefId = client['client_ref_id']?.toString() ?? '';
                                                      final clientName = client['name']?.toString() ?? 'Unknown';
                                                      if (clientRefId.isNotEmpty) {
                                                        await showEmployeeListDialog(
                                                          context,
                                                          clientRefId: clientRefId,
                                                          clientName: clientName,
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Client reference ID not found'),
                                                            backgroundColor: Colors.red,
                                                          ),
                                                        );
                                                      }
                                                    }
                                                    : null, // not org -> hide button
                                          ),
                                        ],
                                      );
                                    }).toList()
                                  else
                                    TableRow(
                                      children: List.generate(
                                        7,
                                        (i) => TableCell(
                                          child: Container(
                                            height: 60,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.inbox_outlined, color: Colors.grey.shade400, size: 24),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'No clients found',
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
      ),
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
                      // You must call setState from the parent
                      (context as Element).markNeedsBuild(); // temporary refresh
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
                if (result != null && result['tag'].toString().trim().isNotEmpty) {
                  (context as Element).markNeedsBuild();
                  tags.add({'tag': result['tag'], 'color': result['color']});
                }
              },
              child: Image.asset(width: 14, height: 14, color: Colors.blue, 'assets/icons/img_1.png'),
            ),
          ),
        ],
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
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCell3(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8),
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
                    Clipboard.setData(ClipboardData(text: text2));
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

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete, VoidCallback? onAddEmployee}) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        // IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), tooltip: 'Delete', onPressed: onDelete ?? () {}),
        if (onAddEmployee != null)
          IconButton(
            icon: Icon(Icons.people, color: Colors.green),
            tooltip: 'Add Employee',
            onPressed: onAddEmployee, // no fallback empty closure
          ),
      ],
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
            child: Text(
              widget.tag,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          if (_hovering)
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: widget.onDelete,
                child: Container(child: const Icon(Icons.close, size: 12, color: Colors.black)),
              ),
            ),
        ],
      ),
    );
  }
}
