import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/request_state.dart';

class UpdateUserBankAccountProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  static const String _apiUrl =
      "https://abcwebservices.com/api/employee/update_user_bank_account.php";
  static const String _localStorageKey = "last_updated_bank_account";

  /// Check for active internet connection
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Update user bank account via API
  Future<void> updateBankAccount(UpdateUserBankAccountRequest request) async {
    if (!await _hasInternet()) {
      _setError("No internet connection");
      return;
    }

    try {
      _setLoading();

      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print("📥 API Response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final res = UpdateUserBankAccountResponse.fromJson(json);

        if (res.status == "success") {
          _setSuccess();
          await _saveToLocal(request);
        } else {
          _setError(res.message);
        }
      } else {
        _setError("Server error: ${response.statusCode}");
      }
    } on SocketException {
      _setError("No internet connection (socket)");
    } on http.ClientException catch (e) {
      _setError("Client error: ${e.message}");
    } on TimeoutException {
      _setError("Request timed out");
    } catch (e) {
      _setError("Unexpected error: $e");
    }
  }

  /// Save last updated account locally
  Future<void> _saveToLocal(UpdateUserBankAccountRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localStorageKey, jsonEncode(request.toJson()));
    print("💾 Saved last updated bank account locally");
  }

  /// Retrieve last saved account (optional use)
  Future<Map<String, dynamic>?> getLastUpdatedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_localStorageKey);
    if (saved != null) {
      print("📌 Retrieved last updated bank account from local storage");
      return jsonDecode(saved);
    }
    return null;
  }

  /// Set provider state to loading
  void _setLoading() {
    state = RequestState.loading;
    errorMessage = null;
    notifyListeners();
    print("⏳ Updating bank account...");
  }

  /// Set provider state to success
  void _setSuccess() {
    state = RequestState.success;
    errorMessage = null;
    notifyListeners();
    print("✅ Bank account updated successfully");
  }

  /// Set provider state to error with message
  void _setError(String message) {
    state = RequestState.error;
    errorMessage = message;
    notifyListeners();
    print("❌ $message");
  }
}

// models/update_user_bank_account_response.dart
class UpdateUserBankAccountResponse {
  final String status;
  final String message;

  UpdateUserBankAccountResponse({required this.status, required this.message});

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
