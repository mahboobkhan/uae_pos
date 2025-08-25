// providers/expense_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/request_state.dart';

class ExpenseProvider extends ChangeNotifier {
  RequestState _state = RequestState.idle;
  RequestState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ExpenseResponse? _response;
  ExpenseResponse? get response => _response;

  // For fetching expenses list
  List<ExpenseData> _expenses = [];
  List<ExpenseData> get expenses => _expenses;

  RequestState _fetchState = RequestState.idle;
  RequestState get fetchState => _fetchState;

  String? _fetchErrorMessage;
  String? get fetchErrorMessage => _fetchErrorMessage;

  Future<void> createExpense(ExpenseRequest request) async {
    print("🔄 Step 1: Checking Internet...");
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      _state = RequestState.error;
      _errorMessage = "No Internet Connection";
      notifyListeners();
      print("❌ Step 1 Failed: No Internet");
      return;
    }

    try {
      _state = RequestState.loading;
      notifyListeners();
      print("⏳ Step 2: Sending request to API...");

      final url = Uri.parse("https://abcwebservices.com/api/expenses/create_expense.php");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 Step 3: Response received with status ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _response = ExpenseResponse.fromJson(data);
        _state = RequestState.success;
        print("✅ Step 4: Success - ${_response!.message}");
        
        // Refresh the expenses list after creating new expense
        await fetchFixedOfficeExpenses();
      } else {
        _state = RequestState.error;
        _errorMessage = "Server error: ${response.statusCode}";
        print("❌ Step 4 Failed: Server error");
        
        // Add to local list when API fails
        addUserCreatedExpense(request);
      }
    } catch (e) {
      _state = RequestState.error;
      _errorMessage = e.toString();
      print("⚠️ Step 5 Exception: $e");
      
      // Add to local list when there's an exception
      addUserCreatedExpense(request);
    }

    notifyListeners();
  }

  Future<void> fetchFixedOfficeExpenses() async {
    print("🔄 Fetching fixed office expenses...");
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      _fetchState = RequestState.error;
      _fetchErrorMessage = "No Internet Connection";
      notifyListeners();
      return;
    }

    try {
      _fetchState = RequestState.loading;
      notifyListeners();

      // Try the main endpoint first
      final url = Uri.parse("https://abcwebservices.com/api/expenses/get_fixed_office_expenses.php");
      final response = await http.get(url);

      print("📥 Fetch response received with status ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _expenses = (data['expenses'] as List)
              .map((json) => ExpenseData.fromJson(json))
              .toList();
          _fetchState = RequestState.success;
          print("✅ Fetched ${_expenses.length} expenses");
        } else {
          _fetchState = RequestState.error;
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
          final allExpenses = (data['expenses'] as List)
              .map((json) => ExpenseData.fromJson(json))
              .toList();
          
          _expenses = allExpenses.where((expense) => 
            expense.tag.toLowerCase().contains('office') || 
            expense.expenseType.toLowerCase().contains('office')
          ).toList();
          
          _fetchState = RequestState.success;
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

  void _setEmptyState() {
    _expenses = [];
    _fetchState = RequestState.success;
    _fetchErrorMessage = null;
    print("ℹ️ Set empty state - no expenses available");
  }

  // Method to add user-created expense to local list when API fails
  void addUserCreatedExpense(ExpenseRequest request) {
    final userExpense = ExpenseData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
      createdAt: DateTime.now().toIso8601String(),
    );
    
    _expenses.insert(0, userExpense);
    notifyListeners();
    print("✅ Added user-created expense: ${userExpense.expenseName}");
  }
}
// models/expense_model.dart
class ExpenseRequest {
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
  final String expenseDate;

  ExpenseRequest({
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
    required this.expenseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "expense_type": expenseType,
      "expense_name": expenseName,
      "expense_amount": expenseAmount,
      "allocated_amount": allocatedAmount,
      "note": note,
      "tag": tag,
      "pay_by_manager": payByManager,
      "received_by_person": receivedByPerson,
      "edit_by": editBy,
      "payment_status": paymentStatus,
      "expense_date": expenseDate,
    };
  }
}

class ExpenseResponse {
  final bool success;
  final String message;

  ExpenseResponse({
    required this.success,
    required this.message,
  });

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "Unknown response",
    );
  }
}

class ExpenseData {
  final String id;
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
  final String expenseDate;
  final String createdAt;

  ExpenseData({
    required this.id,
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
    required this.expenseDate,
    required this.createdAt,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      id: json['id']?.toString() ?? '',
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
      expenseDate: json['expense_date'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
