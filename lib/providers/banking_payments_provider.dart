import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BankingPaymentsProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/public_html/api/banking/payments";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> payments = [];
  Map<String, dynamic>? paginationData;
  Map<String, dynamic>? summaryData;

  // Filter parameters
  String? typeFilter; // project, short_service, expense, employee
  String? paymentTypeFilter; // in, out
  String? statusFilter; // pending, completed
  String? clientRefFilter;
  String? paymentRefIdFilter;
  String? dateFromFilter;
  String? dateToFilter;
  String? sortByFilter; // id, payment_ref_id, type, payment_type, total_amount, paid_amount, status, created_at, updated_at
  String? sortOrderFilter; // ASC, DESC
  int currentPage = 1;
  int itemsPerPage = 20;

  /// ✅ Get All Banking Payments
  Future<void> getAllBankingPayments({int? page, int? limit}) async {
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

    if (typeFilter != null && typeFilter!.isNotEmpty && typeFilter != 'All') {
      queryParams['type'] = typeFilter!;
    }
    if (paymentTypeFilter != null && paymentTypeFilter!.isNotEmpty && paymentTypeFilter != 'All') {
      queryParams['payment_type'] = paymentTypeFilter!;
    }
    if (statusFilter != null && statusFilter!.isNotEmpty && statusFilter != 'All') {
      queryParams['status'] = statusFilter!;
    }
    if (clientRefFilter != null && clientRefFilter!.isNotEmpty) {
      queryParams['client_ref'] = clientRefFilter!;
    }
    if (paymentRefIdFilter != null && paymentRefIdFilter!.isNotEmpty) {
      queryParams['payment_ref_id'] = paymentRefIdFilter!;
    }
    if (dateFromFilter != null && dateFromFilter!.isNotEmpty) {
      queryParams['date_from'] = dateFromFilter!;
    }
    if (dateToFilter != null && dateToFilter!.isNotEmpty) {
      queryParams['date_to'] = dateToFilter!;
    }
    if (sortByFilter != null && sortByFilter!.isNotEmpty) {
      queryParams['sort_by'] = sortByFilter!;
    }
    if (sortOrderFilter != null && sortOrderFilter!.isNotEmpty) {
      queryParams['sort_order'] = sortOrderFilter!;
    }

    final url = Uri.parse("$baseUrl/get_all_banking_payments.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching banking payments from: $url');
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
            payments = List<Map<String, dynamic>>.from(data['data']);
            paginationData = data['pagination'];
            summaryData = data['summary'];
            currentPage = requestPage;
            successMessage = "Banking payments fetched successfully";
            if (kDebugMode) {
              print('Fetched ${payments.length} banking payments');
              print('Pagination: $paginationData');
              print('Summary: $summaryData');
            }
          } else {
            payments = [];
            paginationData = null;
            summaryData = null;
            errorMessage = "No banking payments available";
            if (kDebugMode) {
              print('No payments data in response');
            }
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch banking payments";
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

  /// ✅ Add Banking Payment
  Future<void> addBankingPayment({
    required String type, // project, short_service, expense, employee
    required String typeRef,
    required String clientRef,
    required String paymentType, // in, out
    required String payBy,
    required String receivedBy,
    required double totalAmount,
    double? paidAmount,
    String? status, // pending, completed
    String? paymentMethod, // bank, cheque, cash
    String? chequeNo,
    String? transactionId,
    String? bankRefId,
    String? createdAt,
    String? updatedAt,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_banking_payment.php");

    // Create body with required and optional values
    final Map<String, dynamic> bodyData = {
      "type": type,
      "type_ref": typeRef,
      "client_ref": clientRef,
      "payment_type": paymentType,
      "pay_by": payBy,
      "received_by": receivedBy,
      "total_amount": totalAmount,
    };

    if (paidAmount != null) bodyData["paid_amount"] = paidAmount;
    if (status != null && status.isNotEmpty) bodyData["status"] = status;
    if (paymentMethod != null && paymentMethod.isNotEmpty) bodyData["payment_method"] = paymentMethod;
    if (chequeNo != null && chequeNo.isNotEmpty) bodyData["cheque_no"] = chequeNo;
    if (transactionId != null && transactionId.isNotEmpty) bodyData["transaction_id"] = transactionId;
    if (bankRefId != null && bankRefId.isNotEmpty) bodyData["bank_ref_id"] = bankRefId;
    if (createdAt != null && createdAt.isNotEmpty) bodyData["created_at"] = createdAt;
    if (updatedAt != null && updatedAt.isNotEmpty) bodyData["updated_at"] = updatedAt;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Adding banking payment to: $url');
        print('Request body: $body');
      }

      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Banking payment added successfully";
        if (kDebugMode) {
          print('Payment Reference ID: ${data['payment_ref_id']}');
          print('Payment ID: ${data['id']}');
        }
        await getAllBankingPayments(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add banking payment";
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

  /// ✅ Update Banking Payment
  Future<void> updateBankingPayment({
    String? id,
    String? paymentRefId,
    String? type,
    String? typeRef,
    String? clientRef,
    String? paymentType,
    String? payBy,
    String? receivedBy,
    double? totalAmount,
    double? paidAmount,
    String? status,
    String? paymentMethod, // bank, cheque, cash
    String? chequeNo,
    String? transactionId,
    String? bankRefId,
    String? createdAt,
    String? updatedAt,
  }) async {
    if (id == null && paymentRefId == null) {
      errorMessage = "Either ID or Payment Reference ID is required for update";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_banking_payment.php");

    // Create body with identifier and only non-null values
    final Map<String, dynamic> bodyData = {};
    if (id != null && id.isNotEmpty) bodyData["id"] = id;
    if (paymentRefId != null && paymentRefId.isNotEmpty) bodyData["payment_ref_id"] = paymentRefId;

    if (type != null && type.isNotEmpty) bodyData["type"] = type;
    if (typeRef != null && typeRef.isNotEmpty) bodyData["type_ref"] = typeRef;
    if (clientRef != null && clientRef.isNotEmpty) bodyData["client_ref"] = clientRef;
    if (paymentType != null && paymentType.isNotEmpty) bodyData["payment_type"] = paymentType;
    if (payBy != null && payBy.isNotEmpty) bodyData["pay_by"] = payBy;
    if (receivedBy != null && receivedBy.isNotEmpty) bodyData["received_by"] = receivedBy;
    if (totalAmount != null) bodyData["total_amount"] = totalAmount;
    if (paidAmount != null) bodyData["paid_amount"] = paidAmount;
    if (status != null && status.isNotEmpty) bodyData["status"] = status;
    if (paymentMethod != null && paymentMethod.isNotEmpty) bodyData["payment_method"] = paymentMethod;
    if (chequeNo != null && chequeNo.isNotEmpty) bodyData["cheque_no"] = chequeNo;
    if (transactionId != null && transactionId.isNotEmpty) bodyData["transaction_id"] = transactionId;
    if (bankRefId != null && bankRefId.isNotEmpty) bodyData["bank_ref_if"] = bankRefId;
    if (createdAt != null && createdAt.isNotEmpty) bodyData["created_at"] = createdAt;
    if (updatedAt != null && updatedAt.isNotEmpty) bodyData["updated_at"] = updatedAt;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Updating banking payment at: $url');
        print('Request body: $body');
      }

      final response = await http.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Banking payment updated successfully";
        await getAllBankingPayments(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to update banking payment";
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

  /// ✅ Delete Banking Payment
  Future<void> deleteBankingPayment({String? id, String? paymentRefId}) async {
    if (id == null && paymentRefId == null) {
      errorMessage = "Either ID or Payment Reference ID is required for deletion";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_banking_payment.php");

    final Map<String, dynamic> bodyData = {};
    if (id != null && id.isNotEmpty) bodyData["id"] = id;
    if (paymentRefId != null && paymentRefId.isNotEmpty) bodyData["payment_ref_id"] = paymentRefId;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Deleting banking payment at: $url');
        print('Request body: $body');
      }

      final response = await http.post( // Using POST as fallback for DELETE
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Banking payment deleted successfully";
        await getAllBankingPayments(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to delete banking payment";
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
    String? type,
    String? paymentType,
    String? status,
    String? clientRef,
    String? paymentRefId,
    String? dateFrom,
    String? dateTo,
    String? sortBy,
    String? sortOrder,
    int? page,
    int? limit,
  }) {
    typeFilter = type;
    paymentTypeFilter = paymentType;
    statusFilter = status;
    clientRefFilter = clientRef;
    paymentRefIdFilter = paymentRefId;
    dateFromFilter = dateFrom;
    dateToFilter = dateTo;
    sortByFilter = sortBy;
    sortOrderFilter = sortOrder;
    if (page != null) currentPage = page;
    if (limit != null) itemsPerPage = limit;
    notifyListeners();
  }

  /// ✅ Load next page
  Future<void> loadNextPage() async {
    if (paginationData != null && paginationData!['has_next_page'] == true) {
      await getAllBankingPayments(page: currentPage + 1);
    }
  }

  /// ✅ Load previous page
  Future<void> loadPreviousPage() async {
    if (paginationData != null && paginationData!['has_prev_page'] == true && currentPage > 1) {
      await getAllBankingPayments(page: currentPage - 1);
    }
  }

  /// ✅ Go to specific page
  Future<void> goToPage(int page) async {
    if (page >= 1 && paginationData != null) {
      int totalPages = paginationData!['total_pages'] ?? 1;
      if (page <= totalPages) {
        await getAllBankingPayments(page: page);
      }
    }
  }

  /// ✅ Clear all filters and reset pagination
  void clearFilters() {
    typeFilter = null;
    paymentTypeFilter = null;
    statusFilter = null;
    clientRefFilter = null;
    paymentRefIdFilter = null;
    dateFromFilter = null;
    dateToFilter = null;
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
      return payments.firstWhere((payment) => payment['id'].toString() == id);
    } catch (e) {
      return null;
    }
  }

  /// ✅ Get payment by Reference ID (from local list)
  Map<String, dynamic>? getPaymentByRefId(String refId) {
    try {
      return payments.firstWhere((payment) => payment['payment_ref_id'] == refId);
    } catch (e) {
      return null;
    }
  }

  /// ✅ Get summary statistics
  Map<String, dynamic> getSummaryStats() {
    return summaryData ?? {
      'total_payments': 0,
      'total_income': 0.0,
      'total_expense': 0.0,
      'total_income_paid': 0.0,
      'total_expense_paid': 0.0,
      'pending_payments': 0,
      'completed_payments': 0,
      'net_amount': 0.0,
    };
  }

  /// ✅ Get income payments only
  List<Map<String, dynamic>> getIncomePayments() {
    return payments.where((payment) => payment['payment_type'] == 'in').toList();
  }

  /// ✅ Get expense payments only
  List<Map<String, dynamic>> getExpensePayments() {
    return payments.where((payment) => payment['payment_type'] == 'out').toList();
  }

  /// ✅ Get pending payments only
  List<Map<String, dynamic>> getPendingPayments() {
    return payments.where((payment) => payment['status'] == 'pending').toList();
  }

  /// ✅ Get completed payments only
  List<Map<String, dynamic>> getCompletedPayments() {
    return payments.where((payment) => payment['status'] == 'completed').toList();
  }

  /// ✅ Get payments by type
  List<Map<String, dynamic>> getPaymentsByType(String type) {
    return payments.where((payment) => payment['type'] == type).toList();
  }

  /// ✅ Calculate total remaining amount
  double getTotalRemainingAmount() {
    return payments.fold(0.0, (sum, payment) {
      double totalAmount = (payment['total_amount'] ?? 0).toDouble();
      double paidAmount = (payment['paid_amount'] ?? 0).toDouble();
      return sum + (totalAmount - paidAmount);
    });
  }

  /// ✅ Format amount for display
  String formatAmount(dynamic amount) {
    if (amount == null) return '0.00';
    double value = amount is String ? double.tryParse(amount) ?? 0.0 : amount.toDouble();
    return value.toStringAsFixed(2);
  }

  /// ✅ Format date for API (YYYY-MM-DD HH:MM:SS)
  String formatDateForApi(DateTime dateTime) {
    return dateTime.toString().substring(0, 19); // YYYY-MM-DD HH:MM:SS
  }

  /// ✅ Get current date for API
  String getCurrentDateForApi() {
    return formatDateForApi(DateTime.now());
  }
}