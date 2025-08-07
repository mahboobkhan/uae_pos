// providers/update_user_bank_account_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/request_state.dart';

class UpdateUserBankAccountProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Update Bank Account
  Future<void> updateBankAccount(UpdateUserBankAccountRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    try {
      print("⏳ Updating bank account...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/update_user_bank_account.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Response: ${response.body}");
      final data = jsonDecode(response.body);
      final res = UpdateUserBankAccountResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        print("✅ Bank account updated successfully");

        // Save last updated account locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("last_updated_bank_account", jsonEncode(request.toJson()));
        print("💾 Saved last updated bank account locally");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ Update failed: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get last updated bank account from SharedPreferences
  Future<Map<String, dynamic>?> getLastUpdatedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_updated_bank_account");
    if (saved != null) {
      print("📌 Retrieved last updated bank account");
      return jsonDecode(saved);
    }
    return null;
  }
}
// models/update_user_bank_account_response.dart
class UpdateUserBankAccountResponse {
  final String status;
  final String message;

  UpdateUserBankAccountResponse({
    required this.status,
    required this.message,
  });

  factory UpdateUserBankAccountResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserBankAccountResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/update_user_bank_account_request.dart
class UpdateUserBankAccountRequest {
  final String userId;
  final String bankName;
  final String branchCode;
  final String bankAddress;
  final String titleName;
  final String bankAccountNumber;
  final String ibanNumber;
  final String contactNumber;
  final String emailId;
  final String additionalNote;

  UpdateUserBankAccountRequest({
    required this.userId,
    required this.bankName,
    required this.branchCode,
    required this.bankAddress,
    required this.titleName,
    required this.bankAccountNumber,
    required this.ibanNumber,
    required this.contactNumber,
    required this.emailId,
    required this.additionalNote,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "bank_name": bankName,
      "branch_code": branchCode,
      "bank_address": bankAddress,
      "title_name": titleName,
      "bank_account_number": bankAccountNumber,
      "iban_number": ibanNumber,
      "contact_number": contactNumber,
      "email_id": emailId,
      "additional_note": additionalNote,
    };
  }
}
