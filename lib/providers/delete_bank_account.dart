import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class DeleteUserBankAccountProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Delete Bank Account
  Future<void> deleteBankAccount(DeleteUserBankAccountRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    try {
      print("⏳ Deleting bank account...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/delete_user_bank_account.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Response: ${response.body}");
      final data = jsonDecode(response.body);
      final res = DeleteUserBankAccountResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        print("✅ Bank account deleted successfully");

        // Save last deleted account locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("last_deleted_bank_account", jsonEncode(request.toJson()));
        print("💾 Saved last deleted bank account locally");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ Deletion failed: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get last deleted bank account from SharedPreferences
  Future<Map<String, dynamic>?> getLastDeletedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_deleted_bank_account");
    if (saved != null) {
      print("📌 Retrieved last deleted bank account");
      return jsonDecode(saved);
    }
    return null;
  }
}
// models/delete_user_bank_account_request.dart
class DeleteUserBankAccountRequest {
  final String ibanNumber;
  final String bankAccountNumber;
  final String bankName;
  final String titleName;

  DeleteUserBankAccountRequest({
    required this.ibanNumber,
    required this.bankAccountNumber,
    required this.bankName,
    required this.titleName,
  });

  Map<String, dynamic> toJson() {
    return {
      "iban_number": ibanNumber,
      "bank_account_number": bankAccountNumber,
      "bank_name": bankName,
      "title_name": titleName,
    };
  }
}
// models/delete_user_bank_account_response.dart
class DeleteUserBankAccountResponse {
  final String status;
  final String message;

  DeleteUserBankAccountResponse({
    required this.status,
    required this.message,
  });

  factory DeleteUserBankAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteUserBankAccountResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
