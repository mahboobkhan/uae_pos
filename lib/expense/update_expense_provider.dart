// lib/providers/update_expense_provider.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/request_state.dart';

class UpdateExpenseProvider extends ChangeNotifier {
  RequestState _state = RequestState.idle;

  RequestState get state => _state;

  UpdateExpenseResponse? _response;

  UpdateExpenseResponse? get response => _response;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // For debugging logs
  void _printStep(String step) {
    debugPrint("[UpdateExpense] $step");
  }

  Future<void> updateExpense(Map<String, dynamic> body) async {
    const url = "https://abcwebservices.com/api/expenses/update_expense.php";

    _printStep("Request Started");
    _state = RequestState.loading;
    notifyListeners();

    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: {"Content-Type": "application/json"},
          )
          .timeout(const Duration(seconds: 15));

      _printStep("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _response = UpdateExpenseResponse.fromJson(data);
        _state = RequestState.success;
        _printStep("Success: ${_response?.message}");
      } else {
        _state = RequestState.error;
        _errorMessage = "Server error: ${response.statusCode}";
        _printStep("Error: $_errorMessage");
      }
    } on SocketException {
      _state = RequestState.error;
      _errorMessage = "No Internet connection.";
      _printStep("Error: $_errorMessage");
    } on HttpException {
      _state = RequestState.error;
      _errorMessage = "Couldn't find the server.";
      _printStep("Error: $_errorMessage");
    } on FormatException {
      _state = RequestState.error;
      _errorMessage = "Bad response format.";
      _printStep("Error: $_errorMessage");
    } on Exception catch (e) {
      _state = RequestState.error;
      _errorMessage = "Unexpected error: $e";
      _printStep("Error: $_errorMessage");
    }

    notifyListeners();
  }
}

// lib/models/update_expense_response.dart
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
