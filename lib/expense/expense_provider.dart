import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/request_state.dart';

class ExpenseProvider extends ChangeNotifier {
  // State management
  RequestState _state = RequestState.idle;
  RequestState get state => _state;

  RequestState _fetchState = RequestState.idle;
  RequestState get fetchState => _fetchState;

  // Data
  List<ExpenseData> _expenses = [];
  List<ExpenseData> get expenses => _expenses;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _fetchErrorMessage;
  String? get fetchErrorMessage => _fetchErrorMessage;

  // Response objects
  ExpenseResponse? _response;
  ExpenseResponse? get response => _response;

  UpdateExpenseResponse? _updateResponse;
  UpdateExpenseResponse? get updateResponse => _updateResponse;

  DeleteExpenseResponse? _deleteResponse;
  DeleteExpenseResponse? get deleteResponse => _deleteResponse;

  /// Reset all states
  void resetState() {
    _state = RequestState.idle;
    _errorMessage = null;
    _response = null;
    _updateResponse = null;
    _deleteResponse = null;
    notifyListeners();
  }

  /// Reset fetch state
  void resetFetchState() {
    _fetchState = RequestState.idle;
    _fetchErrorMessage = null;
    notifyListeners();
  }

  /// Private method to set state
  void _setState(RequestState state) {
    _state = state;
    notifyListeners();
  }

  /// Private method to set fetch state
  void _setFetchState(RequestState state) {
    _fetchState = state;
    notifyListeners();
  }

  /// Check internet connectivity
  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // ==================== FETCH OPERATIONS ====================

