// providers/create_user_bank_account_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class CreateUserBankAccountProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Create Bank Account
  Future<void> createBankAccount(CreateUserBankAccountRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    try {
      print("⏳ Creating bank account...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/create_user_bank_account.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Response: ${response.body}");
      final data = jsonDecode(response.body);
      final res = CreateUserBankAccountResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        print("✅ Bank account created successfully");

        // Save last created account locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("last_created_bank_account", jsonEncode(request.toJson()));
        print("💾 Saved last created bank account locally");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ Creation failed: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get last saved bank account from SharedPreferences
  Future<Map<String, dynamic>?> getLastSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_created_bank_account");
    if (saved != null) {
      print("📌 Retrieved last saved bank account");
      return jsonDecode(saved);
    }
    return null;
  }
}
// models/create_user_bank_account_response.dart
class CreateUserBankAccountResponse {
  final String status;
  final String message;

  CreateUserBankAccountResponse({
    required this.status,
    required this.message,
  });

  factory CreateUserBankAccountResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserBankAccountResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/create_user_bank_account_request.dart
class CreateUserBankAccountRequest {
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
  final String createdBy;

  CreateUserBankAccountRequest({
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
    required this.createdBy,
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
      "created_by": createdBy,
    };
  }
}
