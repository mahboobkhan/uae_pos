// providers/bank_update_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/request_state.dart';

class BankUpdateProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? selectedCurrentBank;
  String? selectedNewBank;
  List<String> updatedBanksList = [];

  /// Set current bank name
  void setCurrentBank(String value) {
    selectedCurrentBank = value;
    print("🏦 Current bank set: $value");
  }

  /// Set new bank name
  void setNewBank(String value) {
    selectedNewBank = value;
    print("🆕 New bank name set: $value");
  }

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Update Bank API
  Future<void> updateBank(BankUpdateRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_updated_bank");

    print("📌 Previously updated bank: $saved");
    print("📌 Trying to update: ${request.currentName} → ${request.newName}");

    // Skip if already updated to same name
    if (saved == request.newName) {
      print("⚠️ Same as last updated → Skipping API");
      state = RequestState.success;
      notifyListeners();
      return;
    }

    try {
      print("⏳ Sending update bank request...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/update_bank.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      final res = BankUpdateResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;

        // Save last updated
        await prefs.setString("last_updated_bank", request.newName);
        updatedBanksList.add("${request.currentName} → ${request.newName}");
        print("💾 Saved updated bank locally: ${request.newName}");
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

  /// Get last updated bank
  Future<String?> getLastUpdatedBank() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_updated_bank");
    print("📌 Retrieved last updated bank: $saved");
    return saved;
  }

  /// Get all locally updated banks list
  List<String> getUpdatedBanksList() {
    return updatedBanksList;
  }
}
// models/bank_update_response.dart
class BankUpdateResponse {
  final String status;
  final String message;

  BankUpdateResponse({
    required this.status,
    required this.message,
  });

  factory BankUpdateResponse.fromJson(Map<String, dynamic> json) {
    return BankUpdateResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/bank_update_request.dart
class BankUpdateRequest {
  final String currentName;
  final String newName;
  final String? userId;

  BankUpdateRequest({
    required this.currentName,
    required this.newName,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "current_name": currentName,
      "new_name": newName,
      if (userId != null) "user_id": userId,
    };
  }
}
