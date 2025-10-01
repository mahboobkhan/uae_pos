// providers/bank_delete_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/request_state.dart';

class BankDeleteProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? selectedBankName;
  List<String> deletedBanksList = [];

  /// Set bank name to delete
  void setBankName(String value) {
    selectedBankName = value;
    print("🏦 Selected bank for delete: $value");
  }

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Delete Bank API
  Future<void> deleteBank(BankDeleteRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final lastDeleted = prefs.getString("last_deleted_bank");

    print("📌 Last deleted bank: $lastDeleted");
    print("📌 Request to delete: ${request.bankName}");

    // Prevent duplicate delete call
    if (lastDeleted == request.bankName) {
      print("⚠️ Bank already deleted recently → Skipping API call");
      state = RequestState.success;
      notifyListeners();
      return;
    }

    try {
      print("⏳ Sending delete bank request...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/delete_bank_by_name.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      final res = BankDeleteResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;

        // Save locally
        await prefs.setString("last_deleted_bank", request.bankName);
        deletedBanksList.add(request.bankName);
        print("💾 Saved deleted bank locally: ${request.bankName}");
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

  /// Get last deleted bank
  Future<String?> getLastDeletedBank() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_deleted_bank");
    print("📌 Retrieved last deleted bank: $saved");
    return saved;
  }

  /// Get all locally deleted banks
  List<String> getDeletedBanksList() {
    return deletedBanksList;
  }
}
// models/bank_delete_response.dart
class BankDeleteResponse {
  final String status;
  final String message;

  BankDeleteResponse({
    required this.status,
    required this.message,
  });

  factory BankDeleteResponse.fromJson(Map<String, dynamic> json) {
    return BankDeleteResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/bank_delete_request.dart
class BankDeleteRequest {
  final String bankName;
  final String? userId;

  BankDeleteRequest({
    required this.bankName,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "bank_name": bankName,
      if (userId != null) "user_id": userId,
    };
  }
}
