import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/projects_provider.dart';
import '../../../providers/service_category_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../dialogs/date_picker.dart';
import '../../dialogs/tags_class.dart';
import 'create_order_dialog.dart';
import 'create_order_screen.dart';

class CreateOrders extends StatefulWidget {
  const CreateOrders({super.key});

  @override
  State<CreateOrders> createState() => _CreateOrdersState();
}

class _CreateOrdersState extends State<CreateOrders> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load projects and service categories when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Use Future.delayed to ensure the provider is fully initialized
        Future.delayed(Duration(milliseconds: 200), () {
          if (mounted) {
            try {
              final projectsProvider = context.read<ProjectsProvider>();
              final serviceCategoryProvider = context.read<ServiceCategoryProvider>();
              print('Providers found: ${projectsProvider.runtimeType}, ${serviceCategoryProvider.runtimeType}');
              projectsProvider.clearFilters();
              projectsProvider.getAllProjects();
              serviceCategoryProvider.getServiceCategories();
            } catch (e) {
              print('Error accessing providers: $e');
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

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];

  // Filter options
  final List<String> statusOptions = ['All', 'New', 'In Progress', 'Completed', 'Stop'];
  final List<String> paymentStatusOptions = ['All', 'Paid', 'Pending'];
  final List<String> dateOptions = ['All', 'Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];

  // Selected filter values
  String? selectedStatus;
  String? selectedTags;
  String? selectedPaymentStatus;
  String? selectedDateRange;

  final GlobalKey _plusKey = GlobalKey();
  bool _isHovering = false;

  // Get service names for filtering
  List<String> _getServiceNamesForFilter() {
    final provider = context.read<ServiceCategoryProvider>();
    return ['All'] + provider.serviceCategories.map((service) => service['service_name'].toString() ?? '').toList();
  }

  // Get service provider names for filtering
  List<String> _getServiceProviderNamesForFilter() {
    final provider = context.read<ServiceCategoryProvider>();
    return ['All'] +
        provider.serviceCategories.map((service) => service['service_provider_name'].toString() ?? '').toList();
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

  // Apply filters to the projects
  void _applyFilters() {
    final projectsProvider = context.read<ProjectsProvider>();

    // Convert UI filter values to API parameters
    String? statusFilter;
    String? serviceCategoryIdFilter;
    String? startDateFilter;
    String? endDateFilter;

    // Status filter
    if (selectedStatus != null && selectedStatus != 'All') {
      statusFilter = selectedStatus!.toLowerCase().replaceAll(' ', '-');
    }

    // Tags filter (using service category)
    if (selectedTags != null && selectedTags != 'All') {
      final serviceCategoryProvider = context.read<ServiceCategoryProvider>();
      final selectedService = serviceCategoryProvider.serviceCategories.firstWhere(
        (service) => service['service_name'] == selectedTags,
        orElse: () => {},
      );
      if (selectedService.isNotEmpty) {
        serviceCategoryIdFilter = selectedService['id']?.toString();
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
    projectsProvider.setFilters(
      status: statusFilter,
      serviceCategoryId: serviceCategoryIdFilter,
      startDate: startDateFilter,
      endDate: endDateFilter,
    );

    // Refresh projects with filters
    projectsProvider.getAllProjects();
  }

  // Clear all filters
  void _clearFilters() {
    setState(() {
      selectedStatus = null;
      selectedTags = null;
      selectedPaymentStatus = null;
      selectedDateRange = null;
    });

    final projectsProvider = context.read<ProjectsProvider>();
    projectsProvider.clearFilters();
    projectsProvider.getAllProjects();
  }

  String getDaysDifference(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '0-days';

    try {
      // Parse created_at from API (assuming format "YYYY-MM-DD HH:MM:SS")
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
      return '0-days'; // fallback if parsing fails
    }
  }

  /// Calculate remaining payment
  String calculateRemaining(String? quotation, String? paidPayment) {
    final double q = double.tryParse(quotation ?? '0') ?? 0;
    final double p = double.tryParse(paidPayment ?? '0') ?? 0;
    final double remaining = q - p;

    return remaining.toStringAsFixed(2); // Always 2 decimal places
  }

  /// Calculate pending payment using the larger value between quotation and total steps cost
  String calculatePendingPayment(Map<String, dynamic> project) {
    final double quotationAmount = double.tryParse(project['quotation']?.toString() ?? '0') ?? 0;
    final double paidAmount = double.tryParse(project['paid_payment']?.toString() ?? '0') ?? 0;

    // Get total steps cost from stage_totals if available
    double totalStepsCost = 0.0;
    if (project['stage_totals'] != null && project['stage_totals']['total_step_cost'] != null) {
      totalStepsCost = double.tryParse(project['stage_totals']['total_step_cost'].toString()) ?? 0.0;
    }

    // Use the larger value between quotation and total steps cost
    final double totalAmount = quotationAmount > totalStepsCost ? quotationAmount : totalStepsCost;
    final double remaining = totalAmount - paidAmount;

    return remaining.toStringAsFixed(2);
  }

  /// Get total steps cost from stage_totals
  String getTotalStepsCost(Map<String, dynamic> project) {
    if (project['stage_totals'] != null && project['stage_totals']['total_step_cost'] != null) {
      return project['stage_totals']['total_step_cost'].toString();
    }
    return '0.00';
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch to automatically rebuild when providers change
    final projectsProvider = context.watch<ProjectsProvider>();
    final serviceCategoryProvider = context.watch<ServiceCategoryProvider>();

    // Debug print to see if the providers are working
    print(
      'CreateOrders rebuild - isLoading: ${projectsProvider.isLoading}, dataCount: ${projectsProvider.projects.length}, error: ${projectsProvider.errorMessage}',
    );

    // If no data and not loading, try to load data
    if (projectsProvider.projects.isEmpty && !projectsProvider.isLoading && projectsProvider.errorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          print('No data found, attempting to load...');
          projectsProvider.getAllProjects();
        }
      });
    }

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
                            ? [BoxShadow(color: Colors.blue, blurRadius: 3, spreadRadius: 0.1, offset: Offset(0, 1))]
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
                                selectedValue: selectedStatus,
                                hintText: "Status",
                                items: statusOptions,
                                onChanged: (newValue) {
                                  setState(() => selectedStatus = newValue!);
                                  _applyFilters();
                                },
                              ),

                              // Payment Status Filter
                              CustomDropdown(
                                selectedValue: selectedPaymentStatus,
                                hintText: "Payment Status",
                                items: paymentStatusOptions,
                                onChanged: (newValue) {
                                  setState(() => selectedPaymentStatus = newValue!);
                                  // Note: Payment status filtering would need to be implemented in the backend
                                  // For now, we'll just update the UI state
                                },
                              ),
                              // Date Filter
                              CustomDropdown(
                                selectedValue: selectedDateRange,
                                hintText: "Dates",
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

                                      // Apply custom date range filter
                                      final projectsProvider = context.read<ProjectsProvider>();
                                      projectsProvider.setFilters(
                                        startDate: DateFormat('yyyy-MM-dd').format(start),
                                        endDate: DateFormat('yyyy-MM-dd').format(end),
                                      );
                                      projectsProvider.getAllProjects();
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
                                  projectsProvider.getAllProjects();
                                  serviceCategoryProvider.getServiceCategories();
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
                                  child: const Center(child: Icon(Icons.add, color: Colors.white, size: 16)),
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

              // Show loading indicator
              if (projectsProvider.isLoading || serviceCategoryProvider.isLoading)
                Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Loading data...')],
                    ),
                  ),
                )
              // Show error message
              else if (projectsProvider.errorMessage != null || serviceCategoryProvider.errorMessage != null)
                Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          projectsProvider.errorMessage ?? serviceCategoryProvider.errorMessage ?? 'An error occurred',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            projectsProvider.getAllProjects();
                            serviceCategoryProvider.getServiceCategories();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              // Show success message
              else if (projectsProvider.successMessage != null || serviceCategoryProvider.successMessage != null)
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
                          projectsProvider.successMessage ??
                              serviceCategoryProvider.successMessage ??
                              'Operation completed successfully',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.green),
                        onPressed: () {
                          projectsProvider.clearMessages();
                          serviceCategoryProvider.clearMessages();
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
                              constraints: const BoxConstraints(minWidth: 1250),
                              child: Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(0.8),
                                  1: FlexColumnWidth(1.5),
                                  2: FlexColumnWidth(1.5),
                                  3: FlexColumnWidth(1),
                                  // 4: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1.3),
                                  5: FlexColumnWidth(1),
                                  6: FlexColumnWidth(1),
                                  7: FlexColumnWidth(1),
                                  8: FlexColumnWidth(1),
                                  9: FlexColumnWidth(1.4),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(color: Colors.red.shade50),
                                    children: [
                                      _buildHeader("Date"),
                                      _buildHeader("Ref Id"),
                                      _buildHeader("Client"),
                                      // _buildHeader("Tags Details"),
                                      _buildHeader("Status"),
                                      _buildHeader("Stage"),
                                      _buildHeader("Pending"),
                                      _buildHeader("Quotation"),
                                      _buildHeader("Steps Cost"),
                                      _buildHeader("Assign Employee"),
                                      _buildHeader("More Actions"),
                                    ],
                                  ),
                                  if (projectsProvider.projects.isNotEmpty)
                                    ...projectsProvider.projects.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final project = entry.value;
                                      return TableRow(
                                        decoration: BoxDecoration(
                                          color: index.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                        ),
                                        children: [
                                          _buildCell2(
                                            _formatDate(project['created_at']),
                                            _formatTime(project['created_at']),
                                            centerText2: true,
                                          ),
                                          _buildCell(project['project_ref_id'] ?? 'N/A', copyable: true),

                                          _buildCell3(
                                            project['client_id']?['name'] ?? 'N/A',
                                            project['client_id']?['client_ref_id'] ?? 'N/A',
                                            copyable: true,
                                          ),
                                          // TagsCellWidget(initialTags: currentTags),
                                          _buildCell(project['status'] ?? 'N/A'),
                                          _buildCell2(
                                            project['stage_totals']['latest_stage_ref_id'] ?? 'N/A',
                                            getDaysDifference(project['created_at']),
                                          ),
                                          _buildPriceWithAdd("AED-", calculatePendingPayment(project)),
                                          _buildPriceWithAdd("AED-", project['quotation'] ?? '0'),
                                          _buildPriceWithAdd("AED-", getTotalStepsCost(project)),
                                          _buildCell(project['user_id']?['name'] ?? 'N/A'),
                                          _buildActionCell(
                                            onDelete: () => _deleteProject(context, project),
                                            onEdit: () => _editProject(context, project),
                                            onDraft: () {},
                                          ),
                                        ],
                                      );
                                    }).toList()
                                  else if (!projectsProvider.isLoading)
                                    TableRow(
                                      children: List.generate(
                                        10,
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
                                                    'No projects available',
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
          icon: Image.asset('assets/icons/img_3.png', width: 20, height: 20, color: Colors.blue),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),*/
      ],
    );
  }

  /// Edit project
  void _editProject(BuildContext context, Map<String, dynamic> project) {
    // Navigate to CreateOrderScreen with project data
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrderScreen(projectData: project)));
  }

  /// Delete project
  void _deleteProject(BuildContext context, Map<String, dynamic> project) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => const ConfirmationDialog(
            title: 'Confirm Deletion',
            content: 'Are you sure you want to delete this project?',
            cancelText: 'Cancel',
            confirmText: 'Delete',
          ),
    );

    if (shouldDelete == true) {
      final provider = context.read<ProjectsProvider>();
      await provider.deleteProject(projectRefId: project['project_ref_id']);
    }
  }
}
