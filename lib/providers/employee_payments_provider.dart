import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EmployeePaymentsProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/banking/empolyee_payments";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> employeePayments = [];
  Map<String, dynamic>? paginationData;
  Map<String, dynamic>? summaryData;

  // Filter parameters
  String? employeeRefIdFilter;
  String? paymentRefIdFilter;
  String? employeePaymentRefIdFilter;
  String? monthYearFilter;
  String? typeFilter; // salary, pay, bonus, advance, return
  String? startDateFilter;
  String? endDateFilter;
  String? sortByFilter; // id, employee_payment_ref_id, employee_ref_id, month_year, amount, type, created_at, updated_at
  String? sortOrderFilter; // ASC, DESC
  int currentPage = 1;
  int itemsPerPage = 20;

  /// ✅ Get All Employee Payments
  Future<void> getAllEmployeePayments({int? page, int? limit}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Use provided page/limit or defaults
    int requestPage = page ?? currentPage;
    int requestLimit = limit ?? itemsPerPage;

    // Build query parameters for filtering and pagination
    final Map<String, String> queryParams = {
      'page': requestPage.toString(),
      'limit': requestLimit.toString(),
    };

    if (employeeRefIdFilter != null && employeeRefIdFilter!.isNotEmpty) {
      queryParams['employee_ref_id'] = employeeRefIdFilter!;
    }
    if (paymentRefIdFilter != null && paymentRefIdFilter!.isNotEmpty) {
      queryParams['payment_ref_id'] = paymentRefIdFilter!;
    }
    if (employeePaymentRefIdFilter != null && employeePaymentRefIdFilter!.isNotEmpty) {
      queryParams['employee_payment_ref_id'] = employeePaymentRefIdFilter!;
    }
    if (monthYearFilter != null && monthYearFilter!.isNotEmpty) {
      queryParams['month_year'] = monthYearFilter!;
    }
    if (typeFilter != null && typeFilter!.isNotEmpty && typeFilter != 'All') {
      queryParams['type'] = typeFilter!;
    }
    if (startDateFilter != null && startDateFilter!.isNotEmpty) {
      queryParams['start_date'] = startDateFilter!;
    }
    if (endDateFilter != null && endDateFilter!.isNotEmpty) {
      queryParams['end_date'] = endDateFilter!;
    }
    if (sortByFilter != null && sortByFilter!.isNotEmpty) {
      queryParams['order_by'] = sortByFilter!;
    }
    if (sortOrderFilter != null && sortOrderFilter!.isNotEmpty) {
      queryParams['order_dir'] = sortOrderFilter!;
    }

    final url = Uri.parse("$baseUrl/get_employee_payments.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching employee payments from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['data'] != null && data['data'] is List) {
            employeePayments = List<Map<String, dynamic>>.from(data['data']);
            paginationData = data['pagination'];
            summaryData = data['summary'];
            currentPage = requestPage;
            successMessage = "Employee payments fetched successfully";
            if (kDebugMode) {
              print('Fetched ${employeePayments.length} employee payments');
              print('Pagination: $paginationData');
              print('Summary: $summaryData');
            }
          } else {
            employeePayments = [];
            paginationData = null;
            summaryData = null;
            errorMessage = "No employee payments available";
            if (kDebugMode) {
              print('No payments data in response');
            }
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch employee payments";
          if (kDebugMode) {
            print('API returned error: $errorMessage');
          }
        }
      } else {
        errorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('HTTP error: $errorMessage');
        }
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Add Employee Payment
  Future<void> addEmployeePayment({
    required String employeeRefId,
    required String monthYear,
    required double amount,
    required String type, // salary, pay, bonus, advance, return
    String? paymentRefId,
    String? description,
    String? createdAt,
    String? updatedAt,
    // Banking-related parameters for non-salary payments
    String? payBy,
    String? receivedBy,
    String? status,
    String? paymentMethod,
    String? chequeNo,
    String? transactionId,
    String? bankRefId,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_employee_payment.php");

    // Create body with required and optional values
    final Map<String, dynamic> bodyData = {
      "employee_ref_id": employeeRefId,
      "month_year": monthYear,
      "amount": amount,
      "type": type,
    };

    if (paymentRefId != null && paymentRefId.isNotEmpty) {
      bodyData["payment_ref_id"] = paymentRefId;
    }
    if (description != null && description.isNotEmpty) {
      bodyData["description"] = description;
    }
    if (createdAt != null && createdAt.isNotEmpty) {
      bodyData["created_at"] = createdAt;
    }
    if (updatedAt != null && updatedAt.isNotEmpty) {
      bodyData["updated_at"] = updatedAt;
    }

    // Add banking-related parameters for non-salary payments
    if (type.toLowerCase() != 'salary') {
      // Determine payment type for banking (in/out)
      String bankingPaymentType;
      if (type.toLowerCase() == 'return') {
        bankingPaymentType = 'in'; // Return is income
      } else {
        // pay, bonus, advance are expenses (out)
        bankingPaymentType = 'out';
      }
      bodyData["banking_payment_type"] = bankingPaymentType;

      // Pay by field with default value
      if (payBy != null && payBy.isNotEmpty) {
        bodyData["pay_by"] = payBy;
      } else {
        bodyData["pay_by"] = "SYSTEM"; // Default value
      }

      // Received by field with default value
      if (receivedBy != null && receivedBy.isNotEmpty) {
        bodyData["received_by"] = receivedBy;
      } else {
        bodyData["received_by"] = employeeRefId; // Default to employee
      }

      // Status field with default value
      if (status != null && status.isNotEmpty) {
        bodyData["status"] = status;
      } else {
        bodyData["status"] = "completed"; // Default status
      }

      // Payment method field with default value
      if (paymentMethod != null && paymentMethod.isNotEmpty) {
        bodyData["payment_method"] = paymentMethod;
      } else {
        bodyData["payment_method"] = "cash"; // Default payment method
      }

      // Optional banking payment fields
      if (chequeNo != null && chequeNo.isNotEmpty) {
        bodyData["cheque_no"] = chequeNo;
      }
      if (transactionId != null && transactionId.isNotEmpty) {
        bodyData["transaction_id"] = transactionId;
      }
      if (bankRefId != null && bankRefId.isNotEmpty) {
        bodyData["bank_ref_id"] = bankRefId;
      }
    }

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Adding employee payment to: $url');
        print('Request body: $body');
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Employee payment added successfully";
        if (kDebugMode) {
          print('Payment Reference ID: ${data['employee_payment_ref_id']}');
          print('Payment ID: ${data['id']}');
        }
        await getAllEmployeePayments(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add employee payment";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Update Employee Payment
  Future<void> updateEmployeePayment({
    String? id,
    String? employeePaymentRefId,
    String? employeeRefId,
    String? paymentRefId,
    String? monthYear,
    double? amount,
    String? type,
    String? description,
    // Banking-related parameters for non-salary payments
    String? payBy,
    String? receivedBy,
    String? status,
    String? paymentMethod,
    String? chequeNo,
    String? transactionId,
    String? bankRefId,
  }) async {
    if (id == null && employeePaymentRefId == null) {
      errorMessage = "Either ID or Employee Payment Reference ID is required for update";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_employee_payment.php");

    // Create body with identifier and only non-null values
    final Map<String, dynamic> bodyData = {};
    if (id != null && id.isNotEmpty) bodyData["id"] = id;
    if (employeePaymentRefId != null && employeePaymentRefId.isNotEmpty) {
      bodyData["employee_payment_ref_id"] = employeePaymentRefId;
    }

    if (employeeRefId != null && employeeRefId.isNotEmpty) {
      bodyData["employee_ref_id"] = employeeRefId;
    }
    if (paymentRefId != null) {
      bodyData["payment_ref_id"] = paymentRefId.isNotEmpty ? paymentRefId : null;
    }
    if (monthYear != null && monthYear.isNotEmpty) {
      bodyData["month_year"] = monthYear;
    }
    if (amount != null) bodyData["amount"] = amount;
    if (type != null && type.isNotEmpty) bodyData["type"] = type;
    if (description != null) {
      bodyData["description"] = description.isNotEmpty ? description : null;
    }

    // Add banking-related parameters for non-salary payments
    if (type != null && type.toLowerCase() != 'salary') {
      // Determine payment type for banking (in/out)
      String bankingPaymentType;
      if (type.toLowerCase() == 'return') {
        bankingPaymentType = 'in'; // Return is income
      } else {
        // pay, bonus, advance are expenses (out)
        bankingPaymentType = 'out';
      }
      bodyData["banking_payment_type"] = bankingPaymentType;

      // Pay by field with default value
      if (payBy != null && payBy.isNotEmpty) {
        bodyData["pay_by"] = payBy;
      } else {
        bodyData["pay_by"] = "SYSTEM"; // Default value
      }

      // Received by field with default value
      if (receivedBy != null && receivedBy.isNotEmpty) {
        bodyData["received_by"] = receivedBy;
      } else {
        bodyData["received_by"] = employeeRefId ?? ""; // Default to employee
      }

      // Status field with default value
      if (status != null && status.isNotEmpty) {
        bodyData["status"] = status;
      } else {
        bodyData["status"] = "completed"; // Default status
      }

      // Payment method field with default value
      if (paymentMethod != null && paymentMethod.isNotEmpty) {
        bodyData["payment_method"] = paymentMethod;
      } else {
        bodyData["payment_method"] = "cash"; // Default payment method
      }

      // Optional banking payment fields
      if (chequeNo != null && chequeNo.isNotEmpty) {
        bodyData["cheque_no"] = chequeNo;
      }
      if (transactionId != null && transactionId.isNotEmpty) {
        bodyData["transaction_id"] = transactionId;
      }
      if (bankRefId != null && bankRefId.isNotEmpty) {
        bodyData["bank_ref_id"] = bankRefId;
      }
    }

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Updating employee payment at: $url');
        print('Request body: $body');
      }

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Employee payment updated successfully";
        await getAllEmployeePayments(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to update employee payment";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Delete Employee Payment
  Future<void> deleteEmployeePayment({String? id, String? employeePaymentRefId}) async {
    if (id == null && employeePaymentRefId == null) {
      errorMessage = "Either ID or Employee Payment Reference ID is required for deletion";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_employee_payment.php");

    final Map<String, dynamic> bodyData = {};
    if (id != null && id.isNotEmpty) bodyData["id"] = id;
    if (employeePaymentRefId != null && employeePaymentRefId.isNotEmpty) {
      bodyData["employee_payment_ref_id"] = employeePaymentRefId;
    }

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Deleting employee payment at: $url');
        print('Request body: $body');
      }

      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Employee payment deleted successfully";
        await getAllEmployeePayments(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to delete employee payment";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Set filters and pagination
  void setFilters({
    String? employeeRefId,
    String? paymentRefId,
    String? employeePaymentRefId,
    String? monthYear,
    String? type,
    String? startDate,
    String? endDate,
    String? sortBy,
    String? sortOrder,
    int? page,
    int? limit,
  }) {
    employeeRefIdFilter = employeeRefId;
    paymentRefIdFilter = paymentRefId;
    employeePaymentRefIdFilter = employeePaymentRefId;
    monthYearFilter = monthYear;
    typeFilter = type;
    startDateFilter = startDate;
    endDateFilter = endDate;
    sortByFilter = sortBy;
    sortOrderFilter = sortOrder;
    if (page != null) currentPage = page;
    if (limit != null) itemsPerPage = limit;
    notifyListeners();
  }

  /// ✅ Load next page
  Future<void> loadNextPage() async {
    if (paginationData != null) {
      int totalPages = paginationData!['total_pages'] ?? 1;
      if (currentPage < totalPages) {
        await getAllEmployeePayments(page: currentPage + 1);
      }
    }
  }

  /// ✅ Load previous page
  Future<void> loadPreviousPage() async {
    if (currentPage > 1) {
      await getAllEmployeePayments(page: currentPage - 1);
    }
  }

  /// ✅ Go to specific page
  Future<void> goToPage(int page) async {
    if (page >= 1 && paginationData != null) {
      int totalPages = paginationData!['total_pages'] ?? 1;
      if (page <= totalPages) {
        await getAllEmployeePayments(page: page);
      }
    }
  }

  /// ✅ Clear all filters and reset pagination
  void clearFilters() {
    employeeRefIdFilter = null;
    paymentRefIdFilter = null;
    employeePaymentRefIdFilter = null;
    monthYearFilter = null;
    typeFilter = null;
    startDateFilter = null;
    endDateFilter = null;
    sortByFilter = null;
    sortOrderFilter = null;
    currentPage = 1;
    notifyListeners();
  }

  /// ✅ Clear messages
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  /// ✅ Get payment by ID (from local list)
  Map<String, dynamic>? getPaymentById(String id) {
    try {
      return employeePayments.firstWhere(
            (payment) => payment['id'].toString() == id,
      );
    } catch (e) {
      return null;
    }
  }

  /// ✅ Get payment by Employee Payment Reference ID (from local list)
  Map<String, dynamic>? getPaymentByRefId(String refId) {
    try {
      return employeePayments.firstWhere(
            (payment) => payment['employee_payment_ref_id'] == refId,
      );
    } catch (e) {
      return null;
    }
  }

  /// ✅ Get all payments for specific employee
  List<Map<String, dynamic>> getPaymentsByEmployee(String employeeRefId) {
    return employeePayments
        .where((payment) => payment['employee_ref_id'] == employeeRefId)
        .toList();
  }

  /// ✅ Get payments by type (salary, pay, bonus, advance, return)
  List<Map<String, dynamic>> getPaymentsByType(String type) {
    return employeePayments
        .where((payment) => payment['type'] == type)
        .toList();
  }

  /// ✅ Get payments by month/year
  List<Map<String, dynamic>> getPaymentsByMonthYear(String monthYear) {
    return employeePayments
        .where((payment) => payment['month_year'] == monthYear)
        .toList();
  }

  /// ✅ Get salary payments
  List<Map<String, dynamic>> getSalaryPayments() {
    return getPaymentsByType('salary');
  }

  /// ✅ Get bonus payments
  List<Map<String, dynamic>> getBonusPayments() {
    return getPaymentsByType('bonus');
  }

  /// ✅ Get advance payments
  List<Map<String, dynamic>> getAdvancePayments() {
    return getPaymentsByType('advance');
  }

  /// ✅ Get advance return payments
  List<Map<String, dynamic>> getAdvanceReturnPayments() {
    return getPaymentsByType('return');
  }

  /// ✅ Calculate total amount by employee
  double getTotalAmountByEmployee(String employeeRefId) {
    return employeePayments
        .where((payment) => payment['employee_ref_id'] == employeeRefId)
        .fold(0.0, (sum, payment) {
      double amount = (payment['amount'] ?? 0).toDouble();
      return sum + amount;
    });
  }

  /// ✅ Calculate total amount by type
  double getTotalAmountByType(String type) {
    return employeePayments
        .where((payment) => payment['type'] == type)
        .fold(0.0, (sum, payment) {
      double amount = (payment['amount'] ?? 0).toDouble();
      return sum + amount;
    });
  }

  /// ✅ Calculate total amount by month/year
  double getTotalAmountByMonthYear(String monthYear) {
    return employeePayments
        .where((payment) => payment['month_year'] == monthYear)
        .fold(0.0, (sum, payment) {
      double amount = (payment['amount'] ?? 0).toDouble();
      return sum + amount;
    });
  }

  /// ✅ Calculate net advances (advance - returns) for an employee
  double getNetAdvancesByEmployee(String employeeRefId) {
    double totalAdvances = employeePayments
        .where((payment) =>
    payment['employee_ref_id'] == employeeRefId &&
        payment['type'] == 'advance')
        .fold(0.0, (sum, payment) {
      double amount = (payment['amount'] ?? 0).toDouble();
      return sum + amount;
    });

    double totalReturns = employeePayments
        .where((payment) =>
    payment['employee_ref_id'] == employeeRefId &&
        payment['type'] == 'return')
        .fold(0.0, (sum, payment) {
      double amount = (payment['amount'] ?? 0).toDouble();
      return sum + amount;
    });

    return totalAdvances - totalReturns;
  }

  /// ✅ Get summary statistics
  Map<String, dynamic> getSummaryStats() {
    if (summaryData != null) {
      return summaryData!;
    }

    // Calculate from local data if summary not available
    double totalAmount = employeePayments.fold(0.0, (sum, payment) {
      double amount = (payment['amount'] ?? 0).toDouble();
      return sum + amount;
    });

    return {
      'total_amount': totalAmount,
      'count': employeePayments.length,
    };
  }

  /// ✅ Get unique employees from payments
  List<String> getUniqueEmployees() {
    Set<String> employees = {};
    for (var payment in employeePayments) {
      if (payment['employee_ref_id'] != null) {
        employees.add(payment['employee_ref_id']);
      }
    }
    return employees.toList();
  }

  /// ✅ Get unique months from payments
  List<String> getUniqueMonths() {
    Set<String> months = {};
    for (var payment in employeePayments) {
      if (payment['month_year'] != null) {
        months.add(payment['month_year']);
      }
    }
    return months.toList()..sort((a, b) => b.compareTo(a)); // Sort descending
  }

  /// ✅ Format amount for display
  String formatAmount(dynamic amount) {
    if (amount == null) return '0.00';
    double value = amount is String
        ? double.tryParse(amount) ?? 0.0
        : amount.toDouble();
    return value.toStringAsFixed(2);
  }

  /// ✅ Format currency with symbol
  String formatCurrency(dynamic amount, {String symbol = '\$'}) {
    return '$symbol${formatAmount(amount)}';
  }

  /// ✅ Format date for API (YYYY-MM-DD HH:MM:SS)
  String formatDateForApi(DateTime dateTime) {
    return dateTime.toString().substring(0, 19); // YYYY-MM-DD HH:MM:SS
  }

  /// ✅ Get current date for API
  String getCurrentDateForApi() {
    return formatDateForApi(DateTime.now());
  }

  /// ✅ Parse date from API response
  DateTime? parseDateFromApi(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing date: $dateString - $e');
      }
      return null;
    }
  }

  /// ✅ Get payment type label
  String getPaymentTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'salary':
        return 'Salary';
      case 'pay':
        return 'Pay';
      case 'bonus':
        return 'Bonus';
      case 'advance':
        return 'Advance';
      case 'return':
        return 'Advance Return';
      default:
        return type;
    }
  }

  /// ✅ Get payment type color (for UI)
  String getPaymentTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'salary':
        return '#4CAF50'; // Green
      case 'pay':
        return '#2196F3'; // Blue
      case 'bonus':
        return '#FF9800'; // Orange
      case 'advance':
        return '#F44336'; // Red
      case 'return':
        return '#9C27B0'; // Purple
      default:
        return '#757575'; // Grey
    }
  }

  /// ✅ Validate payment type
  bool isValidPaymentType(String type) {
    const validTypes = ['salary', 'pay', 'bonus', 'advance', 'return'];
    return validTypes.contains(type.toLowerCase());
  }

  /// ✅ Get month name from month_year string
  String getMonthName(String monthYear) {
    // Assuming format: "January 2025" or "01-2025"
    if (monthYear.contains(' ')) {
      return monthYear.split(' ')[0];
    } else if (monthYear.contains('-')) {
      List<String> parts = monthYear.split('-');
      if (parts.length == 2) {
        int? month = int.tryParse(parts[0]);
        if (month != null && month >= 1 && month <= 12) {
          const months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];
          return months[month - 1];
        }
      }
    }
    return monthYear;
  }

  /// ✅ Get year from month_year string
  String getYear(String monthYear) {
    // Assuming format: "January 2025" or "01-2025"
    if (monthYear.contains(' ')) {
      return monthYear.split(' ').last;
    } else if (monthYear.contains('-')) {
      return monthYear.split('-').last;
    }
    return monthYear;
  }
}