  /// Fetch expenses with optional filters
  Future<void> fetchExpenses({
    String? expenseType,
    String? paymentStatus,
    String? tag,
  }) async {
    _setFetchState(RequestState.loading);
    print("Step 1: Checking Internet...");

    // Check Internet Connection
    if (!await _checkConnectivity()) {
      _fetchErrorMessage = "No internet connection!";
      _setFetchState(RequestState.error);
      print("❌ Internet Not Available");
      return;
    }
    print("✅ Internet Available");

    try {
      // Use "all" if parameter is null or empty
      final url = Uri.parse(
        "https://abcwebservices.com/api/expenses/get_expenses.php"
            "?expense_type=${expenseType ?? 'all'}"
            "&payment_status=${paymentStatus ?? 'all'}"
            "&tag=${tag ?? 'all'}",
      );

      print("Step 2: Fetching API -> $url");

      // Add a timeout to prevent hanging requests
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      print("Step 3: Response Code -> ${response.statusCode}");
      print("Step 3: Raw Response -> ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);

          if (data['status'] == 'success') {
            final parsed = ExpensesResponse.fromJson(data);
            _expenses = parsed.data;
            print("Step 4: Expenses Parsed -> ${_expenses.length}");
            _setFetchState(RequestState.success);
          } else {
            _fetchErrorMessage = data['message'] ?? 'Unknown API error';
            _setFetchState(RequestState.error);
          }
        } catch (e) {
          _fetchErrorMessage = "Parsing error: $e";
          _setFetchState(RequestState.error);
        }
      } else {
        _fetchErrorMessage = "HTTP Error: ${response.statusCode}";
        _setFetchState(RequestState.error);
      }
    } on TimeoutException {
      _fetchErrorMessage = "Request timed out. Please try again.";
      _setFetchState(RequestState.error);
    } catch (e) {
      _fetchErrorMessage = "Exception: $e";
      _setFetchState(RequestState.error);
    }
  }

  /// Fetch fixed office expenses
  Future<void> fetchFixedOfficeExpenses() async {
    print("🔄 Fetching fixed office expenses...");
    
    if (!await _checkConnectivity()) {
      _setFetchState(RequestState.error);
      _fetchErrorMessage = "No Internet Connection";
      return;
    }

    try {
      _setFetchState(RequestState.loading);

      // Try the main endpoint first
      final url = Uri.parse("https://abcwebservices.com/api/expenses/get_fixed_office_expenses.php");
      final response = await http.get(url);

      print("📥 Fetch response received with status ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _expenses = (data['expenses'] as List).map((json) => ExpenseData.fromJson(json)).toList();
          _setFetchState(RequestState.success);
          print("✅ Fetched ${_expenses.length} expenses");
        } else {
          _setFetchState(RequestState.error);
          _fetchErrorMessage = data['message'] ?? "Failed to fetch expenses";
        }
      } else {
        // Try fallback endpoint
        await _tryFallbackEndpoint();
      }
    } catch (e) {
      print("⚠️ Main endpoint failed, trying fallback: $e");
      // Try fallback endpoint
      await _tryFallbackEndpoint();
    }
  }

  /// Try fallback endpoint for fetching expenses
  Future<void> _tryFallbackEndpoint() async {
    try {
      print("🔄 Trying fallback endpoint...");

      // Try to get expenses from the create expense endpoint or a general expenses endpoint
      final fallbackUrl = Uri.parse("https://abcwebservices.com/api/expenses/get_expenses.php");
      final response = await http.get(fallbackUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Filter for office expenses only
          final allExpenses = (data['expenses'] as List).map((json) => ExpenseData.fromJson(json)).toList();

          _expenses = allExpenses
              .where((expense) => expense.tag.toLowerCase().contains('office') || 
                                  expense.expenseType.toLowerCase().contains('office'))
              .toList();

          _setFetchState(RequestState.success);
          print("✅ Fetched ${_expenses.length} office expenses from fallback");
        } else {
          _setEmptyState();
        }
      } else {
        _setEmptyState();
      }
    } catch (e) {
      print("⚠️ Fallback endpoint also failed: $e");
      _setEmptyState();
    }
  }

  /// Set empty state when no expenses are available
  void _setEmptyState() {
    _expenses = [];
    _setFetchState(RequestState.success);
    _fetchErrorMessage = null;
    print("ℹ️ Set empty state - no expenses available");
  }

  // ==================== CREATE OPERATIONS ====================

  /// Create a new expense
  Future<void> createExpense(ExpenseRequest request) async {
    print("🔄 Step 1: Checking Internet...");
    
    if (!await _checkConnectivity()) {
      _setState(RequestState.error);
      _errorMessage = "No Internet Connection";
      print("❌ Step 1 Failed: No Internet");
      return;
    }

    try {
      _setState(RequestState.loading);
      print("⏳ Step 2: Sending request to API...");

      final url = Uri.parse("https://abcwebservices.com/api/expenses/create_expense.php");
      final response = await http.post(
        url, 
        headers: {"Content-Type": "application/json"}, 
        body: jsonEncode(request.toJson())
      );

      print("📥 Step 3: Response received with status ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _response = ExpenseResponse.fromJson(data);
        _setState(RequestState.success);
        print("✅ Step 4: Success - ${_response!.message}");

        // Refresh the expenses list after creating new expense
        await fetchFixedOfficeExpenses();
      } else {
        _setState(RequestState.error);
        _errorMessage = "Server error: ${response.statusCode}";
        print("❌ Step 4 Failed: Server error");

        // Add to local list when API fails
        addUserCreatedExpense(request);
      }
    } catch (e) {
      _setState(RequestState.error);
      _errorMessage = e.toString();
      print("⚠️ Step 5 Exception: $e");

      // Add to local list when there's an exception
      addUserCreatedExpense(request);
    }
  }

  /// Add user-created expense to local list when API fails
  void addUserCreatedExpense(ExpenseRequest request) {
    final userExpense = ExpenseData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tid: "",
      expenseType: request.expenseType,
      expenseName: request.expenseName,
      expenseAmount: request.expenseAmount,
      allocatedAmount: request.allocatedAmount,
      note: request.note,
      tag: request.tag,
      payByManager: request.payByManager,
      receivedByPerson: request.receivedByPerson,
      editBy: request.editBy,
      paymentStatus: request.paymentStatus,
      expenseDate: request.expenseDate,
      paymentType: request.paymentType ?? "",
      bankRefId: request.bankRefId ?? "",
      serviceTid: request.serviceTid ?? "",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    _expenses.insert(0, userExpense);
    notifyListeners();
    print("✅ Added user-created expense: ${userExpense.expenseName}");
  }

  // ==================== UPDATE OPERATIONS ====================

  /// Update an existing expense
  Future<void> updateExpense(Map<String, dynamic> body) async {
    const url = "https://abcwebservices.com/api/expenses/update_expense.php";

    print("Request Started");
    _setState(RequestState.loading);

    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: {"Content-Type": "application/json"},
          )
          .timeout(const Duration(seconds: 15));

      print("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _updateResponse = UpdateExpenseResponse.fromJson(data);
        _setState(RequestState.success);
        print("Success: ${_updateResponse?.message}");
      } else {
        _setState(RequestState.error);
        _errorMessage = "Server error: ${response.statusCode}";
        print("Error: $_errorMessage");
      }
    } on SocketException {
      _setState(RequestState.error);
      _errorMessage = "No Internet connection.";
      print("Error: $_errorMessage");
    } on HttpException {
      _setState(RequestState.error);
      _errorMessage = "Couldn't find the server.";
      print("Error: $_errorMessage");
    } on FormatException {
      _setState(RequestState.error);
      _errorMessage = "Bad response format.";
      print("Error: $_errorMessage");
    } on Exception catch (e) {
      _setState(RequestState.error);
      _errorMessage = "Unexpected error: $e";
      print("Error: $_errorMessage");
    }
  }

  // ==================== DELETE OPERATIONS ====================

  /// Delete an expense
  Future<void> deleteExpense(String tid) async {
    const url = "https://abcwebservices.com/api/expenses/delete_expense.php";

    _setState(RequestState.loading);
    print("🟡 DeleteExpense: Loading... tid=$tid");

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"tid": tid}),
        headers: {"Content-Type": "application/json"},
      );

      print("📡 API Called: $url");
      print("➡️ Request Body: { tid: $tid }");
      print("📥 Response Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _deleteResponse = DeleteExpenseResponse.fromJson(jsonData);

        if (_deleteResponse!.status) {
          _setState(RequestState.success);
          print("✅ Delete Success: ${_deleteResponse!.message}");
          
          // Remove from local list
          _expenses.removeWhere((expense) => expense.tid == tid);
          notifyListeners();
        } else {
          _setState(RequestState.error);
          print("❌ Delete Failed: ${_deleteResponse!.message}");
        }
      } else {
        _setState(RequestState.error);
        print("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _setState(RequestState.error);
      print("⚠️ Exception in deleteExpense: $e");
    }
  }
}

