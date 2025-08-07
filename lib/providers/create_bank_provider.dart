// providers/bank_create_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/request_state.dart';

class BankCreateProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? selectedBankName;
  List<String> createdBanksList = [];

  /// Set bank name from textfield/dropdown
  void setBankName(String value) {
    selectedBankName = value;
    print("✅ Selected bank name set: $value");
  }

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Create Bank API
  Future<void> createBank(BankCreateRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("saved_bank_name");

    print("📌 Previously saved: $saved");
    print("📌 New Bank Name: ${request.bankName}");

    // Skip API if same as saved
    if (saved == request.bankName) {
      print("⚠️ Same Bank Name → Skipping API call");
      state = RequestState.success;
      notifyListeners();
      return;
    }

    try {
      print("⏳ Sending bank creation request to API...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/create_bank.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      final res = BankCreateResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        await prefs.setString("saved_bank_name", request.bankName);
        createdBanksList.add(request.bankName);
        print("💾 Bank saved locally: ${request.bankName}");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ API Error: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get saved bank name
  Future<String?> getSavedBankName() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("saved_bank_name");
    print("📌 Retrieved saved bank name: $saved");
    return saved;
  }

  /// Get locally created bank list
  List<String> getCreatedBanksList() {
    return createdBanksList;
  }
}
// models/bank_create_response.dart
class BankCreateResponse {
  final String status;
  final String message;

  BankCreateResponse({
    required this.status,
    required this.message,
  });

  factory BankCreateResponse.fromJson(Map<String, dynamic> json) {
    return BankCreateResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/bank_create_request.dart
class BankCreateRequest {
  final String bankName;
  final String userId;
  final String createdBy;

  BankCreateRequest({
    required this.bankName,
    required this.userId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "bank_name": bankName,
      "user_id": userId,
      "created_by": createdBy,
    };
  }
}
