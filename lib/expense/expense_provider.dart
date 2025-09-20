import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/request_state.dart';
import 'expense_create_provider.dart';

class ExpensesProvider extends ChangeNotifier {
  RequestState _state = RequestState.idle;
  RequestState get state => _state;

  List<ExpenseData> _expenses = [];
  List<ExpenseData> get expenses => _expenses;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// ✅ Fetch Expenses API
  Future<void> fetchExpenses({
    String? expenseType,
    String? paymentStatus,
    String? tag,
  }) async {
    _setState(RequestState.loading);
    print("Step 1: Checking Internet...");

    // ✅ Check Internet Connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _errorMessage = "No internet connection!";
      _setState(RequestState.error);
      print("❌ Internet Not Available");
      return;
    }
    print("✅ Internet Available");

    try {
      // ✅ Use "all" if parameter is null or empty
      final url = Uri.parse(
        "https://abcwebservices.com/api/expenses/get_expenses.php"
            "?expense_type=${expenseType ?? 'all'}"
            "&payment_status=${paymentStatus ?? 'all'}"
            "&tag=${tag ?? 'all'}",
      );

      print("Step 2: Fetching API -> $url");

      // ✅ Add a timeout to prevent hanging requests
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
            _setState(RequestState.success);
          } else {
            _errorMessage = data['message'] ?? 'Unknown API error';
            _setState(RequestState.error);
          }
        } catch (e) {
          _errorMessage = "Parsing error: $e";
          _setState(RequestState.error);
        }
      } else {
        _errorMessage = "HTTP Error: ${response.statusCode}";
        _setState(RequestState.error);
      }
    } on TimeoutException {
      _errorMessage = "Request timed out. Please try again.";
      _setState(RequestState.error);
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
