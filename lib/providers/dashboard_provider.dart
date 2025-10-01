import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DashboardProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/dashboard";

  // Individual loading states for each chart
  bool isPaymentsLoading = false;
  bool isClientsLoading = false;
  bool isProjectsLoading = false;
  bool isExpensesLoading = false;
  bool isOverviewLoading = false;

  // Individual error messages for each chart
  String? paymentsErrorMessage;
  String? clientsErrorMessage;
  String? projectsErrorMessage;
  String? expensesErrorMessage;
  String? overviewErrorMessage;

  // Individual success messages for each chart
  String? paymentsSuccessMessage;
  String? clientsSuccessMessage;
  String? projectsSuccessMessage;
  String? expensesSuccessMessage;
  String? overviewSuccessMessage;

  // Dashboard Overview Data
  Map<String, dynamic>? dashboardStats;
  Map<String, dynamic>? overviewSummary;
  Map<String, dynamic>? overviewComparison;
  Map<String, dynamic>? overviewPeriodInfo;

  // Payments Chart Data
  List<Map<String, dynamic>> paymentsChartData = [];
  Map<String, dynamic>? paymentsChartSummary;
  Map<String, dynamic>? paymentsChartPeriodInfo;

  // Clients Chart Data
  List<Map<String, dynamic>> clientsChartData = [];
  Map<String, dynamic>? clientsChartSummary;
  Map<String, dynamic>? clientsChartPeriodInfo;

  // Projects Chart Data
  Map<String, dynamic>? projectsChartSummary;
  List<Map<String, dynamic>>? projectsStatusDistribution;
  Map<String, dynamic>? projectsFinancialSummary;
  Map<String, dynamic>? projectsPeriodInfo;
  List<Map<String, dynamic>> projectsDailyBreakdown = [];

  // Expenses Chart Data
  Map<String, dynamic>? expensesChartSummary;
  List<Map<String, dynamic>>? expensesTypeDistribution;
  List<Map<String, dynamic>>? expensesPaymentStatusDistribution;
  List<Map<String, dynamic>>? expensesPaymentTypeDistribution;
  Map<String, dynamic>? expensesPeriodInfo;
  List<Map<String, dynamic>> expensesDailyBreakdown = [];

  // Filter parameters for payments
  String? paymentsStartDate;
  String? paymentsEndDate;
  String? paymentsType;
  String? paymentsStatus;
  String? paymentsClientRef;
  String? paymentsMethod;

  // Filter parameters for clients
  String? clientsStartDate;
  String? clientsEndDate;
  String? clientsType;
  String? clientsWork;

  // Filter parameters for projects
  String? projectsStartDate;
  String? projectsEndDate;
  String? projectsClientId;
  String? projectsOrderType;
  String? projectsServiceCategoryId;
  String? projectsUserId;

  // Filter parameters for expenses
  String? expensesStartDate;
  String? expensesEndDate;
  String? expensesType;
  String? expensesPaymentStatus;
  String? expensesPaymentType;
  String? expensesManager;
  String? expensesTag;

  // Filter parameters for dashboard overview
  String? overviewStartDate;
  String? overviewEndDate;

  // Global loading state (only true when ALL are loading)
  bool get isLoading =>
      isPaymentsLoading || isClientsLoading || isProjectsLoading || isExpensesLoading || isOverviewLoading;

  /// ✅ Get Payments Chart Data
  Future<void> getPaymentsChartData() async {
    isPaymentsLoading = true;
    paymentsErrorMessage = null;
    paymentsSuccessMessage = null;
    notifyListeners();

    // Build query parameters for filtering
    final Map<String, String> queryParams = {};
    if (paymentsStartDate != null && paymentsStartDate!.isNotEmpty) {
      queryParams['start_date'] = paymentsStartDate!;
    }
    if (paymentsEndDate != null && paymentsEndDate!.isNotEmpty) {
      queryParams['end_date'] = paymentsEndDate!;
    }
    if (paymentsType != null && paymentsType!.isNotEmpty && paymentsType != 'All') {
      queryParams['type'] = paymentsType!;
    }
    if (paymentsStatus != null && paymentsStatus!.isNotEmpty && paymentsStatus != 'All') {
      queryParams['status'] = paymentsStatus!;
    }
    if (paymentsClientRef != null && paymentsClientRef!.isNotEmpty) {
      queryParams['client_ref'] = paymentsClientRef!;
    }
    if (paymentsMethod != null && paymentsMethod!.isNotEmpty && paymentsMethod != 'All') {
      queryParams['payment_method'] = paymentsMethod!;
    }

    final url = Uri.parse("$baseUrl/get_payments_charts.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching payments chart data from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Payments response status: ${response.statusCode}');
        print('Payments response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['data'] != null && data['data'] is List) {
            paymentsChartData = List<Map<String, dynamic>>.from(data['data']);
            paymentsChartSummary = data['summary'];
            paymentsChartPeriodInfo = data['period_info'];
            paymentsSuccessMessage = "Payments chart data fetched successfully";
            if (kDebugMode) {
              print('Fetched ${paymentsChartData.length} payment chart items');
            }
          } else {
            paymentsChartData = [];
            paymentsChartSummary = null;
            paymentsChartPeriodInfo = null;
            paymentsErrorMessage = "No payments data available";
            if (kDebugMode) {
              print('No payments data in response');
            }
          }
        } else {
          paymentsErrorMessage = data['message'] ?? "Failed to fetch payments data";
          if (kDebugMode) {
            print('Payments API returned error: $paymentsErrorMessage');
          }
        }
      } else {
        paymentsErrorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('Payments HTTP error: $paymentsErrorMessage');
        }
      }
    } catch (e) {
      paymentsErrorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Payments exception occurred: $e');
      }
    }

    isPaymentsLoading = false;
    notifyListeners();
  }

  /// ✅ Get Clients Chart Data
  Future<void> getClientsChartData() async {
    isClientsLoading = true;
    clientsErrorMessage = null;
    clientsSuccessMessage = null;
    notifyListeners();

    // Build query parameters for filtering
    final Map<String, String> queryParams = {};
    if (clientsStartDate != null && clientsStartDate!.isNotEmpty) {
      queryParams['start_date'] = clientsStartDate!;
    }
    if (clientsEndDate != null && clientsEndDate!.isNotEmpty) {
      queryParams['end_date'] = clientsEndDate!;
    }
    if (clientsType != null && clientsType!.isNotEmpty && clientsType != 'All') {
      queryParams['client_type'] = clientsType!;
    }
    if (clientsWork != null && clientsWork!.isNotEmpty && clientsWork != 'All') {
      queryParams['client_work'] = clientsWork!;
    }

    final url = Uri.parse("$baseUrl/get_clients_charts.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching clients chart data from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Clients response status: ${response.statusCode}');
        print('Clients response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['data'] != null && data['data'] is List) {
            clientsChartData = List<Map<String, dynamic>>.from(data['data']);
            clientsChartSummary = data['summary'];
            clientsChartPeriodInfo = data['period_info'];
            clientsSuccessMessage = "Clients chart data fetched successfully";
            if (kDebugMode) {
              print('Fetched ${clientsChartData.length} client chart items');
            }
          } else {
            clientsChartData = [];
            clientsChartSummary = null;
            clientsChartPeriodInfo = null;
            clientsErrorMessage = "No clients data available";
            if (kDebugMode) {
              print('No clients data in response');
            }
          }
        } else {
          clientsErrorMessage = data['message'] ?? "Failed to fetch clients data";
          if (kDebugMode) {
            print('Clients API returned error: $clientsErrorMessage');
          }
        }
      } else {
        clientsErrorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('Clients HTTP error: $clientsErrorMessage');
        }
      }
    } catch (e) {
      clientsErrorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Clients exception occurred: $e');
      }
    }

    isClientsLoading = false;
    notifyListeners();
  }

  /// ✅ Get Projects Chart Data
  Future<void> getProjectsChartData() async {
    isProjectsLoading = true;
    projectsErrorMessage = null;
    projectsSuccessMessage = null;
    notifyListeners();

    // Build query parameters for filtering
    final Map<String, String> queryParams = {};
    if (projectsStartDate != null && projectsStartDate!.isNotEmpty) {
      queryParams['start_date'] = projectsStartDate!;
    }
    if (projectsEndDate != null && projectsEndDate!.isNotEmpty) {
      queryParams['end_date'] = projectsEndDate!;
    }
    if (projectsClientId != null && projectsClientId!.isNotEmpty && projectsClientId != 'All') {
      queryParams['client_id'] = projectsClientId!;
    }
    if (projectsOrderType != null && projectsOrderType!.isNotEmpty && projectsOrderType != 'All') {
      queryParams['order_type'] = projectsOrderType!;
    }
    if (projectsServiceCategoryId != null &&
        projectsServiceCategoryId!.isNotEmpty &&
        projectsServiceCategoryId != 'All') {
      queryParams['service_category_id'] = projectsServiceCategoryId!;
    }
    if (projectsUserId != null && projectsUserId!.isNotEmpty && projectsUserId != 'All') {
      queryParams['user_id'] = projectsUserId!;
    }

    final url = Uri.parse("$baseUrl/get_projects_chart.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching projects chart data from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Projects response status: ${response.statusCode}');
        print('Projects response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          projectsChartSummary = data['summary'];
          projectsStatusDistribution =
              data['status_distribution'] != null ? List<Map<String, dynamic>>.from(data['status_distribution']) : null;
          projectsFinancialSummary = data['financial_summary'];
          projectsPeriodInfo = data['period_info'];
          projectsDailyBreakdown =
              data['daily_breakdown'] != null ? List<Map<String, dynamic>>.from(data['daily_breakdown']) : [];
          projectsSuccessMessage = "Projects chart data fetched successfully";
          if (kDebugMode) {
            print('Fetched projects summary data with ${projectsDailyBreakdown.length} daily items');
          }
        } else {
          projectsChartSummary = null;
          projectsStatusDistribution = null;
          projectsFinancialSummary = null;
          projectsPeriodInfo = null;
          projectsDailyBreakdown = [];
          projectsErrorMessage = data['message'] ?? "Failed to fetch projects data";
          if (kDebugMode) {
            print('Projects API returned error: $projectsErrorMessage');
          }
        }
      } else {
        projectsErrorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('Projects HTTP error: $projectsErrorMessage');
        }
      }
    } catch (e) {
      projectsErrorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Projects exception occurred: $e');
      }
    }

    isProjectsLoading = false;
    notifyListeners();
  }

  /// ✅ Get Expenses Chart Data
  Future<void> getExpensesChartData() async {
    isExpensesLoading = true;
    expensesErrorMessage = null;
    expensesSuccessMessage = null;
    notifyListeners();

    // Build query parameters for filtering
    final Map<String, String> queryParams = {};
    if (expensesStartDate != null && expensesStartDate!.isNotEmpty) {
      queryParams['start_date'] = expensesStartDate!;
    }
    if (expensesEndDate != null && expensesEndDate!.isNotEmpty) {
      queryParams['end_date'] = expensesEndDate!;
    }
    if (expensesType != null && expensesType!.isNotEmpty && expensesType != 'All') {
      queryParams['expense_type'] = expensesType!;
    }
    if (expensesPaymentStatus != null && expensesPaymentStatus!.isNotEmpty && expensesPaymentStatus != 'All') {
      queryParams['payment_status'] = expensesPaymentStatus!;
    }
    if (expensesPaymentType != null && expensesPaymentType!.isNotEmpty && expensesPaymentType != 'All') {
      queryParams['payment_type'] = expensesPaymentType!;
    }
    if (expensesManager != null && expensesManager!.isNotEmpty) {
      queryParams['pay_by_manager'] = expensesManager!;
    }
    if (expensesTag != null && expensesTag!.isNotEmpty) {
      queryParams['tag'] = expensesTag!;
    }

    final url = Uri.parse("$baseUrl/get_expenses_charts.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching expenses chart data from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Expenses response status: ${response.statusCode}');
        print('Expenses response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          expensesChartSummary = data['summary'];
          expensesTypeDistribution =
              data['expense_type_distribution'] != null
                  ? List<Map<String, dynamic>>.from(data['expense_type_distribution'])
                  : null;
          expensesPaymentStatusDistribution =
              data['payment_status_distribution'] != null
                  ? List<Map<String, dynamic>>.from(data['payment_status_distribution'])
                  : null;
          expensesPaymentTypeDistribution =
              data['payment_type_distribution'] != null
                  ? List<Map<String, dynamic>>.from(data['payment_type_distribution'])
                  : null;
          expensesPeriodInfo = data['period_info'];
          expensesDailyBreakdown =
              data['daily_breakdown'] != null ? List<Map<String, dynamic>>.from(data['daily_breakdown']) : [];
          expensesSuccessMessage = "Expenses chart data fetched successfully";
          if (kDebugMode) {
            print('Fetched expenses summary data with ${expensesDailyBreakdown.length} daily items');
          }
        } else {
          expensesChartSummary = null;
          expensesTypeDistribution = null;
          expensesPaymentStatusDistribution = null;
          expensesPaymentTypeDistribution = null;
          expensesPeriodInfo = null;
          expensesDailyBreakdown = [];
          expensesErrorMessage = data['message'] ?? "Failed to fetch expenses data";
          if (kDebugMode) {
            print('Expenses API returned error: $expensesErrorMessage');
          }
        }
      } else {
        expensesErrorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('Expenses HTTP error: $expensesErrorMessage');
        }
      }
    } catch (e) {
      expensesErrorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Expenses exception occurred: $e');
      }
    }

    isExpensesLoading = false;
    notifyListeners();
  }

  /// ✅ Get Dashboard Overview Data
  Future<void> getDashboardOverview() async {
    isOverviewLoading = true;
    overviewErrorMessage = null;
    overviewSuccessMessage = null;
    notifyListeners();

    // Build query parameters for filtering
    final Map<String, String> queryParams = {};
    if (overviewStartDate != null && overviewStartDate!.isNotEmpty) {
      queryParams['start_date'] = overviewStartDate!;
    }
    if (overviewEndDate != null && overviewEndDate!.isNotEmpty) {
      queryParams['end_date'] = overviewEndDate!;
    }

    final url = Uri.parse("$baseUrl/get_overview.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching dashboard overview data from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Dashboard overview response status: ${response.statusCode}');
        print('Dashboard overview response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          dashboardStats = data['dashboard_stats'];
          overviewSummary = data['summary'];
          overviewComparison = data['comparison'];
          overviewPeriodInfo = data['period_info'];
          overviewSuccessMessage = "Dashboard overview data fetched successfully";
          if (kDebugMode) {
            print('Fetched dashboard overview data successfully');
          }
        } else {
          dashboardStats = null;
          overviewSummary = null;
          overviewComparison = null;
          overviewPeriodInfo = null;
          overviewErrorMessage = data['message'] ?? "Failed to fetch dashboard overview data";
          if (kDebugMode) {
            print('Dashboard overview API returned error: $overviewErrorMessage');
          }
        }
      } else {
        overviewErrorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('Dashboard overview HTTP error: $overviewErrorMessage');
        }
      }
    } catch (e) {
      overviewErrorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Dashboard overview exception occurred: $e');
      }
    }

    isOverviewLoading = false;
    notifyListeners();
  }

  /// ✅ Get All Dashboard Data
  Future<void> getAllDashboardData() async {
    try {
      // Fetch all dashboard data concurrently for better performance
      await Future.wait([
        getDashboardOverview(),
        getPaymentsChartData(),
        getClientsChartData(),
        getProjectsChartData(),
        getExpensesChartData(),
      ]);

      if (kDebugMode) {
        print('All dashboard data loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading all dashboard data: $e');
      }
    }
    // Note: Individual loading states and messages are managed by each method
    // No need to set global states here
  }

  /// Set filters for payments
  void setPaymentsFilters({
    String? startDate,
    String? endDate,
    String? type,
    String? status,
    String? clientRef,
    String? method,
  }) {
    paymentsStartDate = startDate;
    paymentsEndDate = endDate;
    paymentsType = type;
    paymentsStatus = status;
    paymentsClientRef = clientRef;
    paymentsMethod = method;
    notifyListeners();
  }

  /// Set filters for clients
  void setClientsFilters({String? startDate, String? endDate, String? type, String? work}) {
    clientsStartDate = startDate;
    clientsEndDate = endDate;
    clientsType = type;
    clientsWork = work;
    notifyListeners();
  }

  /// Set filters for projects
  void setProjectsFilters({
    String? startDate,
    String? endDate,
    String? clientId,
    String? orderType,
    String? serviceCategoryId,
    String? userId,
  }) {
    projectsStartDate = startDate;
    projectsEndDate = endDate;
    projectsClientId = clientId;
    projectsOrderType = orderType;
    projectsServiceCategoryId = serviceCategoryId;
    projectsUserId = userId;
    notifyListeners();
  }

  /// Set filters for expenses
  void setExpensesFilters({
    String? startDate,
    String? endDate,
    String? type,
    String? paymentStatus,
    String? paymentType,
    String? manager,
    String? tag,
  }) {
    expensesStartDate = startDate;
    expensesEndDate = endDate;
    expensesType = type;
    expensesPaymentStatus = paymentStatus;
    expensesPaymentType = paymentType;
    expensesManager = manager;
    expensesTag = tag;
    notifyListeners();
  }

  /// Set filters for dashboard overview
  void setOverviewFilters({String? startDate, String? endDate}) {
    overviewStartDate = startDate;
    overviewEndDate = endDate;
    notifyListeners();
  }

  /// Clear all filters
  void clearAllFilters() {
    // Clear payments filters
    paymentsStartDate = null;
    paymentsEndDate = null;
    paymentsType = null;
    paymentsStatus = null;
    paymentsClientRef = null;
    paymentsMethod = null;

    // Clear clients filters
    clientsStartDate = null;
    clientsEndDate = null;
    clientsType = null;
    clientsWork = null;

    // Clear projects filters
    projectsStartDate = null;
    projectsEndDate = null;
    projectsClientId = null;
    projectsOrderType = null;
    projectsServiceCategoryId = null;
    projectsUserId = null;

    // Clear expenses filters
    expensesStartDate = null;
    expensesEndDate = null;
    expensesType = null;
    expensesPaymentStatus = null;
    expensesPaymentType = null;
    expensesManager = null;
    expensesTag = null;

    // Clear overview filters
    overviewStartDate = null;
    overviewEndDate = null;

    notifyListeners();
  }

  /// Clear payments filters
  void clearPaymentsFilters() {
    paymentsStartDate = null;
    paymentsEndDate = null;
    paymentsType = null;
    paymentsStatus = null;
    paymentsClientRef = null;
    paymentsMethod = null;
    notifyListeners();
  }

  /// Clear clients filters
  void clearClientsFilters() {
    clientsStartDate = null;
    clientsEndDate = null;
    clientsType = null;
    clientsWork = null;
    notifyListeners();
  }

  /// Clear projects filters
  void clearProjectsFilters() {
    projectsStartDate = null;
    projectsEndDate = null;
    projectsClientId = null;
    projectsOrderType = null;
    projectsServiceCategoryId = null;
    projectsUserId = null;
    notifyListeners();
  }

  /// Clear expenses filters
  void clearExpensesFilters() {
    expensesStartDate = null;
    expensesEndDate = null;
    expensesType = null;
    expensesPaymentStatus = null;
    expensesPaymentType = null;
    expensesManager = null;
    expensesTag = null;
    notifyListeners();
  }

  /// Clear overview filters
  void clearOverviewFilters() {
    overviewStartDate = null;
    overviewEndDate = null;
    notifyListeners();
  }

  /// Clear individual messages
  void clearPaymentsMessages() {
    paymentsErrorMessage = null;
    paymentsSuccessMessage = null;
    notifyListeners();
  }

  void clearClientsMessages() {
    clientsErrorMessage = null;
    clientsSuccessMessage = null;
    notifyListeners();
  }

  void clearProjectsMessages() {
    projectsErrorMessage = null;
    projectsSuccessMessage = null;
    notifyListeners();
  }

  void clearExpensesMessages() {
    expensesErrorMessage = null;
    expensesSuccessMessage = null;
    notifyListeners();
  }

  void clearOverviewMessages() {
    overviewErrorMessage = null;
    overviewSuccessMessage = null;
    notifyListeners();
  }

  /// Clear all messages
  void clearAllMessages() {
    paymentsErrorMessage = null;
    paymentsSuccessMessage = null;
    clientsErrorMessage = null;
    clientsSuccessMessage = null;
    projectsErrorMessage = null;
    projectsSuccessMessage = null;
    expensesErrorMessage = null;
    expensesSuccessMessage = null;
    overviewErrorMessage = null;
    overviewSuccessMessage = null;
    notifyListeners();
  }

  /// Refresh specific chart data
  Future<void> refreshPaymentsData() async {
    await getPaymentsChartData();
  }

  Future<void> refreshClientsData() async {
    await getClientsChartData();
  }

  Future<void> refreshProjectsData() async {
    await getProjectsChartData();
  }

  Future<void> refreshExpensesData() async {
    await getExpensesChartData();
  }

  Future<void> refreshOverviewData() async {
    await getDashboardOverview();
  }

  /// Helper methods to get specific data

  // Payments helpers
  double get totalPaymentsAmount => paymentsChartSummary?['period_total_amount']?.toDouble() ?? 0.0;
  double get totalInAmount => paymentsChartSummary?['period_in_amount']?.toDouble() ?? 0.0;
  double get totalOutAmount => paymentsChartSummary?['period_out_amount']?.toDouble() ?? 0.0;
  int get totalPaymentsCount => paymentsChartSummary?['total_transactions'] ?? 0;

  // Clients helpers
  int get totalClientsCount => clientsChartSummary?['total_period_clients'] ?? 0;
  int get individualClientsCount => clientsChartSummary?['total_individual_clients'] ?? 0;
  int get organizationClientsCount => clientsChartSummary?['total_organization_clients'] ?? 0;
  double get individualPercentage => clientsChartSummary?['individual_percentage']?.toDouble() ?? 0.0;
  double get organizationPercentage => clientsChartSummary?['organization_percentage']?.toDouble() ?? 0.0;

  // Projects helpers
  int get totalProjectsCount => projectsChartSummary?['total_projects'] ?? 0;
  int get inProgressProjectsCount => projectsChartSummary?['in_progress_projects'] ?? 0;
  int get completedProjectsCount => projectsChartSummary?['completed_projects'] ?? 0;
  int get draftProjectsCount => projectsChartSummary?['draft_projects'] ?? 0;
  int get stoppedProjectsCount => projectsChartSummary?['stopped_projects'] ?? 0;
  double get inProgressPercentage => projectsChartSummary?['in_progress_percentage']?.toDouble() ?? 0.0;
  double get completedPercentage => projectsChartSummary?['completed_percentage']?.toDouble() ?? 0.0;
  double get draftPercentage => projectsChartSummary?['draft_percentage']?.toDouble() ?? 0.0;
  double get stoppedPercentage => projectsChartSummary?['stopped_percentage']?.toDouble() ?? 0.0;

  // Expenses helpers
  int get totalExpensesCount => expensesChartSummary?['total_expenses'] ?? 0;
  double get totalExpensesAmount => expensesChartSummary?['total_amount']?.toDouble() ?? 0.0;
  double get avgExpenseAmount => expensesChartSummary?['avg_expense_amount']?.toDouble() ?? 0.0;

  // ===== Dashboard Overview formatted getters =====
  String get dashboardRevenueFormatted {
    return _getOverviewFormattedValue('revenue', fallbackKeys: ['total_revenue', 'revenue_amount']);
  }

  String get dashboardUsersFormatted {
    return _getOverviewFormattedValue('users', fallbackKeys: ['total_users']);
  }

  String get dashboardClientsFormatted {
    return _getOverviewFormattedValue('clients', fallbackKeys: ['total_clients']);
  }

  String get dashboardProjectsFormatted {
    return _getOverviewFormattedValue('projects', fallbackKeys: ['total_projects']);
  }

  String get dashboardExpensesFormatted {
    return _getOverviewFormattedValue('expenses', fallbackKeys: ['total_expenses', 'expenses_amount', 'total_amount']);
  }

  // Extract a numeric from overview maps trying multiple keys
  num _getOverviewNumber(List<String> possibleKeys) {
    num tryGet(Map<String, dynamic>? map, String key) {
      final dynamic v = map != null ? map[key] : null;
      if (v is num) return v;
      if (v is String) {
        final parsed = num.tryParse(v);
        if (parsed != null) return parsed;
      }
      return 0;
    }

    for (final key in possibleKeys) {
      final num fromStats = tryGet(dashboardStats, key);
      if (fromStats != 0) return fromStats;
    }
    for (final key in possibleKeys) {
      final num fromSummary = tryGet(overviewSummary, key);
      if (fromSummary != 0) return fromSummary;
    }
    return 0;
  }

  // Format numbers like 1.2K, 3.4M, or plain without decimals when < 1000
  String _formatCompactNumber(num value) {
    final double d = value.toDouble();
    if (d >= 1000000) {
      return '${(d / 1000000).toStringAsFixed(1)}M';
    } else if (d >= 1000) {
      return '${(d / 1000).toStringAsFixed(1)}K';
    }
    if (d == d.roundToDouble()) {
      return d.toInt().toString();
    }
    return d.toStringAsFixed(0);
  }

  // Prefer formatted_value from nested dashboard_stats → metric map; fallback to numeric keys
  String _getOverviewFormattedValue(String metricKey, {List<String> fallbackKeys = const []}) {
    final dynamic metric = dashboardStats != null ? dashboardStats![metricKey] : null;
    if (metric is Map<String, dynamic>) {
      final dynamic formatted = metric['formatted_value'];
      if (formatted is String && formatted.isNotEmpty) {
        return formatted;
      }
      final dynamic raw = metric['value'];
      if (raw is num) return _formatCompactNumber(raw);
      if (raw is String) {
        final parsed = num.tryParse(raw);
        if (parsed != null) return _formatCompactNumber(parsed);
      }
    }

    // Fallback to legacy flat keys or summary
    final List<String> keys = [metricKey, ...fallbackKeys];
    final num value = _getOverviewNumber(keys);
    return _formatCompactNumber(value);
  }
}
