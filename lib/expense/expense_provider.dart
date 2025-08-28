import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/request_state.dart';

class ExpensesProvider extends ChangeNotifier {
  RequestState _state = RequestState.idle;
  RequestState get state => _state;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// ✅ Fetch Expenses API
  Future<void> fetchExpenses({
    String expenseType = "all",
    String paymentStatus = "pending",
    String tag = "all",
  }) async {
    _setState(RequestState.loading);
    print("Step 1: Checking Internet...");

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _errorMessage = "No internet connection!";
      _setState(RequestState.error);
      print("❌ Internet Not Available");
      return;
    }
    print("✅ Internet Available");

    try {
      final url = Uri.parse(
        "https://abcwebservices.com/api/expenses/get_expenses.php"
            "?expense_type=$expenseType&payment_status=$paymentStatus&tag=$tag",
      );

      print("Step 2: Fetching API -> $url");
      final response = await http.get(url);

      print("Step 3: Response Code -> ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Step 3: Response Body -> ${response.body}");

        try {
          final parsed = ExpensesResponse.fromJson(data);
          _expenses = parsed.data;
          print("Step 4: Expenses Parsed -> ${_expenses.length}");
          _setState(RequestState.success);
        } catch (e) {
          _errorMessage = "Parsing error: $e";
          _setState(RequestState.error);
        }
      } else {
        _errorMessage = "Error Code: ${response.statusCode}";
        _setState(RequestState.error);
      }
    } catch (e) {
      _errorMessage = "Exception: $e";
      _setState(RequestState.error);
    }
  }

  /// ✅ Private function to update state
  void _setState(RequestState state) {
    _state = state;
    notifyListeners();
  }
}

//
// 🔹 API Response Model
//
class ExpensesResponse {
  final String status;
  final int count;
  final List<Expense> data;

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
          .map((e) => Expense.fromJson(e))
          .toList(),
    );
  }
}

//
// 🔹 Expense Model
//
class Expense {
  final String id;
  final String tid;
  final String expenseName;
  final String expenseType;
  final String expenseAmount;
  final String note;
  final String tag;
  final String paymentStatus;
  final String expenseDate;
  final String allocatedAmount;
  final String remainsAmount;
  final String payByManager;
  final String receivedByPerson;
  final String editBy;
  final String lastUpdate;
  final String createdAt;
  final String updatedAt;

  Expense({
    required this.id,
    required this.tid,
    required this.expenseName,
    required this.expenseType,
    required this.expenseAmount,
    required this.note,
    required this.tag,
    required this.paymentStatus,
    required this.expenseDate,
    required this.allocatedAmount,
    required this.remainsAmount,
    required this.payByManager,
    required this.receivedByPerson,
    required this.editBy,
    required this.lastUpdate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id']?.toString() ?? '',
      tid: json['tid'] ?? '',
      expenseName: json['expense_name'] ?? '',
      expenseType: json['expense_type'] ?? '',
      expenseAmount: json['expense_amount']?.toString() ?? '',
      note: json['note'] ?? '',
      tag: json['tag'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      expenseDate: json['expense_date'] ?? '',
      allocatedAmount: json['allocated_amount']?.toString() ?? '',
      remainsAmount: json['remains_amount']?.toString() ?? '',
      payByManager: json['pay_by_manager'] ?? '',
      receivedByPerson: json['received_by_person'] ?? '',
      editBy: json['edit_by'] ?? '',
      lastUpdate: json['last_update'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
