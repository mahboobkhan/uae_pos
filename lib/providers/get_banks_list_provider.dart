// providers/bank_list_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class BankListProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  List<BankModel> banks = [];

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Get all banks from API
  Future<void> fetchBanks() async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    try {
      print("⏳ Fetching banks list...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.get(
        Uri.parse("https://abcwebservices.com/api/employee/get_all_banks.php"),
        headers: {"Content-Type": "application/json"},
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      final res = BankListResponse.fromJson(data);

      if (res.status == "success") {
        banks = res.data;
        state = RequestState.success;

        // Save locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("banks_cache", jsonEncode(banks.map((e) => e.toJson()).toList()));
        print("💾 Saved banks list locally: ${banks.length} items");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ Fetch failed: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get saved banks from SharedPreferences
  Future<List<BankModel>> getSavedBanks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("banks_cache");
    if (saved != null) {
      final List decoded = jsonDecode(saved);
      banks = decoded.map((e) => BankModel.fromJson(e)).toList();
      print("📌 Loaded saved banks list: ${banks.length} items");
    }
    return banks;
  }
}
// models/bank_list_response.dart

class BankListResponse {
  final String status;
  final String message;
  final List<BankModel> data;

  BankListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BankListResponse.fromJson(Map<String, dynamic> json) {
    var list = (json["data"] as List?) ?? [];
    List<BankModel> banks = list.map((e) => BankModel.fromJson(e)).toList();

    return BankListResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      data: banks,
    );
  }
}
// models/bank_model.dart
class BankModel {
  final int id;
  final String userId;
  final String bankName;
  final String createdBy;
  final String createdDate;

  BankModel({
    required this.id,
    required this.userId,
    required this.bankName,
    required this.createdBy,
    required this.createdDate,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? "",
      bankName: json["bank_name"] ?? "",
      createdBy: json["created_by"] ?? "",
      createdDate: json["created_date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "bank_name": bankName,
      "created_by": createdBy,
      "created_date": createdDate,
    };
  }
}
