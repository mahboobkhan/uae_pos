// providers/delete_monthly_salary_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class DeleteMonthlySalaryProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  /// Check internet connection
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Delete Monthly Salary Record
  Future<void> deleteMonthlySalary(DeleteMonthlySalaryRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    try {
      print("⏳ Sending delete request for monthly salary...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/delete_monthly_salary.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);
      final res = DeleteMonthlySalaryResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        print("✅ Monthly salary deleted successfully");

        // Save locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("last_deleted_salary", jsonEncode(request.toJson()));
        print("💾 Saved deleted salary info locally");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ Delete failed: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get last deleted salary record
  Future<Map<String, dynamic>?> getLastDeletedSalary() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_deleted_salary");
    if (saved != null) {
      print("📌 Retrieved last deleted salary record");
      return jsonDecode(saved);
    }
    return null;
  }
}
// models/delete_monthly_salary_request.dart
class DeleteMonthlySalaryRequest {
  final String userId;
  final String salaryMonth;

  DeleteMonthlySalaryRequest({
    required this.userId,
    required this.salaryMonth,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "salary_month": salaryMonth,
    };
  }
}
// models/delete_monthly_salary_response.dart
class DeleteMonthlySalaryResponse {
  final String status;
  final String message;

  DeleteMonthlySalaryResponse({
    required this.status,
    required this.message,
  });

  factory DeleteMonthlySalaryResponse.fromJson(Map<String, dynamic> json) {
    return DeleteMonthlySalaryResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