// ==================== DATA MODELS ====================

class ExpenseRequest {
  final String expenseName;
  final String expenseType;
  final String expenseDate;
  final double expenseAmount;
  final double allocatedAmount;
  final String note;
  final String tag;
  final String payByManager;
  final String receivedByPerson;
  final String editBy;
  final String paymentStatus;
  final String? paymentType;
  final String? bankRefId;
  final String? serviceTid;

  ExpenseRequest({
    required this.expenseName,
    required this.expenseType,
    required this.expenseDate,
    required this.expenseAmount,
    required this.allocatedAmount,
    required this.note,
    required this.tag,
    required this.payByManager,
    required this.receivedByPerson,
    required this.editBy,
    required this.paymentStatus,
    this.paymentType,
    this.bankRefId,
    this.serviceTid,
  });

  Map<String, dynamic> toJson() {
    return {
      "expense_name": expenseName,
      "expense_type": expenseType,
      "expense_date": expenseDate,
      "expense_amount": expenseAmount,
      "allocated_amount": allocatedAmount,
      "note": note,
      "tag": tag,
      "pay_by_manager": payByManager,
      "received_by_person": receivedByPerson,
      "edit_by": editBy,
      "payment_status": paymentStatus,
      "payment_type": paymentType ?? "",
      "bank_ref_id": bankRefId ?? "",
      "service_tid": serviceTid ?? "",
    };
  }
}

class ExpenseResponse {
  final bool success;
  final String message;

  ExpenseResponse({required this.success, required this.message});

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      success: json['success'] ?? false, 
      message: json['message'] ?? "Unknown response"
    );
  }
}

class UpdateExpenseResponse {
  final bool success;
  final String message;

  UpdateExpenseResponse({required this.success, required this.message});

  factory UpdateExpenseResponse.fromJson(Map<String, dynamic> json) {
    return UpdateExpenseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class DeleteExpenseResponse {
  final bool status;
  final String message;

  DeleteExpenseResponse({
    required this.status,
    required this.message,
  });

  factory DeleteExpenseResponse.fromJson(Map<String, dynamic> json) {
    return DeleteExpenseResponse(
      status: json["status"] == "success" || json["status"] == 1,
      message: json["message"] ?? "",
    );
  }
}

class ExpenseData {
  final String id;
  final String tid;
  final String expenseType;
  final String expenseName;
  final double expenseAmount;
  final double allocatedAmount;
  final String note;
  final String tag;
  final String payByManager;
  final String receivedByPerson;
  final String editBy;
  final String paymentStatus;
  final String paymentType;
  final String bankRefId;
  final String serviceTid;
  final String expenseDate;
  final String createdAt;
  final String updatedAt;

  ExpenseData({
    required this.id,
    required this.tid,
    required this.expenseType,
    required this.expenseName,
    required this.expenseAmount,
    required this.allocatedAmount,
    required this.note,
    required this.tag,
    required this.payByManager,
    required this.receivedByPerson,
    required this.editBy,
    required this.paymentStatus,
    required this.paymentType,
    required this.bankRefId,
    required this.serviceTid,
    required this.expenseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      id: json['id']?.toString() ?? '',
      tid: json['tid'] ?? '',
      expenseType: json['expense_type'] ?? '',
      expenseName: json['expense_name'] ?? '',
      expenseAmount: double.tryParse(json['expense_amount']?.toString() ?? '0') ?? 0,
      allocatedAmount: double.tryParse(json['allocated_amount']?.toString() ?? '0') ?? 0,
      note: json['note'] ?? '',
      tag: json['tag'] ?? '',
      payByManager: json['pay_by_manager'] ?? '',
      receivedByPerson: json['received_by_person'] ?? '',
      editBy: json['edit_by'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentType: json['payment_type'] ?? '',
      bankRefId: json['bank_ref_id'] ?? '',
      serviceTid: json['service_tid'] ?? '',
      expenseDate: json['expense_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class ExpensesResponse {
  final String status;
  final int count;
  final List<ExpenseData> data;

  ExpensesResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory ExpensesResponse.fromJson(Map<String, dynamic> json) {
    return ExpensesResponse(
      status: json["status"] ?? "error",
      count: json["count"] ?? 0,
      data: (json["data"] as List)
          .map((e) => ExpenseData.fromJson(e))
          .toList(),
    );
  }
}